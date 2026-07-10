import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:secure_vault/core/theme/theme.dart';
import '../../../password_generator/domain/password_generator.dart';
import '../providers/auth_notifier.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _UnlockRecoveryDialog extends StatelessWidget {
  const _UnlockRecoveryDialog();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Forget Password Policy'),
      content: const Text(
        'Because SecureVault is built on Zero-Knowledge architecture, all data is encrypted locally using keys derived from your Master Password.\n\n'
        'Resetting your account login credentials will NOT recover or decrypt your vault contents. If you lose your Master Password, your vault is permanently lost by design.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('I Understand'),
        ),
      ],
    );
  }
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _isRestoreMode = false;
  PasswordStrength _strength = PasswordStrength.weak;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _onPasswordChanged(String val) {
    setState(() {
      _strength = PasswordGenerator.estimateStrength(val);
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (_isRestoreMode) {
      await ref
          .read(authNotifierProvider.notifier)
          .restoreSyncedAccount(email, password);
    } else {
      if (_strength == PasswordStrength.weak) {
        final colors = Theme.of(context).extension<AppColorsExtension>()!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Please choose a stronger master password.'),
            backgroundColor: colors.error,
          ),
        );
        return;
      }
      await ref
          .read(authNotifierProvider.notifier)
          .registerSyncedAccount(email, password);
    }
  }

  Color _getStrengthColor() {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    switch (_strength) {
      case PasswordStrength.weak:
        return colors.error;
      case PasswordStrength.medium:
        return colors
            .brandAccent; // Uses brandAccent to avoid inventing non-palette warning colors
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
                    'SecureVault',
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
                    _isRestoreMode
                        ? 'Sign in with your email to restore your encrypted credentials from the cloud.'
                        : 'Create your account to sync your credentials across all your devices securely.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colors.textMuted,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 36),

                  // Email Address
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    style: const TextStyle(fontSize: 16),
                    decoration: const InputDecoration(
                      labelText: 'Email Address',
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!val.contains('@') || val.length < 3) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Master Password field
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    onChanged: _isRestoreMode ? null : _onPasswordChanged,
                    textInputAction: _isRestoreMode
                        ? TextInputAction.done
                        : TextInputAction.next,
                    onFieldSubmitted: _isRestoreMode ? (_) => _submit() : null,
                    style: const TextStyle(fontSize: 16),
                    decoration: InputDecoration(
                      labelText: 'Master Password',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                        ),
                        onPressed: () => setState(
                          () => _obscurePassword = !_obscurePassword,
                        ),
                      ),
                    ),
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (!_isRestoreMode && val.length < 8) {
                        return 'Password must be at least 8 characters long';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),

                  // Password strength meter (only in registration mode)
                  if (!_isRestoreMode &&
                      _passwordController.text.isNotEmpty) ...[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Password Strength: ${_strength.label}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: _getStrengthColor(),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: _getStrengthPercentage(),
                            color: _getStrengthColor(),
                            backgroundColor: colors.surfaceSecondary,
                            minHeight: 6,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Confirm password field (only in registration mode)
                  if (!_isRestoreMode) ...[
                    TextFormField(
                      controller: _confirmController,
                      obscureText: _obscureConfirm,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _submit(),
                      style: const TextStyle(fontSize: 16),
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirm
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                          ),
                          onPressed: () => setState(
                            () => _obscureConfirm = !_obscureConfirm,
                          ),
                        ),
                      ),
                      validator: (val) {
                        if (val != _passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Warning about reset tradeoff
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colors.surfaceSecondary,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: colors.brandAccent.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.warning_amber_rounded,
                          color: colors.brandAccent,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Warning: Losing your Master Password means your vault is unrecoverable. Resetting your account login credentials will not recover your vault.',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colors.textSecondary,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Submit button
                  authState.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          onPressed: _submit,
                          child: Text(
                            _isRestoreMode ? 'Restore Vault' : 'Create Vault',
                          ),
                        ),
                  const SizedBox(height: 16),

                  // Toggle Create/Restore Mode
                  if (!authState.isLoading)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _isRestoreMode = !_isRestoreMode;
                          _formKey.currentState?.reset();
                          _passwordController.clear();
                          _confirmController.clear();
                        });
                      },
                      child: Text(
                        _isRestoreMode
                            ? 'Need to create an account? Register'
                            : 'Already have a vault? Restore from Sync',
                      ),
                    ),

                  // Custom Recovery/Reset Info dialog
                  if (_isRestoreMode && !authState.isLoading)
                    TextButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (_) => const _UnlockRecoveryDialog(),
                        );
                      },
                      child: const Text('Forgot Master Password?'),
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
