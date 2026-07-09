// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vault_entry_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PasswordHistoryEntryModelImpl _$$PasswordHistoryEntryModelImplFromJson(
  Map<String, dynamic> json,
) => _$PasswordHistoryEntryModelImpl(
  password: json['password'] as String,
  timestamp: json['timestamp'] as String,
);

Map<String, dynamic> _$$PasswordHistoryEntryModelImplToJson(
  _$PasswordHistoryEntryModelImpl instance,
) => <String, dynamic>{
  'password': instance.password,
  'timestamp': instance.timestamp,
};

_$CustomFieldModelImpl _$$CustomFieldModelImplFromJson(
  Map<String, dynamic> json,
) => _$CustomFieldModelImpl(
  name: json['name'] as String,
  value: json['value'] as String,
  isSecret: json['isSecret'] as bool? ?? false,
);

Map<String, dynamic> _$$CustomFieldModelImplToJson(
  _$CustomFieldModelImpl instance,
) => <String, dynamic>{
  'name': instance.name,
  'value': instance.value,
  'isSecret': instance.isSecret,
};

_$VaultEntryModelImpl _$$VaultEntryModelImplFromJson(
  Map<String, dynamic> json,
) => _$VaultEntryModelImpl(
  id: json['id'] as String,
  title: json['title'] as String,
  username: json['username'] as String,
  password: json['password'] as String,
  url: json['url'] as String,
  category: json['category'] as String,
  notes: json['notes'] as String,
  isFavorite: json['isFavorite'] as bool,
  createdAt: json['createdAt'] as String,
  updatedAt: json['updatedAt'] as String,
  passwordHistory: (json['passwordHistory'] as List<dynamic>)
      .map((e) => PasswordHistoryEntryModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  customFields: (json['customFields'] as List<dynamic>)
      .map((e) => CustomFieldModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$$VaultEntryModelImplToJson(
  _$VaultEntryModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'username': instance.username,
  'password': instance.password,
  'url': instance.url,
  'category': instance.category,
  'notes': instance.notes,
  'isFavorite': instance.isFavorite,
  'createdAt': instance.createdAt,
  'updatedAt': instance.updatedAt,
  'passwordHistory': instance.passwordHistory.map((e) => e.toJson()).toList(),
  'customFields': instance.customFields.map((e) => e.toJson()).toList(),
};
