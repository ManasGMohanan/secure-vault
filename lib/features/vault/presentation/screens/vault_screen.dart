import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:secure_vault/core/routing/gorouter_extension.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:secure_vault/core/theme/theme.dart';
import '../../../auth/presentation/providers/auth_notifier.dart';
import '../../domain/entities/vault_entry.dart';
import '../../presentation/providers/vault_notifier.dart';

class VaultScreen extends ConsumerStatefulWidget {
  const VaultScreen({super.key});

  @override
  ConsumerState<VaultScreen> createState() => _VaultScreenState();
}

class _VaultScreenState extends ConsumerState<VaultScreen> {
  final _searchController = TextEditingController();
  String _selectedCategory = 'All';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _copyToClipboard(String value, String label) {
    Clipboard.setData(ClipboardData(text: value));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label copied to clipboard!'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColorsExtension>()!;

    final vaultState = ref.watch(vaultNotifierProvider);
    final allEntries = vaultState.valueOrNull ?? [];

    // Filter by search query
    final query = _searchController.text.toLowerCase();
    final searchedEntries = allEntries.where((entry) {
      final matchesQuery =
          entry.title.toLowerCase().contains(query) ||
          entry.username.toLowerCase().contains(query) ||
          entry.url.toLowerCase().contains(query);
      return matchesQuery;
    }).toList();

    // Find reused passwords
    final pwdCounts = <String, int>{};
    for (final e in allEntries) {
      final p = e.password.trim();
      if (p.isNotEmpty) {
        pwdCounts[p] = (pwdCounts[p] ?? 0) + 1;
      }
    }
    final reusedPwds = pwdCounts.entries
        .where((entry) => entry.value > 1)
        .map((entry) => entry.key)
        .toSet();

    // Filter by category tab
    final filteredEntries = searchedEntries.where((entry) {
      if (_selectedCategory == 'All') return true;
      if (_selectedCategory == 'Favorites') return entry.isFavorite;
      return entry.category.toLowerCase() == _selectedCategory.toLowerCase();
    }).toList();

    final categories = [
      'All',
      'Favorites',
      'Social',
      'Banking',
      'Work',
      'Email',
      'Other',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('SecureVault'),
        actions: [
          IconButton(
            icon: const Icon(Icons.lock_open_rounded),
            tooltip: 'Lock Vault',
            onPressed: () {
              ref.read(authNotifierProvider.notifier).lock();
            },
          ),
          IconButton(
            icon: const Icon(LucideIcons.settings),
            tooltip: 'Settings',
            onPressed: () => context.goToSettings(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Search title, username, or URL...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {});
                        },
                      )
                    : null,
              ),
            ),
          ),

          // Categories horizontal scroll bar
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = category == _selectedCategory;
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 8,
                  ),
                  child: ChoiceChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _selectedCategory = category;
                        });
                      }
                    },
                    selectedColor: colors.brandPrimary.withValues(alpha: 0.15),
                    backgroundColor: Colors.transparent,
                    labelStyle: TextStyle(
                      color: isSelected
                          ? colors.brandPrimary
                          : colors.textMuted,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w500,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    side: BorderSide(
                      color: isSelected
                          ? colors.brandPrimary.withValues(alpha: 0.5)
                          : colors.borderDefault,
                    ),
                  ),
                );
              },
            ),
          ),

          // Entries List
          Expanded(
            child: filteredEntries.isEmpty
                ? _buildEmptyState(theme, colors)
                : ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: filteredEntries.length,
                    itemBuilder: (context, index) {
                      final entry = filteredEntries[index];
                      final isReused = reusedPwds.contains(
                        entry.password.trim(),
                      );
                      return _buildEntryCard(
                        context,
                        entry,
                        isReused,
                        theme,
                        colors,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme, AppColorsExtension colors) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.folder_open_outlined,
            size: 64,
            color: colors.textDisabled,
          ),
          const SizedBox(height: 16),
          Text(
            'No credentials found',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colors.textSecondary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Tap the + button to add a new account.',
            style: theme.textTheme.bodySmall?.copyWith(color: colors.textMuted),
          ),
        ],
      ),
    );
  }

  Widget _buildEntryCard(
    BuildContext context,
    VaultEntry entry,
    bool isReused,
    ThemeData theme,
    AppColorsExtension colors,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: colors.brandPrimary.withValues(alpha: 0.1),
          foregroundColor: colors.brandPrimary,
          child: Icon(_getCategoryIcon(entry.category)),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                entry.title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (entry.isFavorite)
              const Icon(Icons.star, color: Colors.amber, size: 18),
            if (isReused) ...[
              const SizedBox(width: 4),
              Tooltip(
                message: 'Warning: This password is reused across accounts!',
                child: Icon(
                  Icons.warning_amber_rounded,
                  color: colors.error, // Safe error warning mapping
                  size: 18,
                ),
              ),
            ],
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              entry.username.isNotEmpty ? entry.username : '(No username)',
              style: TextStyle(color: colors.textMuted, fontSize: 14),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.copy_rounded, size: 20),
              tooltip: 'Copy Password',
              onPressed: () => _copyToClipboard(entry.password, 'Password'),
            ),
            const Icon(Icons.chevron_right_rounded),
          ],
        ),
        onTap: () {
          context.goToEntryDetail(entry.id);
        },
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'social':
        return Icons.people_outline;
      case 'banking':
        return Icons.account_balance_outlined;
      case 'work':
        return Icons.business_center_outlined;
      case 'email':
        return Icons.alternate_email_outlined;
      default:
        return Icons.vpn_key_outlined;
    }
  }
}
