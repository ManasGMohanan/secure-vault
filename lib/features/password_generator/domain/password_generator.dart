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

class PasswordCriteriaResult {
  final bool hasMinLength;
  final bool hasMediumLength;
  final bool hasGreatLength;
  final bool hasUppercase;
  final bool hasLowercase;
  final bool hasNumber;
  final bool hasSymbol;
  final PasswordStrength overallStrength;

  const PasswordCriteriaResult({
    required this.hasMinLength,
    required this.hasMediumLength,
    required this.hasGreatLength,
    required this.hasUppercase,
    required this.hasLowercase,
    required this.hasNumber,
    required this.hasSymbol,
    required this.overallStrength,
  });
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

  /// Evaluates criteria and returns a detailed result.
  static PasswordCriteriaResult evaluateCriteria(String password) {
    final hasMinLength = password.length >= 8;
    final hasMediumLength = password.length >= 12;
    final hasGreatLength = password.length >= 16;
    final hasLowercase = password.contains(RegExp(r'[a-z]'));
    final hasUppercase = password.contains(RegExp(r'[A-Z]'));
    final hasNumber = password.contains(RegExp(r'[0-9]'));
    final hasSymbol = password.contains(RegExp(r"[!@#$%^&*()_+\-=\[\]{}|;:',./<>?]"));

    if (password.isEmpty || password.length < 8) {
      return PasswordCriteriaResult(
        hasMinLength: hasMinLength,
        hasMediumLength: hasMediumLength,
        hasGreatLength: hasGreatLength,
        hasUppercase: hasUppercase,
        hasLowercase: hasLowercase,
        hasNumber: hasNumber,
        hasSymbol: hasSymbol,
        overallStrength: PasswordStrength.weak,
      );
    }

    int score = 0;
    if (password.length >= 8) score += 1;
    if (password.length >= 12) score += 1;
    if (password.length >= 16) score += 1;

    if (hasLowercase) score += 1;
    if (hasUppercase) score += 1;
    if (hasNumber) score += 1;
    if (hasSymbol) score += 1;

    PasswordStrength strength;
    if (score <= 3) {
      strength = PasswordStrength.weak;
    } else if (score == 4 || score == 5) {
      strength = PasswordStrength.medium;
    } else if (score == 6) {
      strength = PasswordStrength.strong;
    } else {
      strength = PasswordStrength.veryStrong;
    }

    return PasswordCriteriaResult(
      hasMinLength: hasMinLength,
      hasMediumLength: hasMediumLength,
      hasGreatLength: hasGreatLength,
      hasUppercase: hasUppercase,
      hasLowercase: hasLowercase,
      hasNumber: hasNumber,
      hasSymbol: hasSymbol,
      overallStrength: strength,
    );
  }

  /// Calculates the strength score of a password.
  static PasswordStrength estimateStrength(String password) {
    return evaluateCriteria(password).overallStrength;
  }
}
