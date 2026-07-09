import 'dart:convert';
import 'dart:typed_data';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/security/cryptography_helper.dart';
import 'datasources/vault_local_datasource.dart';
import 'datasources/vault_remote_datasource.dart';
import 'models/vault_entry_model.dart';
import '../domain/entities/vault_entry.dart';

part 'vault_repository.g.dart';

/// Repository coordinating between local Hive datasource and remote Firestore sync.
class VaultRepository {
  final VaultLocalDatasource _local = VaultLocalDatasource();
  final VaultRemoteDatasource _remote = VaultRemoteDatasource();
  Uint8List? _encryptionKey;

  /// Check if the local database is open.
  bool get isOpen => _local.isOpen;

  /// Open the encrypted box and cache derived encryption key.
  Future<void> openBox(Uint8List derivedKey) async {
    _encryptionKey = derivedKey;
    await _local.openBox(derivedKey);
  }

  /// Close the local box and wipe cached key from memory.
  Future<void> closeBox() async {
    await _local.closeBox();
    _encryptionKey = null;
  }

  /// Wipe the local database and delete its physical file from disk.
  Future<void> wipeLocalDatabase() async {
    await _local.deleteBox();
    _encryptionKey = null;
  }

  /// Get current Firebase user ID.
  String? get _currentUid {
    if (Firebase.apps.isEmpty) return null;
    return FirebaseAuth.instance.currentUser?.uid;
  }

  /// Get all entries locally.
  Future<List<VaultEntry>> getEntries() async {
    return _local.getEntries();
  }

  /// Add or update an entry locally and schedule a remote Firestore upload.
  Future<void> saveEntry(VaultEntry entry) async {
    // 1. Write to local Hive immediately for instant UI response
    await _local.saveEntry(entry);

    // 2. Sync to Firestore in the background if authenticated
    final uid = _currentUid;
    if (uid != null && _encryptionKey != null) {
      try {
        final dto = VaultEntryModel.fromEntity(entry);
        final jsonStr = jsonEncode(dto.toJson());
        final gcm = await CryptographyHelper.encryptGcm(_encryptionKey!, utf8.encode(jsonStr));

        // Firestore client automatically handles offline queuing and write retries
        _remote.saveEncryptedEntry(uid, entry.id, {
          'ciphertext': gcm.ciphertext,
          'iv': gcm.iv,
          'tag': gcm.tag,
          'updatedAt': FieldValue.serverTimestamp(),
          'deleted': false,
        }).catchError((_) {});
      } catch (_) {}
    }
  }

  /// Delete an entry locally and write a soft-delete document to remote Firestore.
  Future<void> deleteEntry(String id) async {
    // 1. Delete from Hive locally
    await _local.deleteEntry(id);

    // 2. Push soft-delete record to remote so other devices can reconcile the deletion
    final uid = _currentUid;
    if (uid != null) {
      try {
        _remote.saveEncryptedEntry(uid, id, {
          'ciphertext': '',
          'iv': '',
          'tag': '',
          'updatedAt': FieldValue.serverTimestamp(),
          'deleted': true,
        }).catchError((_) {});
      } catch (_) {}
    }
  }

  /// Bidirectional sync: Pull remote changes, resolve conflicts (last-write-wins), push local changes.
  Future<void> sync() async {
    final uid = _currentUid;
    if (uid == null || _encryptionKey == null) return;

    try {
      // 1. Fetch remote documents and current local entries
      final remoteDocs = await _remote.getEncryptedEntries(uid);
      final localEntries = await _local.getEntries();

      final localMap = {for (final e in localEntries) e.id: e};
      final remoteProcessedIds = <String>{};

      for (final doc in remoteDocs) {
        final entryId = doc.id;
        remoteProcessedIds.add(entryId);

        final data = doc.data();
        final isDeleted = data['deleted'] as bool? ?? false;
        final remoteTime = (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.fromMillisecondsSinceEpoch(0);

        final localEntry = localMap[entryId];

        if (localEntry == null) {
          // New remote entry (not present locally)
          if (!isDeleted) {
            final entry = await _decryptRemoteEntry(data);
            await _local.saveEntry(entry);
          }
        } else {
          // Present in both - check conflict using last-write-wins
          final localTime = localEntry.updatedAt;

          if (remoteTime.isAfter(localTime)) {
            if (isDeleted) {
              await _local.deleteEntry(entryId);
            } else {
              final entry = await _decryptRemoteEntry(data);
              await _local.saveEntry(entry);
            }
          } else if (localTime.isAfter(remoteTime)) {
            // Local is newer - re-upload to Firestore
            await saveEntry(localEntry);
          }
        }
      }

      // 2. Upload local entries that do not exist remotely
      for (final localEntry in localEntries) {
        if (!remoteProcessedIds.contains(localEntry.id)) {
          await saveEntry(localEntry);
        }
      }
    } catch (e) {
      throw Failure.databaseError('Synchronization failed: $e');
    }
  }

  Future<VaultEntry> _decryptRemoteEntry(Map<String, dynamic> data) async {
    final decryptedBytes = await CryptographyHelper.decryptGcm(
      key: _encryptionKey!,
      ciphertextBase64: data['ciphertext'] as String,
      ivBase64: data['iv'] as String,
      tagBase64: data['tag'] as String,
    );
    final jsonMap = jsonDecode(utf8.decode(decryptedBytes)) as Map<String, dynamic>;
    return VaultEntryModel.fromJson(jsonMap).toEntity();
  }
}

@Riverpod(keepAlive: true)
VaultRepository vaultRepository(VaultRepositoryRef ref) {
  final repo = VaultRepository();
  ref.onDispose(() {
    repo.closeBox();
  });
  return repo;
}
