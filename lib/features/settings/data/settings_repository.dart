import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/settings_state.dart';

part 'settings_repository.g.dart';

@riverpod
SharedPreferences sharedPreferences(SharedPreferencesRef ref) {
  throw UnimplementedError('SharedPreferences provider was not overridden in main.dart');
}

class SettingsRepository {
  final SharedPreferences _prefs;
  static const _key = 'secure_vault_settings';

  SettingsRepository(this._prefs);

  SettingsState loadSettings() {
    final raw = _prefs.getString(_key);
    if (raw == null) return const SettingsState();
    try {
      return SettingsState.fromJson(json.decode(raw) as Map<String, dynamic>);
    } catch (_) {
      return const SettingsState();
    }
  }

  Future<void> saveSettings(SettingsState settings) async {
    await _prefs.setString(_key, json.encode(settings.toJson()));
  }
}

@riverpod
SettingsRepository settingsRepository(SettingsRepositoryRef ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return SettingsRepository(prefs);
}
