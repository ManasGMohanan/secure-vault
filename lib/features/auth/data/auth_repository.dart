import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart' as crypto_lib;
import '../../../../core/error/failures.dart';
import '../../../../core/security/cryptography_helper.dart';
import '../../../../core/security/security_storage_service.dart';
import '../../../../core/security/web_storage_helper.dart';

part 'auth_repository.g.dart';

class AuthRepository {
  final SecurityStorageService _storageService;

  AuthRepository(this._storageService);

  /// Checks whether the app has a master password set up.
  Future<bool> isInitialized() async {
    try {
      final salt = await _storageService.readSalt();
      final hash = await _storageService.readKeyHash();
      return salt != null && hash != null;
    } catch (e) {
      throw Failure.storageError(e.toString());
    }
  }

  /// Sets up the master password on first launch and returns the derived keys.
  Future<DerivedAuthKeys> setupMasterPassword(String password) async {
    try {
      final salt = CryptographyHelper.generateSecureSalt();
      final keys = await CryptographyHelper.deriveAllKeys(password, salt);
      final hash = CryptographyHelper.hashKey(keys.masterKey);

      await _storageService.writeSalt(salt);
      await _storageService.writeKeyHash(hash);
      
      // Ensure we start with biometrics disabled until explicit toggle
      await _storageService.writeBiometricEnabled(false);

      return keys;
    } catch (e) {
      throw Failure.storageError(e.toString());
    }
  }

  /// Verifies the master password and returns the derived keys if successful.
  Future<DerivedAuthKeys> unlockWithPassword(String password) async {
    try {
      final salt = await _storageService.readSalt();
      final storedHash = await _storageService.readKeyHash();

      if (salt == null || storedHash == null) {
        throw const Failure.storageError('Vault is not initialized.');
      }

      final keys = await CryptographyHelper.deriveAllKeys(password, salt);
      final derivedHash = CryptographyHelper.hashKey(keys.masterKey);

      if (derivedHash == storedHash) {
        return keys;
      } else {
        throw const Failure.invalidPassword();
      }
    } on Failure {
      rethrow;
    } catch (e) {
      throw Failure.storageError(e.toString());
    }
  }

  /// Enables biometric unlock by storing the derived key in secure storage.
  Future<void> enableBiometrics(Uint8List derivedKey) async {
    try {
      await _storageService.writeBiometricEnabled(true);
      await _storageService.writeBiometricKey(derivedKey);
    } catch (e) {
      throw Failure.storageError(e.toString());
    }
  }

  /// Disables biometric unlock.
  Future<void> disableBiometrics() async {
    try {
      await _storageService.writeBiometricEnabled(false);
      await _storageService.deleteBiometricKey();
    } catch (e) {
      throw Failure.storageError(e.toString());
    }
  }

  /// Checks if biometric unlock is enabled.
  Future<bool> isBiometricEnabled() async {
    try {
      return await _storageService.readBiometricEnabled();
    } catch (e) {
      return false;
    }
  }

  /// Unlocks using stored biometric key.
  Future<Uint8List> unlockWithBiometrics() async {
    try {
      final isEnabled = await _storageService.readBiometricEnabled();
      if (!isEnabled) {
        throw const Failure.biometricNotAvailable();
      }

      final key = await _storageService.readBiometricKey();
      if (key == null) {
        throw const Failure.biometricFailed();
      }

      return key;
    } on Failure {
      rethrow;
    } catch (e) {
      throw Failure.storageError(e.toString());
    }
  }

  /// Wipes all vault encryption configuration.
  Future<void> clearVaultData() async {
    try {
      await _storageService.clearAllSecurityData();
      clearWebSession();
      // Also log out from Firebase if logged in
      if (FirebaseAuth.instance.currentUser != null) {
        await FirebaseAuth.instance.signOut();
      }
    } catch (e) {
      throw Failure.storageError(e.toString());
    }
  }

  /// Hashes email using SHA-256 for salt lookups.
  String _hashEmail(String email) {
    final bytes = utf8.encode(email.toLowerCase().trim());
    return crypto_lib.sha256.convert(bytes).toString();
  }

  /// Registers a new zero-knowledge account in Firebase.
  Future<DerivedAuthKeys> registerSyncedAccount(String email, String password) async {
    try {
      final salt = CryptographyHelper.generateSecureSalt();
      final keys = await CryptographyHelper.deriveAllKeys(password, salt);
      final hash = CryptographyHelper.hashKey(keys.masterKey);
      final emailHash = _hashEmail(email);

      // 1. Upload public salt (write-once)
      await FirebaseFirestore.instance.collection('salts').doc(emailHash).set({
        'salt': base64Encode(salt),
        'kdfIterations': CryptographyHelper.pbkdf2Iterations,
      });

      // 2. Sign up to Firebase Auth
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: base64Encode(keys.loginKey),
      );

      // 3. Upload encrypted user metadata
      await FirebaseFirestore.instance.collection('users').doc(credential.user!.uid).set({
        'salt': base64Encode(salt),
        'verificationHash': hash,
        'kdfIterations': CryptographyHelper.pbkdf2Iterations,
      });

      // 4. Save credentials locally for offline access
      await _storageService.writeSalt(salt);
      await _storageService.writeKeyHash(hash);
      await _storageService.writeBiometricEnabled(false);

      return keys;
    } on FirebaseAuthException catch (e) {
      throw Failure.unknown(e.message ?? e.code);
    } catch (e) {
      throw Failure.unknown(e.toString());
    }
  }

  /// Restores a zero-knowledge account on a new device.
  Future<DerivedAuthKeys> restoreSyncedAccount(String email, String password) async {
    try {
      final emailHash = _hashEmail(email);

      // 1. Fetch public salt
      final saltDoc = await FirebaseFirestore.instance.collection('salts').doc(emailHash).get();
      if (!saltDoc.exists) {
        throw const Failure.invalidPassword();
      }

      final salt = base64Decode(saltDoc.data()!['salt'] as String);
      final iterations = saltDoc.data()!['kdfIterations'] as int;

      // 2. Derive keys
      final keys = await CryptographyHelper.deriveAllKeys(password, salt, iterations: iterations);

      // 3. Log in to Firebase Auth
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: base64Encode(keys.loginKey),
      );

      // 4. Fetch user metadata and verify
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(credential.user!.uid).get();
      if (!userDoc.exists) {
        throw const Failure.storageError('Account metadata missing.');
      }

      final verificationHash = userDoc.data()!['verificationHash'] as String;
      final derivedHash = CryptographyHelper.hashKey(keys.masterKey);

      if (derivedHash != verificationHash) {
        throw const Failure.invalidPassword();
      }

      // 5. Save credentials locally for offline access
      await _storageService.writeSalt(salt);
      await _storageService.writeKeyHash(verificationHash);
      await _storageService.writeBiometricEnabled(false);

      return keys;
    } on FirebaseAuthException catch (e) {
      throw Failure.unknown(e.message ?? e.code);
    } on Failure {
      rethrow;
    } catch (e) {
      throw Failure.unknown(e.toString());
    }
  }
}

@riverpod
AuthRepository authRepository(AuthRepositoryRef ref) {
  final storage = ref.watch(securityStorageServiceProvider);
  return AuthRepository(storage);
}
