import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/security/biometric_service.dart';
import '../../../auth/presentation/providers/auth_notifier.dart';
import '../../../auth/domain/entities/auth_state.dart';
import '../../presentation/providers/settings_notifier.dart';

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

  void _showSignOutConfirmation() {
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
              style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
              child: const Text('Sign Out'),
            ),
          ],
        );
      },
    );
  }

  void _showFactoryResetConfirmation() {
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
              style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
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
    final authState = ref.watch(authNotifierProvider).valueOrNull;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          // Section 1: Security Settings
          _buildSectionHeader('Security Settings', theme),
          
          // Biometric toggle
          if (_biometricHardwareAvailable) ...[
            SwitchListTile(
              title: const Text('Biometric Unlock'),
              subtitle: const Text('Unlock vault with fingerprint or face recognition'),
              value: settings.biometricPreferred,
              activeThumbColor: theme.colorScheme.primary,
              onChanged: (val) async {
                try {
                  if (authState is AuthUnlocked) {
                    await ref.read(authNotifierProvider.notifier).toggleBiometrics(val);
                    await ref.read(settingsNotifierProvider.notifier).updateBiometricPreferred(val);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Must be unlocked to configure biometrics')),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(e.toString()),
                        backgroundColor: Colors.redAccent,
                      ),
                    );
                  }
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
              dropdownColor: isDark ? const Color(0xFF1E293B) : Colors.white,
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
              dropdownColor: isDark ? const Color(0xFF1E293B) : Colors.white,
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
          _buildSectionHeader('Appearance', theme),
          ListTile(
            title: const Text('Theme Mode'),
            subtitle: const Text('Switch between light and dark backgrounds'),
            trailing: DropdownButton<String>(
              value: settings.themeMode,
              dropdownColor: isDark ? const Color(0xFF1E293B) : Colors.white,
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
          _buildSectionHeader('Storage & Management', theme),
          ListTile(
            title: const Text(
              'Sign Out / Change Account',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: const Text('Wipes local vault data and signs out (Cloud data remains safe)'),
            leading: const Icon(Icons.logout_rounded),
            onTap: _showSignOutConfirmation,
          ),
          const Divider(),
          ListTile(
            title: const Text(
              'Reset SecureVault',
              style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
            ),
            subtitle: const Text('Wipes all local credentials and reset encryption setup'),
            leading: const Icon(Icons.delete_forever, color: Colors.redAccent),
            onTap: _showFactoryResetConfirmation,
          ),
          const Divider(),

          // Section 4: About
          _buildSectionHeader('About', theme),
          ListTile(
            title: const Text('SecureVault'),
            subtitle: const Text('Version 1.0.0 — Offline-First & Encrypted'),
            trailing: Icon(Icons.security, color: theme.colorScheme.primary.withValues(alpha: 0.5)),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.bold,
          fontSize: 13,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}
