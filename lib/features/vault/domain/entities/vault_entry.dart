import 'package:freezed_annotation/freezed_annotation.dart';

part 'vault_entry.freezed.dart';

@freezed
class PasswordHistoryEntry with _$PasswordHistoryEntry {
  const factory PasswordHistoryEntry({
    required String password,
    required DateTime timestamp,
  }) = _PasswordHistoryEntry;
}

@freezed
class CustomField with _$CustomField {
  const factory CustomField({
    required String name,
    required String value,
    @Default(false) bool isSecret,
  }) = _CustomField;
}

@freezed
class VaultEntry with _$VaultEntry {
  const factory VaultEntry({
    required String id,
    required String title,
    required String username,
    required String password,
    required String url,
    required String category,
    required String notes,
    required bool isFavorite,
    required DateTime createdAt,
    required DateTime updatedAt,
    required List<PasswordHistoryEntry> passwordHistory,
    required List<CustomField> customFields,
  }) = _VaultEntry;
}
