import 'dart:typed_data';

/// Abstract interface for platform-specific cryptographic operations.
abstract class CryptoImpl {
  /// Derives the 32-byte MasterKey from password and salt using PBKDF2 HMAC-SHA256.
  Future<Uint8List> deriveMasterKey({
    required String password,
    required Uint8List salt,
    required int iterations,
  });

  /// Expands the MasterKey to an independent key using HKDF-Expand.
  Future<Uint8List> hkdfExpand({
    required Uint8List masterKey,
    required String info,
    required int length,
  });

  /// Encrypts plaintext using AES-GCM 256-bit with key and iv. Returns concatenated ciphertext + tag.
  Future<Uint8List> aesGcmEncrypt({
    required Uint8List key,
    required Uint8List iv,
    required Uint8List plaintext,
  });

  /// Decrypts ciphertextAndTag using AES-GCM 256-bit with key and iv.
  Future<Uint8List> aesGcmDecrypt({
    required Uint8List key,
    required Uint8List iv,
    required Uint8List ciphertextAndTag,
  });
}

/// Factory getter to retrieve the platform implementation.
CryptoImpl get cryptoProvider => throw UnsupportedError('Cannot create crypto provider without platform implementation');
