// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vault_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$PasswordHistoryEntry {
  String get password => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;

  /// Create a copy of PasswordHistoryEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PasswordHistoryEntryCopyWith<PasswordHistoryEntry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PasswordHistoryEntryCopyWith<$Res> {
  factory $PasswordHistoryEntryCopyWith(
    PasswordHistoryEntry value,
    $Res Function(PasswordHistoryEntry) then,
  ) = _$PasswordHistoryEntryCopyWithImpl<$Res, PasswordHistoryEntry>;
  @useResult
  $Res call({String password, DateTime timestamp});
}

/// @nodoc
class _$PasswordHistoryEntryCopyWithImpl<
  $Res,
  $Val extends PasswordHistoryEntry
>
    implements $PasswordHistoryEntryCopyWith<$Res> {
  _$PasswordHistoryEntryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PasswordHistoryEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? password = null, Object? timestamp = null}) {
    return _then(
      _value.copyWith(
            password: null == password
                ? _value.password
                : password // ignore: cast_nullable_to_non_nullable
                      as String,
            timestamp: null == timestamp
                ? _value.timestamp
                : timestamp // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PasswordHistoryEntryImplCopyWith<$Res>
    implements $PasswordHistoryEntryCopyWith<$Res> {
  factory _$$PasswordHistoryEntryImplCopyWith(
    _$PasswordHistoryEntryImpl value,
    $Res Function(_$PasswordHistoryEntryImpl) then,
  ) = __$$PasswordHistoryEntryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String password, DateTime timestamp});
}

/// @nodoc
class __$$PasswordHistoryEntryImplCopyWithImpl<$Res>
    extends _$PasswordHistoryEntryCopyWithImpl<$Res, _$PasswordHistoryEntryImpl>
    implements _$$PasswordHistoryEntryImplCopyWith<$Res> {
  __$$PasswordHistoryEntryImplCopyWithImpl(
    _$PasswordHistoryEntryImpl _value,
    $Res Function(_$PasswordHistoryEntryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PasswordHistoryEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? password = null, Object? timestamp = null}) {
    return _then(
      _$PasswordHistoryEntryImpl(
        password: null == password
            ? _value.password
            : password // ignore: cast_nullable_to_non_nullable
                  as String,
        timestamp: null == timestamp
            ? _value.timestamp
            : timestamp // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc

class _$PasswordHistoryEntryImpl implements _PasswordHistoryEntry {
  const _$PasswordHistoryEntryImpl({
    required this.password,
    required this.timestamp,
  });

  @override
  final String password;
  @override
  final DateTime timestamp;

  @override
  String toString() {
    return 'PasswordHistoryEntry(password: $password, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PasswordHistoryEntryImpl &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp));
  }

  @override
  int get hashCode => Object.hash(runtimeType, password, timestamp);

  /// Create a copy of PasswordHistoryEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PasswordHistoryEntryImplCopyWith<_$PasswordHistoryEntryImpl>
  get copyWith =>
      __$$PasswordHistoryEntryImplCopyWithImpl<_$PasswordHistoryEntryImpl>(
        this,
        _$identity,
      );
}

abstract class _PasswordHistoryEntry implements PasswordHistoryEntry {
  const factory _PasswordHistoryEntry({
    required final String password,
    required final DateTime timestamp,
  }) = _$PasswordHistoryEntryImpl;

  @override
  String get password;
  @override
  DateTime get timestamp;

  /// Create a copy of PasswordHistoryEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PasswordHistoryEntryImplCopyWith<_$PasswordHistoryEntryImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$CustomField {
  String get name => throw _privateConstructorUsedError;
  String get value => throw _privateConstructorUsedError;
  bool get isSecret => throw _privateConstructorUsedError;

  /// Create a copy of CustomField
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CustomFieldCopyWith<CustomField> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CustomFieldCopyWith<$Res> {
  factory $CustomFieldCopyWith(
    CustomField value,
    $Res Function(CustomField) then,
  ) = _$CustomFieldCopyWithImpl<$Res, CustomField>;
  @useResult
  $Res call({String name, String value, bool isSecret});
}

/// @nodoc
class _$CustomFieldCopyWithImpl<$Res, $Val extends CustomField>
    implements $CustomFieldCopyWith<$Res> {
  _$CustomFieldCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CustomField
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? value = null,
    Object? isSecret = null,
  }) {
    return _then(
      _value.copyWith(
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            value: null == value
                ? _value.value
                : value // ignore: cast_nullable_to_non_nullable
                      as String,
            isSecret: null == isSecret
                ? _value.isSecret
                : isSecret // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CustomFieldImplCopyWith<$Res>
    implements $CustomFieldCopyWith<$Res> {
  factory _$$CustomFieldImplCopyWith(
    _$CustomFieldImpl value,
    $Res Function(_$CustomFieldImpl) then,
  ) = __$$CustomFieldImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, String value, bool isSecret});
}

/// @nodoc
class __$$CustomFieldImplCopyWithImpl<$Res>
    extends _$CustomFieldCopyWithImpl<$Res, _$CustomFieldImpl>
    implements _$$CustomFieldImplCopyWith<$Res> {
  __$$CustomFieldImplCopyWithImpl(
    _$CustomFieldImpl _value,
    $Res Function(_$CustomFieldImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CustomField
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? value = null,
    Object? isSecret = null,
  }) {
    return _then(
      _$CustomFieldImpl(
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        value: null == value
            ? _value.value
            : value // ignore: cast_nullable_to_non_nullable
                  as String,
        isSecret: null == isSecret
            ? _value.isSecret
            : isSecret // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$CustomFieldImpl implements _CustomField {
  const _$CustomFieldImpl({
    required this.name,
    required this.value,
    this.isSecret = false,
  });

  @override
  final String name;
  @override
  final String value;
  @override
  @JsonKey()
  final bool isSecret;

  @override
  String toString() {
    return 'CustomField(name: $name, value: $value, isSecret: $isSecret)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CustomFieldImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.isSecret, isSecret) ||
                other.isSecret == isSecret));
  }

  @override
  int get hashCode => Object.hash(runtimeType, name, value, isSecret);

  /// Create a copy of CustomField
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CustomFieldImplCopyWith<_$CustomFieldImpl> get copyWith =>
      __$$CustomFieldImplCopyWithImpl<_$CustomFieldImpl>(this, _$identity);
}

abstract class _CustomField implements CustomField {
  const factory _CustomField({
    required final String name,
    required final String value,
    final bool isSecret,
  }) = _$CustomFieldImpl;

  @override
  String get name;
  @override
  String get value;
  @override
  bool get isSecret;

  /// Create a copy of CustomField
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CustomFieldImplCopyWith<_$CustomFieldImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$VaultEntry {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get username => throw _privateConstructorUsedError;
  String get password => throw _privateConstructorUsedError;
  String get url => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  String get notes => throw _privateConstructorUsedError;
  bool get isFavorite => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  List<PasswordHistoryEntry> get passwordHistory =>
      throw _privateConstructorUsedError;
  List<CustomField> get customFields => throw _privateConstructorUsedError;

  /// Create a copy of VaultEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VaultEntryCopyWith<VaultEntry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VaultEntryCopyWith<$Res> {
  factory $VaultEntryCopyWith(
    VaultEntry value,
    $Res Function(VaultEntry) then,
  ) = _$VaultEntryCopyWithImpl<$Res, VaultEntry>;
  @useResult
  $Res call({
    String id,
    String title,
    String username,
    String password,
    String url,
    String category,
    String notes,
    bool isFavorite,
    DateTime createdAt,
    DateTime updatedAt,
    List<PasswordHistoryEntry> passwordHistory,
    List<CustomField> customFields,
  });
}

/// @nodoc
class _$VaultEntryCopyWithImpl<$Res, $Val extends VaultEntry>
    implements $VaultEntryCopyWith<$Res> {
  _$VaultEntryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VaultEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? username = null,
    Object? password = null,
    Object? url = null,
    Object? category = null,
    Object? notes = null,
    Object? isFavorite = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? passwordHistory = null,
    Object? customFields = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            username: null == username
                ? _value.username
                : username // ignore: cast_nullable_to_non_nullable
                      as String,
            password: null == password
                ? _value.password
                : password // ignore: cast_nullable_to_non_nullable
                      as String,
            url: null == url
                ? _value.url
                : url // ignore: cast_nullable_to_non_nullable
                      as String,
            category: null == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as String,
            notes: null == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String,
            isFavorite: null == isFavorite
                ? _value.isFavorite
                : isFavorite // ignore: cast_nullable_to_non_nullable
                      as bool,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            passwordHistory: null == passwordHistory
                ? _value.passwordHistory
                : passwordHistory // ignore: cast_nullable_to_non_nullable
                      as List<PasswordHistoryEntry>,
            customFields: null == customFields
                ? _value.customFields
                : customFields // ignore: cast_nullable_to_non_nullable
                      as List<CustomField>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$VaultEntryImplCopyWith<$Res>
    implements $VaultEntryCopyWith<$Res> {
  factory _$$VaultEntryImplCopyWith(
    _$VaultEntryImpl value,
    $Res Function(_$VaultEntryImpl) then,
  ) = __$$VaultEntryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    String username,
    String password,
    String url,
    String category,
    String notes,
    bool isFavorite,
    DateTime createdAt,
    DateTime updatedAt,
    List<PasswordHistoryEntry> passwordHistory,
    List<CustomField> customFields,
  });
}

/// @nodoc
class __$$VaultEntryImplCopyWithImpl<$Res>
    extends _$VaultEntryCopyWithImpl<$Res, _$VaultEntryImpl>
    implements _$$VaultEntryImplCopyWith<$Res> {
  __$$VaultEntryImplCopyWithImpl(
    _$VaultEntryImpl _value,
    $Res Function(_$VaultEntryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of VaultEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? username = null,
    Object? password = null,
    Object? url = null,
    Object? category = null,
    Object? notes = null,
    Object? isFavorite = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? passwordHistory = null,
    Object? customFields = null,
  }) {
    return _then(
      _$VaultEntryImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        username: null == username
            ? _value.username
            : username // ignore: cast_nullable_to_non_nullable
                  as String,
        password: null == password
            ? _value.password
            : password // ignore: cast_nullable_to_non_nullable
                  as String,
        url: null == url
            ? _value.url
            : url // ignore: cast_nullable_to_non_nullable
                  as String,
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as String,
        notes: null == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String,
        isFavorite: null == isFavorite
            ? _value.isFavorite
            : isFavorite // ignore: cast_nullable_to_non_nullable
                  as bool,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        passwordHistory: null == passwordHistory
            ? _value._passwordHistory
            : passwordHistory // ignore: cast_nullable_to_non_nullable
                  as List<PasswordHistoryEntry>,
        customFields: null == customFields
            ? _value._customFields
            : customFields // ignore: cast_nullable_to_non_nullable
                  as List<CustomField>,
      ),
    );
  }
}

/// @nodoc

class _$VaultEntryImpl implements _VaultEntry {
  const _$VaultEntryImpl({
    required this.id,
    required this.title,
    required this.username,
    required this.password,
    required this.url,
    required this.category,
    required this.notes,
    required this.isFavorite,
    required this.createdAt,
    required this.updatedAt,
    required final List<PasswordHistoryEntry> passwordHistory,
    required final List<CustomField> customFields,
  }) : _passwordHistory = passwordHistory,
       _customFields = customFields;

  @override
  final String id;
  @override
  final String title;
  @override
  final String username;
  @override
  final String password;
  @override
  final String url;
  @override
  final String category;
  @override
  final String notes;
  @override
  final bool isFavorite;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  final List<PasswordHistoryEntry> _passwordHistory;
  @override
  List<PasswordHistoryEntry> get passwordHistory {
    if (_passwordHistory is EqualUnmodifiableListView) return _passwordHistory;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_passwordHistory);
  }

  final List<CustomField> _customFields;
  @override
  List<CustomField> get customFields {
    if (_customFields is EqualUnmodifiableListView) return _customFields;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_customFields);
  }

  @override
  String toString() {
    return 'VaultEntry(id: $id, title: $title, username: $username, password: $password, url: $url, category: $category, notes: $notes, isFavorite: $isFavorite, createdAt: $createdAt, updatedAt: $updatedAt, passwordHistory: $passwordHistory, customFields: $customFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VaultEntryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.isFavorite, isFavorite) ||
                other.isFavorite == isFavorite) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality().equals(
              other._passwordHistory,
              _passwordHistory,
            ) &&
            const DeepCollectionEquality().equals(
              other._customFields,
              _customFields,
            ));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    username,
    password,
    url,
    category,
    notes,
    isFavorite,
    createdAt,
    updatedAt,
    const DeepCollectionEquality().hash(_passwordHistory),
    const DeepCollectionEquality().hash(_customFields),
  );

  /// Create a copy of VaultEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VaultEntryImplCopyWith<_$VaultEntryImpl> get copyWith =>
      __$$VaultEntryImplCopyWithImpl<_$VaultEntryImpl>(this, _$identity);
}

abstract class _VaultEntry implements VaultEntry {
  const factory _VaultEntry({
    required final String id,
    required final String title,
    required final String username,
    required final String password,
    required final String url,
    required final String category,
    required final String notes,
    required final bool isFavorite,
    required final DateTime createdAt,
    required final DateTime updatedAt,
    required final List<PasswordHistoryEntry> passwordHistory,
    required final List<CustomField> customFields,
  }) = _$VaultEntryImpl;

  @override
  String get id;
  @override
  String get title;
  @override
  String get username;
  @override
  String get password;
  @override
  String get url;
  @override
  String get category;
  @override
  String get notes;
  @override
  bool get isFavorite;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  List<PasswordHistoryEntry> get passwordHistory;
  @override
  List<CustomField> get customFields;

  /// Create a copy of VaultEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VaultEntryImplCopyWith<_$VaultEntryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
