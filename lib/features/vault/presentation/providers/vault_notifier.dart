import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../auth/domain/entities/auth_state.dart';
import '../../../auth/presentation/providers/auth_notifier.dart';
import '../../data/vault_repository.dart';
import '../../domain/entities/vault_entry.dart';

part 'vault_notifier.g.dart';

@Riverpod(keepAlive: true)
class VaultNotifier extends _$VaultNotifier {
  bool _hasSyncedThisSession = false;

  @override
  FutureOr<List<VaultEntry>> build() async {
    final authStateAsync = ref.watch(authNotifierProvider);
    debugPrint('[VAULT_NOTIFIER] build() triggered. AuthStateAsync = $authStateAsync');

    return authStateAsync.when(
      data: (auth) async {
        final repo = ref.read(vaultRepositoryProvider);
        debugPrint('[VAULT_NOTIFIER] build() data listener: auth state class = ${auth.runtimeType}');
        if (auth is AuthUnlocked) {
          debugPrint('[VAULT_NOTIFIER] build(): Vault is Unlocked. Opening box with derived key...');
          await repo.openBox(auth.derivedKey);
          
          // Trigger remote sync in the background exactly once per unlock session
          if (!_hasSyncedThisSession) {
            debugPrint('[VAULT_NOTIFIER] build(): First unlock in session. Triggering background sync...');
            _hasSyncedThisSession = true;
            _triggerBackgroundSync(repo);
          } else {
            debugPrint('[VAULT_NOTIFIER] build(): Sync already triggered for this session. Skipping.');
          }
          
          final entries = await repo.getEntries();
          debugPrint('[VAULT_NOTIFIER] build(): Fetched ${entries.length} entries from repository.');
          return entries;
        } else {
          debugPrint('[VAULT_NOTIFIER] build(): Vault is not unlocked. Closing box and resetting session sync flag...');
          _hasSyncedThisSession = false;
          await repo.closeBox();
          return const [];
        }
      },
      loading: () {
        debugPrint('[VAULT_NOTIFIER] build() loading listener triggered.');
        return const [];
      },
      error: (err, stack) {
        debugPrint('[VAULT_NOTIFIER] build() error listener triggered: $err');
        throw err;
      },
    );
  }

  void _triggerBackgroundSync(VaultRepository repo) {
    debugPrint('[VAULT_NOTIFIER] _triggerBackgroundSync() started. Triggering repo.sync()...');
    repo.sync().then((_) async {
      // Guard against race conditions: check if the vault was locked during sync
      final authState = ref.read(authNotifierProvider).valueOrNull;
      if (authState is! AuthUnlocked) {
        debugPrint('[VAULT_NOTIFIER] sync completed but vault is no longer unlocked. Aborting state update.');
        return;
      }

      final freshEntries = await repo.getEntries();
      state = AsyncData(freshEntries);
      debugPrint('[VAULT_NOTIFIER] sync completed. State updated with ${freshEntries.length} entries.');
    }).catchError((err) {
      debugPrint('[VAULT_NOTIFIER] sync failed in background: $err');
    });
  }

  /// Adds a new vault entry.
  Future<void> addEntry(VaultEntry entry) async {
    final repo = ref.read(vaultRepositoryProvider);
    await repo.saveEntry(entry);
    ref.invalidateSelf(); // Reload entries list
  }

  /// Updates an existing vault entry.
  Future<void> updateEntry(VaultEntry entry) async {
    final repo = ref.read(vaultRepositoryProvider);
    await repo.saveEntry(entry);
    ref.invalidateSelf();
  }

  /// Deletes a vault entry.
  Future<void> deleteEntry(String id) async {
    final repo = ref.read(vaultRepositoryProvider);
    await repo.deleteEntry(id);
    ref.invalidateSelf();
  }
}

// -------------------------------------------------------------
// Filters & Search Notifiers
// -------------------------------------------------------------

@riverpod
class VaultSearchQuery extends _$VaultSearchQuery {
  @override
  String build() => '';

  void setQuery(String query) => state = query;
}

@riverpod
class VaultSelectedCategory extends _$VaultSelectedCategory {
  @override
  String build() => 'All'; // 'All', 'Favorites', 'Social', 'Banking', 'Work', 'Email', 'Other'

  void setCategory(String category) => state = category;
}

enum VaultSortOrder {
  titleAsc,
  titleDesc,
  newestFirst,
  oldestFirst,
}

@riverpod
class VaultSortOrderNotifier extends _$VaultSortOrderNotifier {
  @override
  VaultSortOrder build() => VaultSortOrder.titleAsc;

  void setSortOrder(VaultSortOrder order) => state = order;
}

// -------------------------------------------------------------
// Filtered Entries Provider
// -------------------------------------------------------------

@riverpod
List<VaultEntry> filteredVaultEntries(FilteredVaultEntriesRef ref) {
  final entriesAsync = ref.watch(vaultNotifierProvider);
  final query = ref.watch(vaultSearchQueryProvider).trim().toLowerCase();
  final category = ref.watch(vaultSelectedCategoryProvider);
  final sortOrder = ref.watch(vaultSortOrderNotifierProvider);

  final entries = entriesAsync.valueOrNull ?? [];

  // 1. Filter by category or favorite
  var result = [...entries];
  if (category == 'Favorites') {
    result = result.where((e) => e.isFavorite).toList();
  } else if (category != 'All') {
    result = result.where((e) => e.category.toLowerCase() == category.toLowerCase()).toList();
  }

  // 2. Filter by search query (title, username, url)
  if (query.isNotEmpty) {
    result = result.where((e) {
      return e.title.toLowerCase().contains(query) ||
          e.username.toLowerCase().contains(query) ||
          e.url.toLowerCase().contains(query);
    }).toList();
  }

  // 3. Sort entries
  switch (sortOrder) {
    case VaultSortOrder.titleAsc:
      result.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
      break;
    case VaultSortOrder.titleDesc:
      result.sort((a, b) => b.title.toLowerCase().compareTo(a.title.toLowerCase()));
      break;
    case VaultSortOrder.newestFirst:
      result.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      break;
    case VaultSortOrder.oldestFirst:
      result.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      break;
  }

  return result;
}

// -------------------------------------------------------------
// Reused Password Detection Provider (Nice-to-have)
// -------------------------------------------------------------

@riverpod
Set<String> reusedPasswords(ReusedPasswordsRef ref) {
  final entriesAsync = ref.watch(vaultNotifierProvider);
  final entries = entriesAsync.valueOrNull ?? [];

  // Count password frequencies
  final passwordCounts = <String, int>{};
  for (final entry in entries) {
    final pwd = entry.password.trim();
    if (pwd.isNotEmpty) {
      passwordCounts[pwd] = (passwordCounts[pwd] ?? 0) + 1;
    }
  }

  // Return passwords that are used more than once
  return passwordCounts.entries
      .where((e) => e.value > 1)
      .map((e) => e.key)
      .toSet();
}
