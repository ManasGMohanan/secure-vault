// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vault_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$filteredVaultEntriesHash() =>
    r'de61a304c4379a8e3c9a2946055d23b81c99e843';

/// See also [filteredVaultEntries].
@ProviderFor(filteredVaultEntries)
final filteredVaultEntriesProvider =
    AutoDisposeProvider<List<VaultEntry>>.internal(
      filteredVaultEntries,
      name: r'filteredVaultEntriesProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$filteredVaultEntriesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FilteredVaultEntriesRef = AutoDisposeProviderRef<List<VaultEntry>>;
String _$reusedPasswordsHash() => r'483c64887a685b89a7ebcbc4dd1aef2b3445e5ef';

/// See also [reusedPasswords].
@ProviderFor(reusedPasswords)
final reusedPasswordsProvider = AutoDisposeProvider<Set<String>>.internal(
  reusedPasswords,
  name: r'reusedPasswordsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$reusedPasswordsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ReusedPasswordsRef = AutoDisposeProviderRef<Set<String>>;
String _$vaultNotifierHash() => r'454ec6f83d336683cc87a7406107fb2f67bb7721';

/// See also [VaultNotifier].
@ProviderFor(VaultNotifier)
final vaultNotifierProvider =
    AsyncNotifierProvider<VaultNotifier, List<VaultEntry>>.internal(
      VaultNotifier.new,
      name: r'vaultNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$vaultNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$VaultNotifier = AsyncNotifier<List<VaultEntry>>;
String _$vaultSearchQueryHash() => r'3f2fc4e1ff64d405c6405821978b493080fc67c4';

/// See also [VaultSearchQuery].
@ProviderFor(VaultSearchQuery)
final vaultSearchQueryProvider =
    AutoDisposeNotifierProvider<VaultSearchQuery, String>.internal(
      VaultSearchQuery.new,
      name: r'vaultSearchQueryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$vaultSearchQueryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$VaultSearchQuery = AutoDisposeNotifier<String>;
String _$vaultSelectedCategoryHash() =>
    r'642a29ee2472b09735a392c6fece29d9fc7becf7';

/// See also [VaultSelectedCategory].
@ProviderFor(VaultSelectedCategory)
final vaultSelectedCategoryProvider =
    AutoDisposeNotifierProvider<VaultSelectedCategory, String>.internal(
      VaultSelectedCategory.new,
      name: r'vaultSelectedCategoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$vaultSelectedCategoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$VaultSelectedCategory = AutoDisposeNotifier<String>;
String _$vaultSortOrderNotifierHash() =>
    r'006bd1a7465f7777fd5a21f223e2d33981d13f49';

/// See also [VaultSortOrderNotifier].
@ProviderFor(VaultSortOrderNotifier)
final vaultSortOrderNotifierProvider =
    AutoDisposeNotifierProvider<
      VaultSortOrderNotifier,
      VaultSortOrder
    >.internal(
      VaultSortOrderNotifier.new,
      name: r'vaultSortOrderNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$vaultSortOrderNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$VaultSortOrderNotifier = AutoDisposeNotifier<VaultSortOrder>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
