import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../core/error/failures.dart';
import '../models/vault_entry_model.dart';
import '../../domain/entities/vault_entry.dart';

/// Local datasource wrapping Hive box operations.
class VaultLocalDatasource {
  Box<Map>? _box;
  static const String boxName = 'secure_vault_entries_box';

  /// Open the encrypted box using the derived encryption key.
  Future<void> openBox(Uint8List derivedKey) async {
    if (_box != null && _box!.isOpen) return;
    try {
      _box = await Hive.openBox<Map>(
        boxName,
        encryptionCipher: HiveAesCipher(derivedKey),
      );
    } catch (e) {
      throw Failure.databaseError('Failed to open local database: $e');
    }
  }

  /// Close the box.
  Future<void> closeBox() async {
    if (_box != null && _box!.isOpen) {
      await _box!.close();
      _box = null;
    }
  }

  /// Check if the box is open.
  bool get isOpen => _box != null && _box!.isOpen;

  Box<Map> _getOpenBox() {
    if (_box == null || !_box!.isOpen) {
      throw const Failure.databaseError('Database is not open. Vault is locked.');
    }
    return _box!;
  }

  /// Get all entries.
  Future<List<VaultEntry>> getEntries() async {
    try {
      final box = _getOpenBox();
      final List<VaultEntry> entries = [];
      for (final key in box.keys) {
        final rawMap = box.get(key);
        if (rawMap != null) {
          final Map<String, dynamic> typedMap = Map<String, dynamic>.from(rawMap);
          final dto = VaultEntryModel.fromJson(typedMap);
          entries.add(dto.toEntity());
        }
      }
      return entries;
    } catch (e) {
      throw Failure.databaseError('Failed to retrieve local credentials: $e');
    }
  }

  /// Add or update an entry locally.
  Future<void> saveEntry(VaultEntry entry) async {
    try {
      final box = _getOpenBox();
      final dto = VaultEntryModel.fromEntity(entry);
      await box.put(entry.id, dto.toJson());
    } catch (e) {
      throw Failure.databaseError('Failed to save local credential: $e');
    }
  }

  /// Delete an entry locally.
  Future<void> deleteEntry(String id) async {
    try {
      final box = _getOpenBox();
      await box.delete(id);
    } catch (e) {
      throw Failure.databaseError('Failed to delete local credential: $e');
    }
  }

  /// Delete the box file completely from disk.
  Future<void> deleteBox() async {
    await closeBox();
    try {
      final docDir = await getApplicationDocumentsDirectory();
      final file = File('${docDir.path}/$boxName.hive');
      final beforeExists = await file.exists();
      
      await Hive.deleteBoxFromDisk(boxName);
      
      final afterExists = await file.exists();
      debugPrint('[WIPE] Hive box file: beforeExists=$beforeExists, afterExists=$afterExists, path=${file.path}');
    } catch (e) {
      debugPrint('[WIPE] Failed to delete Hive box from disk: $e');
    }
  }
}
