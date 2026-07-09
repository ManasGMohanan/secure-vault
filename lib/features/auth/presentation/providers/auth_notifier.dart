import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/security/biometric_service.dart';
import '../../../settings/presentation/providers/settings_notifier.dart';
import '../../data/auth_repository.dart';
import '../../domain/entities/auth_state.dart';
import '../../../vault/data/vault_repository.dart';

part 'auth_notifier.g.dart';

@Riverpod(keepAlive: true)
class AuthNotifier extends _$AuthNotifier with WidgetsBindingObserver {
  Timer? _idleTimer;
  DateTime _lastActivity = DateTime.now();
  bool _biometricsAuthInProgress = false;
  bool _isPerformingOnboarding = false;
  bool _observerRegistered = false;

  @override
  Future<AuthState> build() async {
    // Add lifecycle observer to detect backgrounding
    if (!_observerRegistered) {
      WidgetsBinding.instance.addObserver(this);
      _observerRegistered = true;
    }
    
    // Clean up observer when provider is disposed
    ref.onDispose(() {
      WidgetsBinding.instance.removeObserver(this);
      _observerRegistered = false;
      _stopIdleTimer();
    });

    final repo = ref.watch(authRepositoryProvider);
    final initialized = await repo.isInitialized();
    if (!initialized) {
      return const AuthState.uninitialized();
    }
    
    final bioEnabled = await repo.isBiometricEnabled();
    return AuthState.locked(biometricEnabled: bioEnabled);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final authState = this.state.valueOrNull;

    if (state == AppLifecycleState.paused && 
        !_isPerformingOnboarding && 
        authState != null && 
        authState is! AuthUninitialized) {
      lock();
    }
  }

  /// Mark user activity to reset the idle timer
  void recordActivity() {
    _lastActivity = DateTime.now();
  }

  void _startIdleTimer(Duration timeout) {
    _stopIdleTimer();
    _idleTimer = Timer.periodic(const Duration(seconds: 5), (_) async {
      final stateVal = state.valueOrNull;
      if (stateVal is AuthUnlocked) {
        final elapsed = DateTime.now().difference(_lastActivity);
        if (elapsed >= timeout) {
          await lock();
        }
      }
    });
  }

  void _stopIdleTimer() {
    _idleTimer?.cancel();
    _idleTimer = null;
  }

  /// Sets up a new synced master password account (first launch)
  Future<void> registerSyncedAccount(String email, String password) async {
    _isPerformingOnboarding = true;
    state = const AsyncLoading();
    try {
      final repo = ref.read(authRepositoryProvider);
      final keys = await repo.registerSyncedAccount(email, password);
      state = AsyncData(AuthState.unlocked(derivedKey: keys.encryptionKey));
      
      _resetIdleTimer();
    } catch (e, st) {
      state = AsyncError(e, st);
    } finally {
      _isPerformingOnboarding = false;
    }
  }

  /// Restores a synced master password account on a new device
  Future<void> restoreSyncedAccount(String email, String password) async {
    _isPerformingOnboarding = true;
    state = const AsyncLoading();
    try {
      final repo = ref.read(authRepositoryProvider);
      final keys = await repo.restoreSyncedAccount(email, password);
      state = AsyncData(AuthState.unlocked(derivedKey: keys.encryptionKey));
      
      _resetIdleTimer();
    } catch (e, st) {
      state = AsyncError(e, st);
    } finally {
      _isPerformingOnboarding = false;
    }
  }

  /// Unlocks the vault locally with the master password (offline-first)
  Future<void> unlockWithPassword(String password) async {
    state = const AsyncLoading();
    try {
      final repo = ref.read(authRepositoryProvider);
      final keys = await repo.unlockWithPassword(password);
      state = AsyncData(AuthState.unlocked(derivedKey: keys.encryptionKey));
      
      _resetIdleTimer();
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  /// Unlocks the vault using biometric authentication
  Future<void> unlockWithBiometrics() async {
    if (_biometricsAuthInProgress) return;

    final currentState = state.valueOrNull;
    if (currentState is! AuthLocked || !currentState.biometricEnabled) {
      return;
    }

    _biometricsAuthInProgress = true;
    state = const AsyncLoading();
    try {
      final bioService = ref.read(biometricServiceProvider);
      final success = await bioService.authenticate('Unlock SecureVault');
      
      if (!success) {
        final repo = ref.read(authRepositoryProvider);
        final bioEnabled = await repo.isBiometricEnabled();
        state = AsyncData(AuthState.locked(
          biometricEnabled: bioEnabled,
          hasAttemptedBiometrics: true,
        ));
        return;
      }

      final repo = ref.read(authRepositoryProvider);
      final key = await repo.unlockWithBiometrics();
      state = AsyncData(AuthState.unlocked(derivedKey: key));
      
      _resetIdleTimer();
    } catch (_) {
      final repo = ref.read(authRepositoryProvider);
      final bioEnabled = await repo.isBiometricEnabled().then((value) => value).catchError((_) => false);
      state = AsyncData(AuthState.locked(
        biometricEnabled: bioEnabled,
        hasAttemptedBiometrics: true,
      ));
    } finally {
      _biometricsAuthInProgress = false;
    }
  }

  /// Locks the vault and clears the key from memory
  Future<void> lock() async {
    _stopIdleTimer();
    final repo = ref.read(authRepositoryProvider);
    final isEnabled = await repo.isBiometricEnabled();
    state = AsyncData(AuthState.locked(biometricEnabled: isEnabled));
  }

  /// Toggle biometrics status
  Future<void> toggleBiometrics(bool enable) async {
    final currentState = state.valueOrNull;
    if (currentState is! AuthUnlocked) {
      throw const Failure.unknown('Must be unlocked to configure biometrics');
    }
    
    final repo = ref.read(authRepositoryProvider);
    if (enable) {
      // Check if biometric is physically available
      final bioService = ref.read(biometricServiceProvider);
      final hasHardware = await bioService.canAuthenticate();
      if (!hasHardware) {
        throw const Failure.biometricNotAvailable();
      }
      
      // Perform authentication to confirm
      final confirmed = await bioService.authenticate('Enable Biometric Unlock');
      if (!confirmed) {
        throw const Failure.biometricFailed();
      }

      await repo.enableBiometrics(currentState.derivedKey);
    } else {
      await repo.disableBiometrics();
    }
    
    // Refresh state key without locking
    state = AsyncData(AuthState.unlocked(derivedKey: currentState.derivedKey));
  }

  /// Reset/wipe all vault settings and keys (recovery fallback copy)
  Future<void> factoryReset() async {
    state = const AsyncLoading();
    try {
      final repo = ref.read(authRepositoryProvider);
      await repo.clearVaultData();
      
      // Also delete the local Hive database file completely from disk
      await ref.read(vaultRepositoryProvider).wipeLocalDatabase();
      
      state = const AsyncData(AuthState.uninitialized());
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  void _resetIdleTimer() {
    recordActivity();
    final settings = ref.read(settingsNotifierProvider);
    final durationSeconds = settings.autoLockTimeoutSeconds;
    if (durationSeconds > 0) {
      _startIdleTimer(Duration(seconds: durationSeconds));
    } else {
      _stopIdleTimer();
    }
  }
}
