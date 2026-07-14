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

  // ── Bottom Sheet Helper ───────────────────────────────────────────────────

  void _showSelectionModal<T>({
    required String title,
    required List<T> items,
    required T currentValue,
    required String Function(T) labelBuilder,
    required void Function(T) onSelected,
    required AppColorsExtension colors,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: colors.surfacePrimary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              // Grabber handle
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: colors.borderSubtle,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: colors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              ...items.map((item) {
                final isSelected = item == currentValue;
                return InkWell(
                  onTap: () {
                    onSelected(item);
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          labelBuilder(item),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                            color: isSelected ? colors.brandPrimary : colors.textPrimary,
                          ),
                        ),
                        if (isSelected)
                          Icon(Icons.check_rounded, color: colors.brandPrimary, size: 20),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  // ── Build ──────────────────────────────────────────────────────────────────

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Section 1: Security Settings ─────────────────────────────────
            _buildSectionLabel('SECURITY SETTINGS', colors),
            const SizedBox(height: 8),
            Card(
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Column(
                children: [
                  // Biometric
                  if (_biometricHardwareAvailable) ...[
                    _buildSwitchRow(
                      icon: Icons.fingerprint_rounded,
                      title: 'Biometric Unlock',
                      subtitle: 'Unlock vault with fingerprint or face',
                      value: settings.biometricPreferred,
                      onChanged: (val) async {
                        try {
                          await ref.read(authNotifierProvider.notifier).toggleBiometrics(val);
                          ref.read(settingsNotifierProvider.notifier).updateBiometricPreferred(val);
                        } catch (e) {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Failed to update biometric settings: $e')),
                            );
                          }
                        }
                      },
                      colors: colors,
                    ),
                    _buildDivider(colors),
                  ],

                  // Auto-lock
                  _buildSelectorRow<int>(
                    icon: Icons.lock_clock_outlined,
                    title: 'Auto-Lock Timeout',
                    subtitle: 'Locks vault after selected idle period',
                    currentValue: settings.autoLockTimeoutSeconds,
                    labelBuilder: _autoLockLabel,
                    onTap: () {
                      _showSelectionModal<int>(
                        title: 'Auto-Lock Timeout',
                        items: [0, 60, 300, 600],
                        currentValue: settings.autoLockTimeoutSeconds,
                        labelBuilder: _autoLockLabel,
                        onSelected: (val) {
                          ref.read(settingsNotifierProvider.notifier).updateAutoLockTimeout(val);
                        },
                        colors: colors,
                      );
                    },
                    colors: colors,
                  ),
                  _buildDivider(colors),

                  // Clipboard
                  _buildSelectorRow<int>(
                    icon: Icons.content_paste_off_rounded,
                    title: 'Clipboard Auto-Clear',
                    subtitle: 'Clears credentials copied to clipboard',
                    currentValue: settings.clipboardClearDurationSeconds,
                    labelBuilder: (val) => '$val Seconds',
                    onTap: () {
                      _showSelectionModal<int>(
                        title: 'Clipboard Auto-Clear',
                        items: [10, 30, 60],
                        currentValue: settings.clipboardClearDurationSeconds,
                        labelBuilder: (val) => '$val Seconds',
                        onSelected: (val) {
                          ref.read(settingsNotifierProvider.notifier).updateClipboardClearDuration(val);
                        },
                        colors: colors,
                      );
                    },
                    colors: colors,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ── Section 2: Appearance ────────────────────────────────────────
            _buildSectionLabel('APPEARANCE', colors),
            const SizedBox(height: 8),
            Card(
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Column(
                children: [
                  _buildSelectorRow<String>(
                    icon: Icons.palette_outlined,
                    title: 'Theme Mode',
                    subtitle: 'Switch between light and dark backgrounds',
                    currentValue: settings.themeMode,
                    labelBuilder: (val) => val[0].toUpperCase() + val.substring(1),
                    onTap: () {
                      _showSelectionModal<String>(
                        title: 'Theme Mode',
                        items: ['system', 'light', 'dark'],
                        currentValue: settings.themeMode,
                        labelBuilder: (val) => val[0].toUpperCase() + val.substring(1),
                        onSelected: (val) {
                          ref.read(settingsNotifierProvider.notifier).updateThemeMode(val);
                        },
                        colors: colors,
                      );
                    },
                    colors: colors,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ── Section 3: Storage Reset ─────────────────────────────────────
            _buildSectionLabel('STORAGE & MANAGEMENT', colors),
            const SizedBox(height: 8),
            Card(
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Column(
                children: [
                  _buildActionRow(
                    icon: Icons.logout_rounded,
                    title: 'Sign Out / Change Account',
                    subtitle: 'Wipes local vault data and signs out',
                    titleColor: colors.textPrimary,
                    iconColor: colors.textPrimary,
                    onTap: () => _showSignOutConfirmation(colors),
                    colors: colors,
                  ),
                  _buildDivider(colors),
                  _buildActionRow(
                    icon: Icons.delete_forever_rounded,
                    title: 'Reset SecureVault',
                    subtitle: 'Wipes all local credentials permanently',
                    titleColor: colors.error,
                    iconColor: colors.error,
                    onTap: () => _showFactoryResetConfirmation(colors),
                    colors: colors,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ── Section 4: About ─────────────────────────────────────────────
            _buildSectionLabel('ABOUT', colors),
            const SizedBox(height: 8),
            Card(
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: _buildActionRow(
                icon: Icons.security_rounded,
                title: 'SecureVault',
                subtitle: 'Version 1.0.0 — Offline-First & Encrypted',
                titleColor: colors.textPrimary,
                iconColor: colors.brandPrimary.withValues(alpha: 0.5),
                onTap: null, // Read-only
                colors: colors,
                showChevron: false,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  String _autoLockLabel(int val) {
    if (val == 0) return 'Never';
    if (val == 60) return '1 Minute';
    return '${val ~/ 60} Minutes';
  }

  Widget _buildSectionLabel(String title, AppColorsExtension colors) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: colors.textMuted,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _buildDivider(AppColorsExtension colors) {
    return Divider(
      height: 1,
      thickness: 1,
      indent: 16,
      endIndent: 16,
      color: colors.borderDefault,
    );
  }

  // Row for Switch
  Widget _buildSwitchRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required AppColorsExtension colors,
  }) {
    return InkWell(
      onTap: () => onChanged(!value),
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Icon(icon, size: 24, color: colors.textMuted),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: colors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: colors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Switch.adaptive(
              value: value,
              onChanged: onChanged,
              activeColor: colors.brandPrimary,
            ),
          ],
        ),
      ),
    );
  }

  // Row for Dropdown equivalent
  Widget _buildSelectorRow<T>({
    required IconData icon,
    required String title,
    required String subtitle,
    required T currentValue,
    required String Function(T) labelBuilder,
    required VoidCallback onTap,
    required AppColorsExtension colors,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Icon(icon, size: 24, color: colors.textMuted),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: colors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: colors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  labelBuilder(currentValue),
                  style: TextStyle(
                    fontSize: 14,
                    color: colors.textSecondary,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(Icons.chevron_right_rounded, size: 20, color: colors.textMuted),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // General action row (logout, wipe, about)
  Widget _buildActionRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color titleColor,
    required Color iconColor,
    required VoidCallback? onTap,
    required AppColorsExtension colors,
    bool showChevron = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Icon(icon, size: 24, color: iconColor),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: titleColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: colors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            if (showChevron) ...[
              const SizedBox(width: 12),
              Icon(Icons.chevron_right_rounded, size: 20, color: colors.textMuted),
            ]
          ],
        ),
      ),
    );
  }
}
