// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vault_entry_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PasswordHistoryEntryModel _$PasswordHistoryEntryModelFromJson(
  Map<String, dynamic> json,
) {
  return _PasswordHistoryEntryModel.fromJson(json);
}

/// @nodoc
mixin _$PasswordHistoryEntryModel {
  String get password => throw _privateConstructorUsedError;
  String get timestamp => throw _privateConstructorUsedError;

  /// Serializes this PasswordHistoryEntryModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PasswordHistoryEntryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PasswordHistoryEntryModelCopyWith<PasswordHistoryEntryModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PasswordHistoryEntryModelCopyWith<$Res> {
  factory $PasswordHistoryEntryModelCopyWith(
    PasswordHistoryEntryModel value,
    $Res Function(PasswordHistoryEntryModel) then,
  ) = _$PasswordHistoryEntryModelCopyWithImpl<$Res, PasswordHistoryEntryModel>;
  @useResult
  $Res call({String password, String timestamp});
}

/// @nodoc
class _$PasswordHistoryEntryModelCopyWithImpl<
  $Res,
  $Val extends PasswordHistoryEntryModel
>
    implements $PasswordHistoryEntryModelCopyWith<$Res> {
  _$PasswordHistoryEntryModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PasswordHistoryEntryModel
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
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PasswordHistoryEntryModelImplCopyWith<$Res>
    implements $PasswordHistoryEntryModelCopyWith<$Res> {
  factory _$$PasswordHistoryEntryModelImplCopyWith(
    _$PasswordHistoryEntryModelImpl value,
    $Res Function(_$PasswordHistoryEntryModelImpl) then,
  ) = __$$PasswordHistoryEntryModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String password, String timestamp});
}

/// @nodoc
class __$$PasswordHistoryEntryModelImplCopyWithImpl<$Res>
    extends
        _$PasswordHistoryEntryModelCopyWithImpl<
          $Res,
          _$PasswordHistoryEntryModelImpl
        >
    implements _$$PasswordHistoryEntryModelImplCopyWith<$Res> {
  __$$PasswordHistoryEntryModelImplCopyWithImpl(
    _$PasswordHistoryEntryModelImpl _value,
    $Res Function(_$PasswordHistoryEntryModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PasswordHistoryEntryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? password = null, Object? timestamp = null}) {
    return _then(
      _$PasswordHistoryEntryModelImpl(
        password: null == password
            ? _value.password
            : password // ignore: cast_nullable_to_non_nullable
                  as String,
        timestamp: null == timestamp
            ? _value.timestamp
            : timestamp // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PasswordHistoryEntryModelImpl extends _PasswordHistoryEntryModel {
  const _$PasswordHistoryEntryModelImpl({
    required this.password,
    required this.timestamp,
  }) : super._();

  factory _$PasswordHistoryEntryModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PasswordHistoryEntryModelImplFromJson(json);

  @override
  final String password;
  @override
  final String timestamp;

  @override
  String toString() {
    return 'PasswordHistoryEntryModel(password: $password, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PasswordHistoryEntryModelImpl &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, password, timestamp);

  /// Create a copy of PasswordHistoryEntryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PasswordHistoryEntryModelImplCopyWith<_$PasswordHistoryEntryModelImpl>
  get copyWith =>
      __$$PasswordHistoryEntryModelImplCopyWithImpl<
        _$PasswordHistoryEntryModelImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PasswordHistoryEntryModelImplToJson(this);
  }
}

abstract class _PasswordHistoryEntryModel extends PasswordHistoryEntryModel {
  const factory _PasswordHistoryEntryModel({
    required final String password,
    required final String timestamp,
  }) = _$PasswordHistoryEntryModelImpl;
  const _PasswordHistoryEntryModel._() : super._();

  factory _PasswordHistoryEntryModel.fromJson(Map<String, dynamic> json) =
      _$PasswordHistoryEntryModelImpl.fromJson;

  @override
  String get password;
  @override
  String get timestamp;

  /// Create a copy of PasswordHistoryEntryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PasswordHistoryEntryModelImplCopyWith<_$PasswordHistoryEntryModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}

CustomFieldModel _$CustomFieldModelFromJson(Map<String, dynamic> json) {
  return _CustomFieldModel.fromJson(json);
}

/// @nodoc
mixin _$CustomFieldModel {
  String get name => throw _privateConstructorUsedError;
  String get value => throw _privateConstructorUsedError;
  bool get isSecret => throw _privateConstructorUsedError;

  /// Serializes this CustomFieldModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CustomFieldModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CustomFieldModelCopyWith<CustomFieldModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CustomFieldModelCopyWith<$Res> {
  factory $CustomFieldModelCopyWith(
    CustomFieldModel value,
    $Res Function(CustomFieldModel) then,
  ) = _$CustomFieldModelCopyWithImpl<$Res, CustomFieldModel>;
  @useResult
  $Res call({String name, String value, bool isSecret});
}

/// @nodoc
class _$CustomFieldModelCopyWithImpl<$Res, $Val extends CustomFieldModel>
    implements $CustomFieldModelCopyWith<$Res> {
  _$CustomFieldModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CustomFieldModel
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
abstract class _$$CustomFieldModelImplCopyWith<$Res>
    implements $CustomFieldModelCopyWith<$Res> {
  factory _$$CustomFieldModelImplCopyWith(
    _$CustomFieldModelImpl value,
    $Res Function(_$CustomFieldModelImpl) then,
  ) = __$$CustomFieldModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, String value, bool isSecret});
}

/// @nodoc
class __$$CustomFieldModelImplCopyWithImpl<$Res>
    extends _$CustomFieldModelCopyWithImpl<$Res, _$CustomFieldModelImpl>
    implements _$$CustomFieldModelImplCopyWith<$Res> {
  __$$CustomFieldModelImplCopyWithImpl(
    _$CustomFieldModelImpl _value,
    $Res Function(_$CustomFieldModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CustomFieldModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? value = null,
    Object? isSecret = null,
  }) {
    return _then(
      _$CustomFieldModelImpl(
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
@JsonSerializable()
class _$CustomFieldModelImpl extends _CustomFieldModel {
  const _$CustomFieldModelImpl({
    required this.name,
    required this.value,
    this.isSecret = false,
  }) : super._();

  factory _$CustomFieldModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CustomFieldModelImplFromJson(json);

  @override
  final String name;
  @override
  final String value;
  @override
  @JsonKey()
  final bool isSecret;

  @override
  String toString() {
    return 'CustomFieldModel(name: $name, value: $value, isSecret: $isSecret)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CustomFieldModelImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.isSecret, isSecret) ||
                other.isSecret == isSecret));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, value, isSecret);

  /// Create a copy of CustomFieldModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CustomFieldModelImplCopyWith<_$CustomFieldModelImpl> get copyWith =>
      __$$CustomFieldModelImplCopyWithImpl<_$CustomFieldModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CustomFieldModelImplToJson(this);
  }
}

abstract class _CustomFieldModel extends CustomFieldModel {
  const factory _CustomFieldModel({
    required final String name,
    required final String value,
    final bool isSecret,
  }) = _$CustomFieldModelImpl;
  const _CustomFieldModel._() : super._();

  factory _CustomFieldModel.fromJson(Map<String, dynamic> json) =
      _$CustomFieldModelImpl.fromJson;

  @override
  String get name;
  @override
  String get value;
  @override
  bool get isSecret;

  /// Create a copy of CustomFieldModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CustomFieldModelImplCopyWith<_$CustomFieldModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

VaultEntryModel _$VaultEntryModelFromJson(Map<String, dynamic> json) {
  return _VaultEntryModel.fromJson(json);
}

/// @nodoc
mixin _$VaultEntryModel {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get username => throw _privateConstructorUsedError;
  String get password => throw _privateConstructorUsedError;
  String get url => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  String get notes => throw _privateConstructorUsedError;
  bool get isFavorite => throw _privateConstructorUsedError;
  String get createdAt => throw _privateConstructorUsedError; // ISO8601
  String get updatedAt => throw _privateConstructorUsedError; // ISO8601
  List<PasswordHistoryEntryModel> get passwordHistory =>
      throw _privateConstructorUsedError;
  List<CustomFieldModel> get customFields => throw _privateConstructorUsedError;

  /// Serializes this VaultEntryModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VaultEntryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VaultEntryModelCopyWith<VaultEntryModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VaultEntryModelCopyWith<$Res> {
  factory $VaultEntryModelCopyWith(
    VaultEntryModel value,
    $Res Function(VaultEntryModel) then,
  ) = _$VaultEntryModelCopyWithImpl<$Res, VaultEntryModel>;
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
    String createdAt,
    String updatedAt,
    List<PasswordHistoryEntryModel> passwordHistory,
    List<CustomFieldModel> customFields,
  });
}

/// @nodoc
class _$VaultEntryModelCopyWithImpl<$Res, $Val extends VaultEntryModel>
    implements $VaultEntryModelCopyWith<$Res> {
  _$VaultEntryModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VaultEntryModel
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
                      as String,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as String,
            passwordHistory: null == passwordHistory
                ? _value.passwordHistory
                : passwordHistory // ignore: cast_nullable_to_non_nullable
                      as List<PasswordHistoryEntryModel>,
            customFields: null == customFields
                ? _value.customFields
                : customFields // ignore: cast_nullable_to_non_nullable
                      as List<CustomFieldModel>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$VaultEntryModelImplCopyWith<$Res>
    implements $VaultEntryModelCopyWith<$Res> {
  factory _$$VaultEntryModelImplCopyWith(
    _$VaultEntryModelImpl value,
    $Res Function(_$VaultEntryModelImpl) then,
  ) = __$$VaultEntryModelImplCopyWithImpl<$Res>;
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
    String createdAt,
    String updatedAt,
    List<PasswordHistoryEntryModel> passwordHistory,
    List<CustomFieldModel> customFields,
  });
}

/// @nodoc
class __$$VaultEntryModelImplCopyWithImpl<$Res>
    extends _$VaultEntryModelCopyWithImpl<$Res, _$VaultEntryModelImpl>
    implements _$$VaultEntryModelImplCopyWith<$Res> {
  __$$VaultEntryModelImplCopyWithImpl(
    _$VaultEntryModelImpl _value,
    $Res Function(_$VaultEntryModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of VaultEntryModel
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
      _$VaultEntryModelImpl(
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
                  as String,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as String,
        passwordHistory: null == passwordHistory
            ? _value._passwordHistory
            : passwordHistory // ignore: cast_nullable_to_non_nullable
                  as List<PasswordHistoryEntryModel>,
        customFields: null == customFields
            ? _value._customFields
            : customFields // ignore: cast_nullable_to_non_nullable
                  as List<CustomFieldModel>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$VaultEntryModelImpl extends _VaultEntryModel {
  const _$VaultEntryModelImpl({
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
    required final List<PasswordHistoryEntryModel> passwordHistory,
    required final List<CustomFieldModel> customFields,
  }) : _passwordHistory = passwordHistory,
       _customFields = customFields,
       super._();

  factory _$VaultEntryModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$VaultEntryModelImplFromJson(json);

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
  final String createdAt;
  // ISO8601
  @override
  final String updatedAt;
  // ISO8601
  final List<PasswordHistoryEntryModel> _passwordHistory;
  // ISO8601
  @override
  List<PasswordHistoryEntryModel> get passwordHistory {
    if (_passwordHistory is EqualUnmodifiableListView) return _passwordHistory;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_passwordHistory);
  }

  final List<CustomFieldModel> _customFields;
  @override
  List<CustomFieldModel> get customFields {
    if (_customFields is EqualUnmodifiableListView) return _customFields;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_customFields);
  }

  @override
  String toString() {
    return 'VaultEntryModel(id: $id, title: $title, username: $username, password: $password, url: $url, category: $category, notes: $notes, isFavorite: $isFavorite, createdAt: $createdAt, updatedAt: $updatedAt, passwordHistory: $passwordHistory, customFields: $customFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VaultEntryModelImpl &&
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

  @JsonKey(includeFromJson: false, includeToJson: false)
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

  /// Create a copy of VaultEntryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VaultEntryModelImplCopyWith<_$VaultEntryModelImpl> get copyWith =>
      __$$VaultEntryModelImplCopyWithImpl<_$VaultEntryModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$VaultEntryModelImplToJson(this);
  }
}

abstract class _VaultEntryModel extends VaultEntryModel {
  const factory _VaultEntryModel({
    required final String id,
    required final String title,
    required final String username,
    required final String password,
    required final String url,
    required final String category,
    required final String notes,
    required final bool isFavorite,
    required final String createdAt,
    required final String updatedAt,
    required final List<PasswordHistoryEntryModel> passwordHistory,
    required final List<CustomFieldModel> customFields,
  }) = _$VaultEntryModelImpl;
  const _VaultEntryModel._() : super._();

  factory _VaultEntryModel.fromJson(Map<String, dynamic> json) =
      _$VaultEntryModelImpl.fromJson;

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
  String get createdAt; // ISO8601
  @override
  String get updatedAt; // ISO8601
  @override
  List<PasswordHistoryEntryModel> get passwordHistory;
  @override
  List<CustomFieldModel> get customFields;

  /// Create a copy of VaultEntryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VaultEntryModelImplCopyWith<_$VaultEntryModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
