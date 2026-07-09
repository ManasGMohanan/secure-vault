import 'dart:math';

enum PasswordStrength {
  weak,
  medium,
  strong,
  veryStrong;

  String get label {
    switch (this) {
      case PasswordStrength.weak:
        return 'Weak';
      case PasswordStrength.medium:
        return 'Medium';
      case PasswordStrength.strong:
        return 'Strong';
      case PasswordStrength.veryStrong:
        return 'Very Strong';
    }
  }
}

class PasswordGenerator {
  PasswordGenerator._();

  static const String _lowercase = 'abcdefghijklmnopqrstuvwxyz';
  static const String _uppercase = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  static const String _numbers = '0123456789';
  static const String _symbols = r"!@#$%^&*()_+-=[]{}|;:',./<>?";
  
  // Ambiguous characters to exclude
  static const Set<String> _ambiguous = {'i', 'l', '1', 'I', 'o', '0', 'O', 'L', '|'};

  /// Generates a secure random password with the given configuration.
  static String generate({
    required int length,
    required bool includeUppercase,
    required bool includeLowercase,
    required bool includeNumbers,
    required bool includeSymbols,
    required bool excludeAmbiguous,
  }) {
    if (length < 4) length = 4; // Minimum length to satisfy guaranteed characters
    
    final random = Random.secure();
    
    // Build character pools
    String lowercasePool = _lowercase;
    String uppercasePool = _uppercase;
    String numbersPool = _numbers;
    String symbolsPool = _symbols;

    if (excludeAmbiguous) {
      lowercasePool = _filterAmbiguous(lowercasePool);
      uppercasePool = _filterAmbiguous(uppercasePool);
      numbersPool = _filterAmbiguous(numbersPool);
      symbolsPool = _filterAmbiguous(symbolsPool);
    }

    final activePools = <String>[];
    final passwordChars = <String>[];

    // Ensure we have at least one character from each selected pool
    if (includeLowercase && lowercasePool.isNotEmpty) {
      activePools.add(lowercasePool);
      passwordChars.add(lowercasePool[random.nextInt(lowercasePool.length)]);
    }
    if (includeUppercase && uppercasePool.isNotEmpty) {
      activePools.add(uppercasePool);
      passwordChars.add(uppercasePool[random.nextInt(uppercasePool.length)]);
    }
    if (includeNumbers && numbersPool.isNotEmpty) {
      activePools.add(numbersPool);
      passwordChars.add(numbersPool[random.nextInt(numbersPool.length)]);
    }
    if (includeSymbols && symbolsPool.isNotEmpty) {
      activePools.add(symbolsPool);
      passwordChars.add(symbolsPool[random.nextInt(symbolsPool.length)]);
    }

    // If no pools selected, default to lowercase + numbers
    if (activePools.isEmpty) {
      activePools.add(lowercasePool);
      passwordChars.add(lowercasePool[random.nextInt(lowercasePool.length)]);
    }

    // Combine all active pools
    final String combinedPool = activePools.join();

    // Fill the remaining length
    while (passwordChars.length < length) {
      passwordChars.add(combinedPool[random.nextInt(combinedPool.length)]);
    }

    // Shuffle the characters securely to prevent predictable ordering
    passwordChars.shuffle(random);

    return passwordChars.join();
  }

  static String _filterAmbiguous(String input) {
    return input.split('').where((char) => !_ambiguous.contains(char)).join();
  }

  /// Calculates the strength score of a password.
  static PasswordStrength estimateStrength(String password) {
    if (password.isEmpty) return PasswordStrength.weak;
    if (password.length < 6) return PasswordStrength.weak;

    int score = 0;

    // Length contributions
    if (password.length >= 8) score += 1;
    if (password.length >= 12) score += 1;
    if (password.length >= 16) score += 1;

    // Complexity contributions
    final hasLowercase = password.contains(RegExp(r'[a-z]'));
    final hasUppercase = password.contains(RegExp(r'[A-Z]'));
    final hasNumbers = password.contains(RegExp(r'[0-9]'));
    final hasSymbols = password.contains(RegExp(r"[!@#$%^&*()_+\-=\[\]{}|;:',./<>?]"));

    if (hasLowercase) score += 1;
    if (hasUppercase) score += 1;
    if (hasNumbers) score += 1;
    if (hasSymbols) score += 1;

    // Penalty for short passwords
    if (password.length < 8) {
      return PasswordStrength.weak;
    }

    if (score <= 3) {
      return PasswordStrength.weak;
    } else if (score == 4 || score == 5) {
      return PasswordStrength.medium;
    } else if (score == 6) {
      return PasswordStrength.strong;
    } else {
      return PasswordStrength.veryStrong;
    }
  }
}
