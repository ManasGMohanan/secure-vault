import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:secure_vault/core/routing/gorouter_extension.dart';
import 'package:secure_vault/core/theme/theme.dart';
import 'package:secure_vault/features/password_generator/domain/password_generator.dart';
import '../helpers/brand_logo_helper.dart';
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

  // Per-custom-field visibility map
  final Map<int, bool> _obscureCustomField = {};

  Timer? _clipboardTimer;

  @override
  void dispose() {
    _clipboardTimer?.cancel();
    super.dispose();
  }

  // ── Clipboard ──────────────────────────────────────────────────────────────

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

  // ── Delete ─────────────────────────────────────────────────────────────────

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

  // ── Strength helpers (same logic as add_edit_entry_screen) ─────────────────

  Color _strengthColor(PasswordStrength s, AppColorsExtension colors) {
    switch (s) {
      case PasswordStrength.weak:
        return colors.error;
      case PasswordStrength.medium:
        return colors.brandAccent;
      case PasswordStrength.strong:
        return colors.successForeground;
      case PasswordStrength.veryStrong:
        return colors.success;
    }
  }

  String _strengthLabel(PasswordStrength s) {
    switch (s) {
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

  // ── Date format ────────────────────────────────────────────────────────────

  String _formatDate(DateTime dt) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final h = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final ampm = dt.hour < 12 ? 'AM' : 'PM';
    final min = dt.minute.toString().padLeft(2, '0');
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year} at $h:$min $ampm';
  }

  // ── URL launcher ───────────────────────────────────────────────────────────

  Future<void> _launchUrl(String rawUrl) async {
    // Ensure scheme is present
    final urlString = rawUrl.startsWith('http') ? rawUrl : 'https://$rawUrl';
    final uri = Uri.parse(urlString);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Could not open: $rawUrl')));
      }
    }
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final entriesAsync = ref.watch(vaultNotifierProvider);
    final theme = Theme.of(context);
    final colors = theme.extension<AppColorsExtension>()!;

    final entries = entriesAsync.valueOrNull ?? [];
    final Iterable<VaultEntry> found = entries.where((e) => e.id == widget.id);

    if (found.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Detail')),
        body: const Center(child: Text('Entry not found or has been deleted.')),
      );
    }

    final VaultEntry entry = found.first;
    final reusedPwds = ref.watch(reusedPasswordsProvider);
    final isReused = reusedPwds.contains(entry.password.trim());
    final strength = PasswordGenerator.estimateStrength(entry.password);

    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () => context.goToEditEntry(entry.id),
            child: Text(
              'Edit',
              style: TextStyle(
                color: colors.textPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── 1. Hero ──────────────────────────────────────────────────────
            _buildHero(entry, colors, theme),
            const SizedBox(height: 24),

            // ── Reused password warning ──────────────────────────────────────
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

            // ── 2. Login Details card ────────────────────────────────────────
            _buildSectionLabel('LOGIN DETAILS', colors),
            const SizedBox(height: 8),
            _buildLoginDetailsCard(entry, strength, colors, theme),
            const SizedBox(height: 20),

            // ── 3. Custom Fields card ────────────────────────────────────────
            if (entry.customFields.isNotEmpty) ...[
              _buildSectionLabel('CUSTOM FIELDS', colors),
              const SizedBox(height: 8),
              _buildCustomFieldsCard(entry, colors, theme),
              const SizedBox(height: 20),
            ],

            // ── 4. Notes card ────────────────────────────────────────────────
            if (entry.notes.isNotEmpty) ...[
              _buildSectionLabel('NOTES', colors),
              const SizedBox(height: 8),
              _buildNotesCard(entry, colors, theme),
              const SizedBox(height: 20),
            ],

            // ── 5. Password history (preserved) ──────────────────────────────
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
                shape: const Border(),
                collapsedShape: const Border(),
                children: entry.passwordHistory.map((history) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    color: colors.surfaceSecondary.withValues(alpha: 0.5),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 2,
                      ),
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
                          const SizedBox(height: 4),
                          Text(
                            history.password,
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 6),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
            ],

            // ── 6. Metadata card ─────────────────────────────────────────────
            _buildSectionLabel('META DATA', colors),
            const SizedBox(height: 8),
            _buildMetadataCard(entry, colors, theme),
            const SizedBox(height: 12),

            // ── 7. Bottom actions card ───────────────────────────────────────
            _buildActionsCard(entry, colors, theme),
          ],
        ),
      ),
    );
  }

  // ── Widgets ────────────────────────────────────────────────────────────────

  Widget _buildHero(
    VaultEntry entry,
    AppColorsExtension colors,
    ThemeData theme,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildLogoWidget(entry, colors, size: 52),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                entry.title,
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w600,
                  color: colors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              // Category pill
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: colors.brandPrimary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.grid_view_rounded,
                      size: 12,
                      color: colors.brandPrimary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      entry.category,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: colors.brandPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionLabel(String title, AppColorsExtension colors) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: colors.textMuted,
        letterSpacing: 0.8,
      ),
    );
  }

  // ─── Login Details ────────────────────────────────────────────────────────

  Widget _buildLoginDetailsCard(
    VaultEntry entry,
    PasswordStrength strength,
    AppColorsExtension colors,
    ThemeData theme,
  ) {
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          // Username
          _buildFieldRow(
            icon: Icons.person_outline_rounded,
            label: 'USERNAME',
            value: entry.username.isNotEmpty ? entry.username : '(No username)',
            colors: colors,
            theme: theme,
            onCopy: entry.username.isNotEmpty
                ? () => _copyToClipboard(entry.username, 'Username')
                : null,
          ),
          _buildDivider(colors),

          // Password
          _buildPasswordRow(entry, strength, colors, theme),

          // URL — only if present
          if (entry.url.isNotEmpty) ...[
            _buildDivider(colors),
            _buildFieldRow(
              icon: Icons.link_rounded,
              label: 'WEBSITE URL',
              value: entry.url,
              colors: colors,
              theme: theme,
              valueColor: colors.textPrimary,
              onCopy: () => _copyToClipboard(entry.url, 'URL'),
              trailingExtra: IconButton(
                icon: Icon(
                  Icons.open_in_new_rounded,
                  size: 20,
                  color: colors.textMuted,
                ),
                onPressed: () => _launchUrl(entry.url),
              ),
              onTap: () => _launchUrl(entry.url),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPasswordRow(
    VaultEntry entry,
    PasswordStrength strength,
    AppColorsExtension colors,
    ThemeData theme,
  ) {
    final sColor = _strengthColor(strength, colors);
    final sLabel = _strengthLabel(strength);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.lock_outline_rounded, size: 22, color: colors.textMuted),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'PASSWORD',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: colors.textMuted,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  _obscurePassword ? '••••••••••••' : entry.password,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: colors.textPrimary,
                    fontFamily: _obscurePassword ? null : 'monospace',
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  sLabel,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: sColor,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              _obscurePassword
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              size: 20,
              color: colors.textMuted,
            ),
            onPressed: () =>
                setState(() => _obscurePassword = !_obscurePassword),
          ),
          IconButton(
            icon: Icon(Icons.copy_rounded, size: 20, color: colors.textMuted),
            onPressed: () => _copyToClipboard(entry.password, 'Password'),
          ),
        ],
      ),
    );
  }

  // ─── Custom Fields ────────────────────────────────────────────────────────

  Widget _buildCustomFieldsCard(
    VaultEntry entry,
    AppColorsExtension colors,
    ThemeData theme,
  ) {
    final fields = entry.customFields;
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          for (int i = 0; i < fields.length; i++) ...[
            if (i > 0) _buildDivider(colors),
            _buildCustomFieldRow(i, fields[i], colors, theme),
          ],
        ],
      ),
    );
  }

  Widget _buildCustomFieldRow(
    int index,
    dynamic field,
    AppColorsExtension colors,
    ThemeData theme,
  ) {
    final isSecret = field.isSecret as bool;
    final isObscured = _obscureCustomField[index] ?? isSecret;
    final displayValue = isObscured ? '••••••••••••' : (field.value as String);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.tune_rounded, size: 22, color: colors.textMuted),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  (field.name as String).toUpperCase(),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: colors.textMuted,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  displayValue,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: colors.textPrimary,
                    fontFamily: (isSecret && !isObscured) ? 'monospace' : null,
                  ),
                ),
              ],
            ),
          ),
          if (isSecret)
            IconButton(
              icon: Icon(
                isObscured
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                size: 20,
                color: colors.textMuted,
              ),
              onPressed: () => setState(() {
                _obscureCustomField[index] = !isObscured;
              }),
            ),
          IconButton(
            icon: Icon(Icons.copy_rounded, size: 20, color: colors.textMuted),
            onPressed: () =>
                _copyToClipboard(field.value as String, field.name as String),
          ),
        ],
      ),
    );
  }

  // ─── Notes ────────────────────────────────────────────────────────────────

  Widget _buildNotesCard(
    VaultEntry entry,
    AppColorsExtension colors,
    ThemeData theme,
  ) {
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          entry.notes,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: colors.textPrimary,
            height: 1.5,
          ),
        ),
      ),
    );
  }

  // ─── Metadata ─────────────────────────────────────────────────────────────

  Widget _buildMetadataCard(
    VaultEntry entry,
    AppColorsExtension colors,
    ThemeData theme,
  ) {
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Column(
        children: [
          _buildMetaRow(
            icon: Icons.calendar_today_outlined,
            label: 'Created',
            value: _formatDate(entry.createdAt),
            colors: colors,
          ),
          _buildDivider(colors),
          _buildMetaRow(
            icon: Icons.update_rounded,
            label: 'Last updated',
            value: _formatDate(entry.updatedAt),
            colors: colors,
          ),
        ],
      ),
    );
  }

  Widget _buildMetaRow({
    required IconData icon,
    required String label,
    required String value,
    required AppColorsExtension colors,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Icon(icon, size: 16, color: colors.textMuted),
          const SizedBox(width: 12),
          Text(
            '$label  ',
            style: TextStyle(
              fontSize: 13,
              color: colors.textMuted,
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13,
                color: colors.textSecondary,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  // ─── Bottom Actions ───────────────────────────────────────────────────────

  Widget _buildActionsCard(
    VaultEntry entry,
    AppColorsExtension colors,
    ThemeData theme,
  ) {
    return Column(
      children: [
        // Favorite toggle — dynamic label + icon
        InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () async {
            final updated = entry.copyWith(
              isFavorite: !entry.isFavorite,
              updatedAt: DateTime.now(),
            );
            await ref.read(vaultNotifierProvider.notifier).updateEntry(updated);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Icon(
                  entry.isFavorite
                      ? Icons.star_rounded
                      : Icons.star_border_rounded,
                  size: 25,
                  color: entry.isFavorite ? Colors.amber : colors.textPrimary,
                ),
                const SizedBox(width: 14),
                Text(
                  entry.isFavorite
                      ? 'Remove from Favorites'
                      : 'Add to Favorites',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: colors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Delete
        InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _deleteEntry(entry, colors),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                Icon(
                  Icons.delete_outline_rounded,
                  size: 22,
                  color: colors.error,
                ),
                const SizedBox(width: 14),
                Text(
                  'Delete Credential',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: colors.error,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ─── Shared field row ─────────────────────────────────────────────────────

  Widget _buildFieldRow({
    required IconData icon,
    required String label,
    required String value,
    required AppColorsExtension colors,
    required ThemeData theme,
    Color? valueColor,
    VoidCallback? onCopy,
    VoidCallback? onTap,
    Widget? trailingExtra,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, size: 22, color: colors.textMuted),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: colors.textMuted,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: valueColor ?? colors.textPrimary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (trailingExtra != null) trailingExtra,
            if (onCopy != null)
              IconButton(
                icon: Icon(
                  Icons.copy_rounded,
                  size: 20,
                  color: colors.textMuted,
                ),
                onPressed: onCopy,
              ),
          ],
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

  // ─── Logo ─────────────────────────────────────────────────────────────────

  Widget _buildLogoWidget(
    VaultEntry entry,
    AppColorsExtension colors, {
    double size = 52,
  }) {
    final domain = getDomainFromUrlOrTitle(entry.url, entry.title);
    final localPath = getLocalSvgPath(domain, entry.title);

    Widget fallbackAvatar() {
      final initial = entry.title.trim().isNotEmpty
          ? entry.title.trim().substring(0, 1).toUpperCase()
          : '?';
      final bgColor = getBrandColor(entry.title);
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Center(
          child: Text(
            initial,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: size * 0.4,
            ),
          ),
        ),
      );
    }

    if (localPath != null) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        padding: EdgeInsets.all(size * 0.12),
        child: SvgPicture.asset(localPath, fit: BoxFit.contain),
      );
    }

    if (domain != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: size,
          height: size,
          color: Colors.white,
          child: Image.network(
            getLogoUrl(domain),
            width: size,
            height: size,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => fallbackAvatar(),
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                width: size,
                height: size,
                color: colors.surfaceSecondary,
                child: const Center(
                  child: SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              );
            },
          ),
        ),
      );
    }

    return fallbackAvatar();
  }
}
