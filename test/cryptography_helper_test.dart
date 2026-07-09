import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:secure_vault/core/security/cryptography_helper.dart';

void main() {
  group('CryptographyHelper Tests', () {
    test('generateSecureSalt generates correct length and different salts', () {
      final salt1 = CryptographyHelper.generateSecureSalt(16);
      final salt2 = CryptographyHelper.generateSecureSalt(16);

      expect(salt1.length, 16);
      expect(salt2.length, 16);
      expect(salt1, isNot(equals(salt2)));
    });

    test('deriveMasterKey is deterministic for same inputs', () async {
      final password = 'TestPassword123!';
      final salt = Uint8List.fromList([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16]);

      final key1 = await CryptographyHelper.deriveMasterKey(password, salt);
      final key2 = await CryptographyHelper.deriveMasterKey(password, salt);

      expect(key1.length, 32);
      expect(key1, equals(key2));
    });

    test('deriveMasterKey produces different keys for different passwords', () async {
      final salt = Uint8List.fromList([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16]);

      final key1 = await CryptographyHelper.deriveMasterKey('PasswordOne', salt);
      final key2 = await CryptographyHelper.deriveMasterKey('PasswordTwo', salt);

      expect(key1, isNot(equals(key2)));
    });

    test('hashKey calculates correct SHA-256 string', () {
      final key = Uint8List.fromList(List.filled(32, 1));
      final hash = CryptographyHelper.hashKey(key);

      expect(hash.length, 64);
      expect(hash, isA<String>());
    });
  });
}
