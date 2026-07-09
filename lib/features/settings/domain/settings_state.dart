import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings_state.freezed.dart';
part 'settings_state.g.dart';

@freezed
class SettingsState with _$SettingsState {
  const factory SettingsState({
    @Default('system') String themeMode, // 'light', 'dark', 'system'
    @Default(300) int autoLockTimeoutSeconds, // 0 = never, 60 = 1m, 300 = 5m, 600 = 10m
    @Default(30) int clipboardClearDurationSeconds,
    @Default(false) bool biometricPreferred,
  }) = _SettingsState;

  factory SettingsState.fromJson(Map<String, dynamic> json) => _$SettingsStateFromJson(json);
}
