import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:secure_vault/features/auth/domain/entities/auth_state.dart';
import 'package:secure_vault/core/theme/theme.dart';
import '../providers/auth_notifier.dart';

class UnlockScreen extends ConsumerStatefulWidget {
  const UnlockScreen({super.key});

  @override
  ConsumerState<UnlockScreen> createState() => _UnlockScreenState();
}

class _UnlockScreenState extends ConsumerState<UnlockScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  bool _obscureText = true;
  bool _isPasswordSubmitting = false;

  @override
  void initState() {
    super.initState();
    // Auto-trigger biometric unlock on mount after layout is finished
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndTriggerBiometrics();
    });
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _checkAndTriggerBiometrics() async {
    final authState = ref.read(authNotifierProvider).valueOrNull;
    if (authState is AuthLocked &&
        authState.biometricEnabled &&
        !authState.hasAttemptedBiometrics) {
      await ref.read(authNotifierProvider.notifier).unlockWithBiometrics();
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isPasswordSubmitting = true;
    });

    try {
      await ref
          .read(authNotifierProvider.notifier)
          .unlockWithPassword(_passwordController.text);
      _passwordController.clear();
    } finally {
      if (mounted) {
        setState(() {
          _isPasswordSubmitting = false;
        });
      }
    }
  }

  void _showForgotWarning() {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColorsExtension>()!;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Forgot Master Password?',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  'To protect your data, all vault contents are encrypted on this device. We do not store your master password on any servers, meaning we cannot reset it or recover your files.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colors.textMuted,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _showWipeConfirmation(colors);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.error,
                    foregroundColor: colors.textOnBrand,
                  ),
                  child: const Text('Reset Vault (Wipe Data)'),
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showWipeConfirmation(AppColorsExtension colors) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Wipe all credentials?'),
          content: const Text(
            'This action is irreversible. All your stored usernames, passwords, and custom fields will be permanently deleted.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                ref.read(authNotifierProvider.notifier).factoryReset();
              },
              style: TextButton.styleFrom(foregroundColor: colors.error),
              child: const Text('Wipe Everything'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final theme = Theme.of(context);
    final colors = theme.extension<AppColorsExtension>()!;

    ref.listen<AsyncValue>(authNotifierProvider, (previous, next) {
      if (next is AsyncError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error.toString()),
            backgroundColor: colors.error,
          ),
        );
      }
    });

    // Check if we should auto-trigger biometrics once state loads
    final stateVal = authState.valueOrNull;
    if (stateVal is AuthLocked &&
        stateVal.biometricEnabled &&
        !stateVal.hasAttemptedBiometrics) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(authNotifierProvider.notifier).unlockWithBiometrics();
      });
    }

    final isLockedWithBio = stateVal is AuthLocked && stateVal.biometricEnabled;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SvgPicture.asset(
                    'assets/images/svg/securevault_logo.svg',
                    height: 80,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Vault Locked',
                    style: theme.textTheme.headlineLarge?.copyWith(
                      fontFamily: 'Helvetica Rounded LT Std',
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                      color: colors.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Enter your master password to unlock your secure credentials.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colors.textMuted,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 36),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscureText,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _submit(),
                    style: const TextStyle(fontSize: 16),
                    decoration: InputDecoration(
                      labelText: 'Master Password',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                        ),
                        onPressed: () =>
                            setState(() => _obscureText = !_obscureText),
                      ),
                    ),
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      if (isLockedWithBio) ...[
                        IconButton(
                          iconSize: 32,
                          padding: const EdgeInsets.all(12),
                          icon: Icon(
                            Icons.fingerprint_rounded,
                            color: colors.brandPrimary,
                          ),
                          style: IconButton.styleFrom(
                            side: BorderSide(
                              color: colors.brandPrimary,
                              width: 1.5,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: authState.isLoading
                              ? null
                              : () {
                                  ref
                                      .read(authNotifierProvider.notifier)
                                      .unlockWithBiometrics();
                                },
                        ),
                        const SizedBox(width: 12),
                      ],
                      Expanded(
                        child: ElevatedButton(
                          onPressed: authState.isLoading ? null : _submit,
                          child: _isPasswordSubmitting && authState.isLoading
                              ? SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: colors.textOnBrand,
                                  ),
                                )
                              : const Text('Unlock'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: _showForgotWarning,
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(color: colors.textMuted),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
