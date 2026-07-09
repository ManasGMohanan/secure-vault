import 'package:cloud_firestore/cloud_firestore.dart';

/// Remote datasource wrapping Firestore syncing endpoints.
class VaultRemoteDatasource {
  FirebaseFirestore get _firestore => FirebaseFirestore.instance;

  /// Fetches all remote entry documents under users/{uid}/entries.
  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getEncryptedEntries(String uid) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(uid)
        .collection('entries')
        .get();
    return snapshot.docs;
  }

  /// Saves an encrypted entry document under users/{uid}/entries/{entryId}.
  Future<void> saveEncryptedEntry(
    String uid,
    String entryId,
    Map<String, dynamic> data,
  ) async {
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('entries')
        .doc(entryId)
        .set(data);
  }
}
