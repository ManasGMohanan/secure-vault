import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/security/biometric_service.dart';
import '../../../auth/presentation/providers/auth_notifier.dart';
import '../../presentation/providers/settings_notifier.dart';
import 'package:secure_vault/core/routing/gorouter_extension.dart';
import 'package:secure_vault/core/theme/theme.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _biometricHardwareAvailable = false;

  @override
  void initState() {
    super.initState();
    _checkBiometrics();
  }

  Future<void> _checkBiometrics() async {
    final bioService = ref.read(biometricServiceProvider);
    final available = await bioService.canAuthenticate();
    if (mounted) {
      setState(() {
        _biometricHardwareAvailable = available;
      });
    }
  }

  void _showSignOutConfirmation(AppColorsExtension colors) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Sign Out / Change Account'),
          content: const Text(
            'Are you sure you want to sign out?\n\n'
            'This will securely wipe your decrypted local vault data and biometric access keys from this device.\n\n'
            'Your synced vault data remains completely safe in the cloud and is fully recoverable using your email and master password on this or any other device.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                await ref.read(authNotifierProvider.notifier).factoryReset();
              },
              style: TextButton.styleFrom(foregroundColor: colors.error),
              child: const Text('Sign Out'),
            ),
          ],
        );
      },
    );
  }

  void _showFactoryResetConfirmation(AppColorsExtension colors) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Wipe all credentials?'),
          content: const Text(
            'WARNING: This will permanently delete your master password, salt, biometric keys, and ALL credentials stored in your vault. There is absolutely no way to recover this data.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                await ref.read(authNotifierProvider.notifier).factoryReset();
              },
              style: TextButton.styleFrom(foregroundColor: colors.error),
              child: const Text('Wipe Vault'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsNotifierProvider);
    final theme = Theme.of(context);
    final colors = theme.extension<AppColorsExtension>()!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              context.goToHome();
            }
          },
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          // Section 1: Security Settings
          _buildSectionHeader('Security Settings', colors),
          
          // Biometric toggle
          if (_biometricHardwareAvailable) ...[
            SwitchListTile(
              title: const Text('Biometric Unlock'),
              subtitle: const Text('Unlock vault with fingerprint or face'),
              value: settings.biometricPreferred,
              onChanged: (val) async {
                if (val) {
                  final bioService = ref.read(biometricServiceProvider);
                  final authenticated = await bioService.authenticate(
                    'Enable biometric login',
                  );
                  if (authenticated) {
                    ref.read(settingsNotifierProvider.notifier).updateBiometricPreferred(true);
                  }
                } else {
                  ref.read(settingsNotifierProvider.notifier).updateBiometricPreferred(false);
                }
              },
            ),
            const Divider(),
          ],

          // Auto-lock selector
          ListTile(
            title: const Text('Auto-Lock Timeout'),
            subtitle: const Text('Locks vault after selected idle period'),
            trailing: DropdownButton<int>(
              value: settings.autoLockTimeoutSeconds,
              dropdownColor: colors.surfacePrimary,
              onChanged: (val) {
                if (val != null) {
                  ref.read(settingsNotifierProvider.notifier).updateAutoLockTimeout(val);
                }
              },
              items: const [
                DropdownMenuItem(value: 0, child: Text('Never')),
                DropdownMenuItem(value: 60, child: Text('1 Minute')),
                DropdownMenuItem(value: 300, child: Text('5 Minutes')),
                DropdownMenuItem(value: 600, child: Text('10 Minutes')),
              ],
            ),
          ),
          const Divider(),

          // Clipboard clear selector
          ListTile(
            title: const Text('Clipboard Auto-Clear'),
            subtitle: const Text('Clears credentials copied to clipboard'),
            trailing: DropdownButton<int>(
              value: settings.clipboardClearDurationSeconds,
              dropdownColor: colors.surfacePrimary,
              onChanged: (val) {
                if (val != null) {
                  ref.read(settingsNotifierProvider.notifier).updateClipboardClearDuration(val);
                }
              },
              items: const [
                DropdownMenuItem(value: 10, child: Text('10 Seconds')),
                DropdownMenuItem(value: 30, child: Text('30 Seconds')),
                DropdownMenuItem(value: 60, child: Text('60 Seconds')),
              ],
            ),
          ),
          const Divider(),

          // Section 2: Appearance settings
          _buildSectionHeader('Appearance', colors),
          ListTile(
            title: const Text('Theme Mode'),
            subtitle: const Text('Switch between light and dark backgrounds'),
            trailing: DropdownButton<String>(
              value: settings.themeMode,
              dropdownColor: colors.surfacePrimary,
              onChanged: (val) {
                if (val != null) {
                  ref.read(settingsNotifierProvider.notifier).updateThemeMode(val);
                }
              },
              items: const [
                DropdownMenuItem(value: 'system', child: Text('System')),
                DropdownMenuItem(value: 'light', child: Text('Light')),
                DropdownMenuItem(value: 'dark', child: Text('Dark')),
              ],
            ),
          ),
          const Divider(),

          // Section 3: Storage Reset
          _buildSectionHeader('Storage & Management', colors),
          ListTile(
            title: const Text(
              'Sign Out / Change Account',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: const Text('Wipes local vault data and signs out (Cloud data remains safe)'),
            leading: const Icon(Icons.logout_rounded),
            onTap: () => _showSignOutConfirmation(colors),
          ),
          const Divider(),
          ListTile(
            title: Text(
              'Reset SecureVault',
              style: TextStyle(color: colors.error, fontWeight: FontWeight.bold),
            ),
            subtitle: const Text('Wipes all local credentials and reset encryption setup'),
            leading: Icon(Icons.delete_forever, color: colors.error),
            onTap: () => _showFactoryResetConfirmation(colors),
          ),
          const Divider(),

          // Section 4: About
          _buildSectionHeader('About', colors),
          ListTile(
            title: const Text('SecureVault'),
            subtitle: const Text('Version 1.0.0 — Offline-First & Encrypted'),
            trailing: Icon(Icons.security, color: colors.brandPrimary.withValues(alpha: 0.5)),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, AppColorsExtension colors) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          color: colors.brandPrimary,
          fontWeight: FontWeight.bold,
          fontSize: 13,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}
