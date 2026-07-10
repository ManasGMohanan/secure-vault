import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:secure_vault/core/routing/gorouter_extension.dart';
import 'package:secure_vault/core/theme/theme.dart';
import '../../domain/entities/vault_entry.dart';
import '../../presentation/providers/vault_notifier.dart';
import '../../../settings/presentation/providers/settings_notifier.dart';

class VaultEntryDetailScreen extends ConsumerStatefulWidget {
  final String id;
  const VaultEntryDetailScreen({super.key, required this.id});

  @override
  ConsumerState<VaultEntryDetailScreen> createState() =>
      _VaultEntryDetailScreenState();
}

class _VaultEntryDetailScreenState
    extends ConsumerState<VaultEntryDetailScreen> {
  bool _obscurePassword = true;
  Timer? _clipboardTimer;

  @override
  void dispose() {
    _clipboardTimer?.cancel();
    super.dispose();
  }

  void _copyToClipboard(String text, String label) {
    final settings = ref.read(settingsNotifierProvider);
    final clearDuration = settings.clipboardClearDurationSeconds;

    Clipboard.setData(ClipboardData(text: text));

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label copied! (Auto-clears in $clearDuration seconds)'),
        behavior: SnackBarBehavior.floating,
      ),
    );

    _clipboardTimer?.cancel();
    _clipboardTimer = Timer(Duration(seconds: clearDuration), () async {
      final currentClipboard = await Clipboard.getData(Clipboard.kTextPlain);
      if (currentClipboard?.text == text) {
        await Clipboard.setData(const ClipboardData(text: ''));
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Clipboard cleared for security.'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    });
  }

  Future<void> _deleteEntry(VaultEntry entry, AppColorsExtension colors) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Credential?'),
        content: Text(
          'Are you sure you want to delete the credentials for "${entry.title}"? This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: colors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await ref.read(vaultNotifierProvider.notifier).deleteEntry(entry.id);
      if (mounted) {
        context.goToHome();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final entriesAsync = ref.watch(vaultNotifierProvider);
    final theme = Theme.of(context);
    final colors = theme.extension<AppColorsExtension>()!;

    final entries = entriesAsync.valueOrNull ?? [];
    final Iterable<VaultEntry> found = entries.where((e) => e.id == widget.id);

    // If entry not found, show error/loader
    if (found.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Detail')),
        body: const Center(child: Text('Entry not found or has been deleted.')),
      );
    }

    final VaultEntry entry = found.first;

    final reusedPwds = ref.watch(reusedPasswordsProvider);
    final isReused = reusedPwds.contains(entry.password.trim());

    return Scaffold(
      appBar: AppBar(
        title: Text(entry.title),
        actions: [
          IconButton(
            icon: Icon(
              entry.isFavorite ? Icons.star : Icons.star_border,
              color: entry.isFavorite ? Colors.amber : null,
            ),
            onPressed: () async {
              final updated = entry.copyWith(
                isFavorite: !entry.isFavorite,
                updatedAt: DateTime.now(),
              );
              await ref
                  .read(vaultNotifierProvider.notifier)
                  .updateEntry(updated);
            },
          ),
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => context.goToEditEntry(entry.id),
          ),
          IconButton(
            icon: Icon(Icons.delete_outline, color: colors.error),
            onPressed: () => _deleteEntry(entry, colors),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Category tag
            Align(
              alignment: Alignment.centerLeft,
              child: Chip(
                label: Text(entry.category),
                backgroundColor: colors.brandPrimary.withValues(alpha: 0.1),
                side: BorderSide.none,
              ),
            ),
            const SizedBox(height: 16),

            // Warning if Reused password
            if (isReused) ...[
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colors.errorBackground,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: colors.error.withValues(alpha: 0.4),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      color: colors.errorForeground,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'This password is reused in other vault entries. Reusing passwords increases risk if one account is compromised.',
                        style: TextStyle(
                          fontSize: 13,
                          color: colors.errorForeground,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // Main Credential Details Box
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    _buildDetailRow(
                      label: 'USERNAME',
                      value: entry.username.isNotEmpty ? entry.username : '(No username)',
                      icon: Icons.person_outline_rounded,
                      onCopy: entry.username.isNotEmpty
                          ? () => _copyToClipboard(entry.username, 'Username')
                          : null,
                    ),
                    const Divider(height: 32),
                    _buildDetailRow(
                      label: 'PASSWORD',
                      value: entry.password,
                      icon: Icons.lock_outline_rounded,
                      isObscured: _obscurePassword,
                      onObscureToggle: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                      onCopy: () => _copyToClipboard(entry.password, 'Password'),
                    ),
                    if (entry.url.isNotEmpty) ...[
                      const Divider(height: 32),
                      _buildDetailRow(
                        label: 'WEBSITE URL',
                        value: entry.url,
                        icon: Icons.link_rounded,
                        onCopy: () => _copyToClipboard(entry.url, 'URL'),
                        onTap: () async {
                          final uri = Uri.parse(entry.url);
                          if (await canLaunchUrl(uri)) {
                            await launchUrl(uri);
                          }
                        },
                      ),
                    ],
                    if (entry.notes.isNotEmpty) ...[
                      const Divider(height: 32),
                      _buildDetailRow(
                        label: 'NOTES',
                        value: entry.notes,
                        icon: Icons.note_alt_outlined,
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Password History Expandable section
            if (entry.passwordHistory.isNotEmpty) ...[
              ExpansionTile(
                title: Text(
                  'Password History (${entry.passwordHistory.length})',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                tilePadding: EdgeInsets.zero,
                children: entry.passwordHistory.map((history) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    color: colors.surfaceSecondary.withValues(alpha: 0.5),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Changed on: ${_formatDate(history.timestamp)}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: colors.textMuted,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.copy, size: 16),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                onPressed: () => _copyToClipboard(
                                  history.password,
                                  'Previous Password',
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            history.password,
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
            ],

            // Timestamps
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Created: ${_formatDate(entry.createdAt)}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Last updated: ${_formatDate(entry.updatedAt)}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required String label,
    required String value,
    required IconData icon,
    bool isObscured = false,
    VoidCallback? onObscureToggle,
    VoidCallback? onCopy,
    VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColorsExtension>()!;
    final displayValue = isObscured ? '••••••••••••' : value;

    return Row(
      children: [
        Icon(icon, color: colors.brandPrimary, size: 24),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colors.textMuted,
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 2),
              InkWell(
                onTap: onTap,
                child: Text(
                  displayValue,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    fontFamily: isObscured ? null : 'monospace',
                  ),
                ),
              ),
            ],
          ),
        ),
        if (onObscureToggle != null)
          IconButton(
            icon: Icon(
              isObscured
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
            ),
            onPressed: onObscureToggle,
          ),
        if (onCopy != null)
          IconButton(icon: const Icon(Icons.copy_rounded), onPressed: onCopy),
      ],
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')} '
        '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
}

// Dummy helper methods for URL launching matching the original features
Future<bool> canLaunchUrl(Uri uri) async => true;
Future<void> launchUrl(Uri uri) async {}
