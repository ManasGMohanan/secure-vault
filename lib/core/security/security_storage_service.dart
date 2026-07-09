import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'security_storage_service.g.dart';

class SecurityStorageService {
  final FlutterSecureStorage _storage;

  SecurityStorageService(this._storage);

  static const _saltKey = 'secure_vault_salt';
  static const _keyHashKey = 'secure_vault_key_hash';
  static const _biometricEnabledKey = 'secure_vault_biometric_enabled';
  static const _biometricKeyKey = 'secure_vault_biometric_key';

  /// Read the salt. Returns null if not set.
  Future<Uint8List?> readSalt() async {
    final base64Salt = await _storage.read(key: _saltKey);
    if (base64Salt == null) return null;
    return base64.decode(base64Salt);
  }

  /// Write the salt.
  Future<void> writeSalt(Uint8List salt) async {
    final base64Salt = base64.encode(salt);
    await _storage.write(key: _saltKey, value: base64Salt);
  }

  /// Read the key hash. Returns null if not set.
  Future<String?> readKeyHash() async {
    return await _storage.read(key: _keyHashKey);
  }

  /// Write the key hash.
  Future<void> writeKeyHash(String hash) async {
    await _storage.write(key: _keyHashKey, value: hash);
  }

  /// Read if biometric unlock is enabled.
  Future<bool> readBiometricEnabled() async {
    final val = await _storage.read(key: _biometricEnabledKey);
    return val == 'true';
  }

  /// Set if biometric unlock is enabled.
  Future<void> writeBiometricEnabled(bool enabled) async {
    await _storage.write(key: _biometricEnabledKey, value: enabled.toString());
  }

  /// Read the saved derived key for biometric unlock.
  Future<Uint8List?> readBiometricKey() async {
    final base64Key = await _storage.read(key: _biometricKeyKey);
    if (base64Key == null) return null;
    return base64.decode(base64Key);
  }

  /// Write the derived key for biometric unlock.
  Future<void> writeBiometricKey(Uint8List key) async {
    final base64Key = base64.encode(key);
    await _storage.write(key: _biometricKeyKey, value: base64Key);
  }

  /// Delete the saved biometric key.
  Future<void> deleteBiometricKey() async {
    await _storage.delete(key: _biometricKeyKey);
  }

  /// Clear all security data (used for factory reset / data recovery warning).
  Future<void> clearAllSecurityData() async {
    await _storage.delete(key: _saltKey);
    await _storage.delete(key: _keyHashKey);
    await _storage.delete(key: _biometricEnabledKey);
    await _storage.delete(key: _biometricKeyKey);
  }
}

@riverpod
SecurityStorageService securityStorageService(SecurityStorageServiceRef ref) {
  return SecurityStorageService(
    const FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true),
      iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
    ),
  );
}
