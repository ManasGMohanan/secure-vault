import 'package:flutter_test/flutter_test.dart';
import 'package:secure_vault/features/password_generator/domain/password_generator.dart';

void main() {
  group('PasswordGenerator Tests', () {
    test('generate password obeys length constraint', () {
      final pwd1 = PasswordGenerator.generate(
        length: 12,
        includeUppercase: true,
        includeLowercase: true,
        includeNumbers: true,
        includeSymbols: true,
        excludeAmbiguous: false,
      );
      final pwd2 = PasswordGenerator.generate(
        length: 24,
        includeUppercase: true,
        includeLowercase: true,
        includeNumbers: true,
        includeSymbols: true,
        excludeAmbiguous: false,
      );

      expect(pwd1.length, 12);
      expect(pwd2.length, 24);
    });

    test('generate password contains required characters', () {
      final pwd = PasswordGenerator.generate(
        length: 10,
        includeUppercase: true,
        includeLowercase: true,
        includeNumbers: true,
        includeSymbols: true,
        excludeAmbiguous: false,
      );

      expect(pwd.contains(RegExp(r'[a-z]')), isTrue);
      expect(pwd.contains(RegExp(r'[A-Z]')), isTrue);
      expect(pwd.contains(RegExp(r'[0-9]')), isTrue);
      expect(pwd.contains(RegExp(r'[!@#$%^&*()_+\-=\[\]{}|;:\x27\",./<>?]')), isTrue);
    });

    test('excludeAmbiguous works correctly', () {
      final ambiguousChars = {'i', 'l', '1', 'I', 'o', '0', 'O', 'L', '|'};
      
      for (int i = 0; i < 50; i++) {
        final pwd = PasswordGenerator.generate(
          length: 20,
          includeUppercase: true,
          includeLowercase: true,
          includeNumbers: true,
          includeSymbols: true,
          excludeAmbiguous: true,
        );

        for (final char in pwd.split('')) {
          expect(ambiguousChars.contains(char), isFalse,
              reason: 'Generated password "$pwd" contains ambiguous char "$char"');
        }
      }
    });

    test('estimateStrength scores passwords correctly', () {
      // Weak passwords
      expect(PasswordGenerator.estimateStrength(''), PasswordStrength.weak);
      expect(PasswordGenerator.estimateStrength('123'), PasswordStrength.weak);
      expect(PasswordGenerator.estimateStrength('abcdefg'), PasswordStrength.weak);
      
      // Medium passwords
      expect(PasswordGenerator.estimateStrength('Abcdefgh12'), PasswordStrength.medium);
      
      // Strong / Very Strong passwords
      expect(PasswordGenerator.estimateStrength('Abcdefgh12!@'), PasswordStrength.strong);
      expect(PasswordGenerator.estimateStrength('Abcdefgh12!@VeryLong'), PasswordStrength.veryStrong);
    });
  });
}
