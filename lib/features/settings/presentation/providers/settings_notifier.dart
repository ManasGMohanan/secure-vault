import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/settings_repository.dart';
import '../../domain/settings_state.dart';

part 'settings_notifier.g.dart';

@riverpod
class SettingsNotifier extends _$SettingsNotifier {
  @override
  SettingsState build() {
    final repo = ref.watch(settingsRepositoryProvider);
    return repo.loadSettings();
  }

  Future<void> updateThemeMode(String mode) async {
    final newState = state.copyWith(themeMode: mode);
    state = newState;
    await ref.read(settingsRepositoryProvider).saveSettings(newState);
  }

  Future<void> updateAutoLockTimeout(int seconds) async {
    final newState = state.copyWith(autoLockTimeoutSeconds: seconds);
    state = newState;
    await ref.read(settingsRepositoryProvider).saveSettings(newState);
  }

  Future<void> updateClipboardClearDuration(int seconds) async {
    final newState = state.copyWith(clipboardClearDurationSeconds: seconds);
    state = newState;
    await ref.read(settingsRepositoryProvider).saveSettings(newState);
  }

  Future<void> updateBiometricPreferred(bool preferred) async {
    final newState = state.copyWith(biometricPreferred: preferred);
    state = newState;
    await ref.read(settingsRepositoryProvider).saveSettings(newState);
  }
}
