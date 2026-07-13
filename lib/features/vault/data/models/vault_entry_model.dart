import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/vault_entry.dart';

part 'vault_entry_model.freezed.dart';
part 'vault_entry_model.g.dart';

@freezed
class PasswordHistoryEntryModel with _$PasswordHistoryEntryModel {
  const PasswordHistoryEntryModel._();

  const factory PasswordHistoryEntryModel({
    required String password,
    required String timestamp, // Stored as ISO8601 string
  }) = _PasswordHistoryEntryModel;

  factory PasswordHistoryEntryModel.fromJson(Map<String, dynamic> json) =>
      _$PasswordHistoryEntryModelFromJson(json);

  factory PasswordHistoryEntryModel.fromEntity(PasswordHistoryEntry entity) =>
      PasswordHistoryEntryModel(
        password: entity.password,
        timestamp: entity.timestamp.toIso8601String(),
      );

  PasswordHistoryEntry toEntity() => PasswordHistoryEntry(
        password: password,
        timestamp: DateTime.parse(timestamp),
      );
}

@freezed
class CustomFieldModel with _$CustomFieldModel {
  const CustomFieldModel._();

  const factory CustomFieldModel({
    required String name,
    required String value,
    @Default(false) bool isSecret,
  }) = _CustomFieldModel;

  factory CustomFieldModel.fromJson(Map<String, dynamic> json) =>
      _$CustomFieldModelFromJson(json);

  factory CustomFieldModel.fromEntity(CustomField entity) => CustomFieldModel(
        name: entity.name,
        value: entity.value,
        isSecret: entity.isSecret,
      );

  CustomField toEntity() => CustomField(
        name: name,
        value: value,
        isSecret: isSecret,
      );
}

@freezed
class VaultEntryModel with _$VaultEntryModel {
  const VaultEntryModel._();

  const factory VaultEntryModel({
    required String id,
    required String title,
    required String username,
    required String password,
    required String url,
    required String category,
    required String notes,
    required bool isFavorite,
    required String createdAt, // ISO8601
    required String updatedAt, // ISO8601
    required List<PasswordHistoryEntryModel> passwordHistory,
    required List<CustomFieldModel> customFields,
  }) = _VaultEntryModel;

  factory VaultEntryModel.fromJson(Map<String, dynamic> json) {
    final history = json['passwordHistory'] as List?;
    final fields = json['customFields'] as List?;
    
    final Map<String, dynamic> sanitizedJson = Map<String, dynamic>.from(json);
    if (history != null) {
      sanitizedJson['passwordHistory'] = history
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList();
    }
    if (fields != null) {
      sanitizedJson['customFields'] = fields
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList();
    }
    
    return _$VaultEntryModelFromJson(sanitizedJson);
  }

  factory VaultEntryModel.fromEntity(VaultEntry entity) => VaultEntryModel(
        id: entity.id,
        title: entity.title,
        username: entity.username,
        password: entity.password,
        url: entity.url,
        category: entity.category,
        notes: entity.notes,
        isFavorite: entity.isFavorite,
        createdAt: entity.createdAt.toIso8601String(),
        updatedAt: entity.updatedAt.toIso8601String(),
        passwordHistory: entity.passwordHistory
            .map((e) => PasswordHistoryEntryModel.fromEntity(e))
            .toList(),
        customFields: entity.customFields
            .map((e) => CustomFieldModel.fromEntity(e))
            .toList(),
      );

  VaultEntry toEntity() => VaultEntry(
        id: id,
        title: title,
        username: username,
        password: password,
        url: url,
        category: category,
        notes: notes,
        isFavorite: isFavorite,
        createdAt: DateTime.parse(createdAt),
        updatedAt: DateTime.parse(updatedAt),
        passwordHistory: passwordHistory.map((e) => e.toEntity()).toList(),
        customFields: customFields.map((e) => e.toEntity()).toList(),
      );
}
