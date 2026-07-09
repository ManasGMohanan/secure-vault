// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SettingsStateImpl _$$SettingsStateImplFromJson(Map<String, dynamic> json) =>
    _$SettingsStateImpl(
      themeMode: json['themeMode'] as String? ?? 'system',
      autoLockTimeoutSeconds:
          (json['autoLockTimeoutSeconds'] as num?)?.toInt() ?? 300,
      clipboardClearDurationSeconds:
          (json['clipboardClearDurationSeconds'] as num?)?.toInt() ?? 30,
      biometricPreferred: json['biometricPreferred'] as bool? ?? false,
    );

Map<String, dynamic> _$$SettingsStateImplToJson(_$SettingsStateImpl instance) =>
    <String, dynamic>{
      'themeMode': instance.themeMode,
      'autoLockTimeoutSeconds': instance.autoLockTimeoutSeconds,
      'clipboardClearDurationSeconds': instance.clipboardClearDurationSeconds,
      'biometricPreferred': instance.biometricPreferred,
    };
