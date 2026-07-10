import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:secure_vault/features/password_generator/domain/password_generator.dart';
import 'package:secure_vault/core/theme/theme.dart';

class PasswordGeneratorScreen extends StatefulWidget {
  const PasswordGeneratorScreen({super.key});

  @override
  State<PasswordGeneratorScreen> createState() =>
      _PasswordGeneratorScreenState();
}

class _PasswordGeneratorScreenState extends State<PasswordGeneratorScreen> {
  int _length = 16;
  bool _includeUppercase = true;
  bool _includeLowercase = true;
  bool _includeNumbers = true;
  bool _includeSymbols = true;
  bool _excludeAmbiguous = false;

  String _generatedPassword = '';
  PasswordStrength _strength = PasswordStrength.strong;

  @override
  void initState() {
    super.initState();
    _generate();
  }

  void _generate() {
    final password = PasswordGenerator.generate(
      length: _length,
      includeUppercase: _includeUppercase,
      includeLowercase: _includeLowercase,
      includeNumbers: _includeNumbers,
      includeSymbols: _includeSymbols,
      excludeAmbiguous: _excludeAmbiguous,
    );

    setState(() {
      _generatedPassword = password;
      _strength = PasswordGenerator.estimateStrength(password);
    });
  }

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: _generatedPassword));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Password copied to clipboard!'),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }

  Color _getStrengthColor(AppColorsExtension colors) {
    switch (_strength) {
      case PasswordStrength.weak:
        return colors.error;
      case PasswordStrength.medium:
        return colors.brandAccent; // Uses brandAccent to avoid inventing non-palette warning colors
      case PasswordStrength.strong:
        return colors.successForeground;
      case PasswordStrength.veryStrong:
        return colors.success;
    }
  }

  double _getStrengthPercentage() {
    switch (_strength) {
      case PasswordStrength.weak:
        return 0.25;
      case PasswordStrength.medium:
        return 0.5;
      case PasswordStrength.strong:
        return 0.75;
      case PasswordStrength.veryStrong:
        return 1.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColorsExtension>()!;

    return Scaffold(
      appBar: AppBar(title: const Text('Password Generator')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Generated Password display box
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    SelectableText(
                      _generatedPassword,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.refresh_rounded),
                          onPressed: _generate,
                          tooltip: 'Generate new password',
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Strength: ${_strength.label}',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: _getStrengthColor(colors),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: _getStrengthPercentage(),
                              color: _getStrengthColor(colors),
                              backgroundColor: colors.surfaceSecondary,
                              minHeight: 6,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Copy button
            ElevatedButton.icon(
              onPressed: _copyToClipboard,
              icon: const Icon(Icons.copy_rounded),
              label: const Text('Copy Generated Password'),
            ),
            const SizedBox(height: 24),

            // Configuration Options card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Customize Password',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Length slider
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Password Length',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        Text(
                          '$_length characters',
                          style: TextStyle(
                            color: colors.brandPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Slider(
                      value: _length.toDouble(),
                      min: 8,
                      max: 64,
                      divisions: 56,
                      label: _length.toString(),
                      onChanged: (val) {
                        setState(() {
                          _length = val.round();
                        });
                        _generate();
                      },
                    ),
                    const Divider(height: 24),

                    // Toggles
                    SwitchListTile(
                      title: const Text('Uppercase Letters (A-Z)'),
                      value: _includeUppercase,
                      activeThumbColor: colors.brandPrimary,
                      onChanged: (val) {
                        setState(() => _includeUppercase = val);
                        _generate();
                      },
                      contentPadding: EdgeInsets.zero,
                    ),
                    SwitchListTile(
                      title: const Text('Lowercase Letters (a-z)'),
                      value: _includeLowercase,
                      activeThumbColor: colors.brandPrimary,
                      onChanged: (val) {
                        setState(() => _includeLowercase = val);
                        _generate();
                      },
                      contentPadding: EdgeInsets.zero,
                    ),
                    SwitchListTile(
                      title: const Text('Numbers (0-9)'),
                      value: _includeNumbers,
                      activeThumbColor: colors.brandPrimary,
                      onChanged: (val) {
                        setState(() => _includeNumbers = val);
                        _generate();
                      },
                      contentPadding: EdgeInsets.zero,
                    ),
                    SwitchListTile(
                      title: const Text('Special Symbols (!@#...)'),
                      value: _includeSymbols,
                      activeThumbColor: colors.brandPrimary,
                      onChanged: (val) {
                        setState(() => _includeSymbols = val);
                        _generate();
                      },
                      contentPadding: EdgeInsets.zero,
                    ),
                    SwitchListTile(
                      title: const Text('Exclude Ambiguous (e.g. l, 1, o, 0)'),
                      value: _excludeAmbiguous,
                      activeThumbColor: colors.brandPrimary,
                      onChanged: (val) {
                        setState(() => _excludeAmbiguous = val);
                        _generate();
                      },
                      contentPadding: EdgeInsets.zero,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
