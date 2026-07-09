import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:crypto/crypto.dart' as crypto_lib;

// Conditional import to resolve Platform implementation (Native vs Web Crypto API).
import 'crypto_impl_stub.dart'
    if (dart.library.js_interop) 'crypto_impl_web.dart'
    if (dart.library.io) 'crypto_impl_native.dart';

/// A utility helper containing cryptographic operations like PBKDF2 derivation,
/// secure salt generation, and key hashing.
class CryptographyHelper {
  CryptographyHelper._();

  // Iteration count upgraded to 210,000 iterations to meet production requirements.
  static const int pbkdf2Iterations = 210000;
  static const int keyLengthBytes = 32; // 256 bits

  /// Derives the 32-byte MasterKey from password and salt using PBKDF2 HMAC-SHA256.
  static Future<Uint8List> deriveMasterKey(String password, Uint8List salt, {int? iterations}) {
    return cryptoProvider.deriveMasterKey(
      password: password,
      salt: salt,
      iterations: iterations ?? pbkdf2Iterations,
    );
  }

  /// Expands the MasterKey to an EncryptionKey (for local Hive and cloud syncing).
  static Future<Uint8List> deriveEncryptionKey(Uint8List masterKey) {
    return cryptoProvider.hkdfExpand(
      masterKey: masterKey,
      info: 'securevault-encryption-v1',
      length: keyLengthBytes,
    );
  }

  /// Expands the MasterKey to a LoginKey (used as Firebase Auth Password).
  static Future<Uint8List> deriveLoginKey(Uint8List masterKey) {
    return cryptoProvider.hkdfExpand(
      masterKey: masterKey,
      info: 'securevault-firebase-login-v1',
      length: keyLengthBytes,
    );
  }

  /// Derives all three keys (MasterKey, EncryptionKey, LoginKey) from a password and salt.
  static Future<DerivedAuthKeys> deriveAllKeys(String password, Uint8List salt, {int? iterations}) async {
    final masterKey = await deriveMasterKey(password, salt, iterations: iterations);
    final encryptionKey = await deriveEncryptionKey(masterKey);
    final loginKey = await deriveLoginKey(masterKey);
    return DerivedAuthKeys(
      masterKey: masterKey,
      encryptionKey: encryptionKey,
      loginKey: loginKey,
    );
  }

  /// Generates a cryptographically secure random salt (defaults to 16 bytes).
  static Uint8List generateSecureSalt([int length = 16]) {
    final random = Random.secure();
    final salt = Uint8List(length);
    for (int i = 0; i < length; i++) {
      salt[i] = random.nextInt(256);
    }
    return salt;
  }

  /// Calculates a SHA-256 hash of the derived key for secure verification.
  static String hashKey(Uint8List key) {
    return crypto_lib.sha256.convert(key).toString();
  }

  /// Encrypts plaintext using AES-GCM 256-bit with key and standard 12-byte IV.
  /// Returns a record containing the ciphertext base64, IV base64, and GCM tag base64.
  static Future<({String ciphertext, String iv, String tag})> encryptGcm(
    Uint8List key,
    Uint8List plaintext,
  ) async {
    final random = Random.secure();
    final iv = Uint8List(12);
    for (int i = 0; i < 12; i++) {
      iv[i] = random.nextInt(256);
    }

    final encryptedBytes = await cryptoProvider.aesGcmEncrypt(
      key: key,
      iv: iv,
      plaintext: plaintext,
    );

    // Split concatenated ciphertext + tag (tag is the last 16 bytes)
    final ciphertextBytes = encryptedBytes.sublist(0, encryptedBytes.length - 16);
    final tagBytes = encryptedBytes.sublist(encryptedBytes.length - 16);

    return (
      ciphertext: base64Encode(ciphertextBytes),
      iv: base64Encode(iv),
      tag: base64Encode(tagBytes),
    );
  }

  /// Decrypts GCM components.
  static Future<Uint8List> decryptGcm({
    required Uint8List key,
    required String ciphertextBase64,
    required String ivBase64,
    required String tagBase64,
  }) async {
    final iv = base64Decode(ivBase64);
    final ciphertext = base64Decode(ciphertextBase64);
    final tag = base64Decode(tagBase64);

    // Re-concatenate ciphertext + tag
    final ciphertextAndTag = Uint8List(ciphertext.length + tag.length)
      ..setAll(0, ciphertext)
      ..setAll(ciphertext.length, tag);

    return cryptoProvider.aesGcmDecrypt(
      key: key,
      iv: iv,
      ciphertextAndTag: ciphertextAndTag,
    );
  }
}

/// Container holding derived keys from a single master password.
class DerivedAuthKeys {
  final Uint8List masterKey;
  final Uint8List encryptionKey;
  final Uint8List loginKey;

  DerivedAuthKeys({
    required this.masterKey,
    required this.encryptionKey,
    required this.loginKey,
  });
}
