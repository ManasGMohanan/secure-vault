// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$AuthState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() uninitialized,
    required TResult Function(
      bool biometricEnabled,
      bool hasAttemptedBiometrics,
    )
    locked,
    required TResult Function(Uint8List derivedKey) unlocked,
    required TResult Function(String message) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? uninitialized,
    TResult? Function(bool biometricEnabled, bool hasAttemptedBiometrics)?
    locked,
    TResult? Function(Uint8List derivedKey)? unlocked,
    TResult? Function(String message)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? uninitialized,
    TResult Function(bool biometricEnabled, bool hasAttemptedBiometrics)?
    locked,
    TResult Function(Uint8List derivedKey)? unlocked,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthUninitialized value) uninitialized,
    required TResult Function(AuthLocked value) locked,
    required TResult Function(AuthUnlocked value) unlocked,
    required TResult Function(AuthError value) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthUninitialized value)? uninitialized,
    TResult? Function(AuthLocked value)? locked,
    TResult? Function(AuthUnlocked value)? unlocked,
    TResult? Function(AuthError value)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthUninitialized value)? uninitialized,
    TResult Function(AuthLocked value)? locked,
    TResult Function(AuthUnlocked value)? unlocked,
    TResult Function(AuthError value)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthStateCopyWith<$Res> {
  factory $AuthStateCopyWith(AuthState value, $Res Function(AuthState) then) =
      _$AuthStateCopyWithImpl<$Res, AuthState>;
}

/// @nodoc
class _$AuthStateCopyWithImpl<$Res, $Val extends AuthState>
    implements $AuthStateCopyWith<$Res> {
  _$AuthStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$AuthUninitializedImplCopyWith<$Res> {
  factory _$$AuthUninitializedImplCopyWith(
    _$AuthUninitializedImpl value,
    $Res Function(_$AuthUninitializedImpl) then,
  ) = __$$AuthUninitializedImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$AuthUninitializedImplCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$AuthUninitializedImpl>
    implements _$$AuthUninitializedImplCopyWith<$Res> {
  __$$AuthUninitializedImplCopyWithImpl(
    _$AuthUninitializedImpl _value,
    $Res Function(_$AuthUninitializedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$AuthUninitializedImpl implements AuthUninitialized {
  const _$AuthUninitializedImpl();

  @override
  String toString() {
    return 'AuthState.uninitialized()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$AuthUninitializedImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() uninitialized,
    required TResult Function(
      bool biometricEnabled,
      bool hasAttemptedBiometrics,
    )
    locked,
    required TResult Function(Uint8List derivedKey) unlocked,
    required TResult Function(String message) error,
  }) {
    return uninitialized();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? uninitialized,
    TResult? Function(bool biometricEnabled, bool hasAttemptedBiometrics)?
    locked,
    TResult? Function(Uint8List derivedKey)? unlocked,
    TResult? Function(String message)? error,
  }) {
    return uninitialized?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? uninitialized,
    TResult Function(bool biometricEnabled, bool hasAttemptedBiometrics)?
    locked,
    TResult Function(Uint8List derivedKey)? unlocked,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (uninitialized != null) {
      return uninitialized();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthUninitialized value) uninitialized,
    required TResult Function(AuthLocked value) locked,
    required TResult Function(AuthUnlocked value) unlocked,
    required TResult Function(AuthError value) error,
  }) {
    return uninitialized(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthUninitialized value)? uninitialized,
    TResult? Function(AuthLocked value)? locked,
    TResult? Function(AuthUnlocked value)? unlocked,
    TResult? Function(AuthError value)? error,
  }) {
    return uninitialized?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthUninitialized value)? uninitialized,
    TResult Function(AuthLocked value)? locked,
    TResult Function(AuthUnlocked value)? unlocked,
    TResult Function(AuthError value)? error,
    required TResult orElse(),
  }) {
    if (uninitialized != null) {
      return uninitialized(this);
    }
    return orElse();
  }
}

abstract class AuthUninitialized implements AuthState {
  const factory AuthUninitialized() = _$AuthUninitializedImpl;
}

/// @nodoc
abstract class _$$AuthLockedImplCopyWith<$Res> {
  factory _$$AuthLockedImplCopyWith(
    _$AuthLockedImpl value,
    $Res Function(_$AuthLockedImpl) then,
  ) = __$$AuthLockedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({bool biometricEnabled, bool hasAttemptedBiometrics});
}

/// @nodoc
class __$$AuthLockedImplCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$AuthLockedImpl>
    implements _$$AuthLockedImplCopyWith<$Res> {
  __$$AuthLockedImplCopyWithImpl(
    _$AuthLockedImpl _value,
    $Res Function(_$AuthLockedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? biometricEnabled = null,
    Object? hasAttemptedBiometrics = null,
  }) {
    return _then(
      _$AuthLockedImpl(
        biometricEnabled: null == biometricEnabled
            ? _value.biometricEnabled
            : biometricEnabled // ignore: cast_nullable_to_non_nullable
                  as bool,
        hasAttemptedBiometrics: null == hasAttemptedBiometrics
            ? _value.hasAttemptedBiometrics
            : hasAttemptedBiometrics // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$AuthLockedImpl implements AuthLocked {
  const _$AuthLockedImpl({
    required this.biometricEnabled,
    this.hasAttemptedBiometrics = false,
  });

  @override
  final bool biometricEnabled;
  @override
  @JsonKey()
  final bool hasAttemptedBiometrics;

  @override
  String toString() {
    return 'AuthState.locked(biometricEnabled: $biometricEnabled, hasAttemptedBiometrics: $hasAttemptedBiometrics)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthLockedImpl &&
            (identical(other.biometricEnabled, biometricEnabled) ||
                other.biometricEnabled == biometricEnabled) &&
            (identical(other.hasAttemptedBiometrics, hasAttemptedBiometrics) ||
                other.hasAttemptedBiometrics == hasAttemptedBiometrics));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, biometricEnabled, hasAttemptedBiometrics);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthLockedImplCopyWith<_$AuthLockedImpl> get copyWith =>
      __$$AuthLockedImplCopyWithImpl<_$AuthLockedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() uninitialized,
    required TResult Function(
      bool biometricEnabled,
      bool hasAttemptedBiometrics,
    )
    locked,
    required TResult Function(Uint8List derivedKey) unlocked,
    required TResult Function(String message) error,
  }) {
    return locked(biometricEnabled, hasAttemptedBiometrics);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? uninitialized,
    TResult? Function(bool biometricEnabled, bool hasAttemptedBiometrics)?
    locked,
    TResult? Function(Uint8List derivedKey)? unlocked,
    TResult? Function(String message)? error,
  }) {
    return locked?.call(biometricEnabled, hasAttemptedBiometrics);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? uninitialized,
    TResult Function(bool biometricEnabled, bool hasAttemptedBiometrics)?
    locked,
    TResult Function(Uint8List derivedKey)? unlocked,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (locked != null) {
      return locked(biometricEnabled, hasAttemptedBiometrics);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthUninitialized value) uninitialized,
    required TResult Function(AuthLocked value) locked,
    required TResult Function(AuthUnlocked value) unlocked,
    required TResult Function(AuthError value) error,
  }) {
    return locked(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthUninitialized value)? uninitialized,
    TResult? Function(AuthLocked value)? locked,
    TResult? Function(AuthUnlocked value)? unlocked,
    TResult? Function(AuthError value)? error,
  }) {
    return locked?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthUninitialized value)? uninitialized,
    TResult Function(AuthLocked value)? locked,
    TResult Function(AuthUnlocked value)? unlocked,
    TResult Function(AuthError value)? error,
    required TResult orElse(),
  }) {
    if (locked != null) {
      return locked(this);
    }
    return orElse();
  }
}

abstract class AuthLocked implements AuthState {
  const factory AuthLocked({
    required final bool biometricEnabled,
    final bool hasAttemptedBiometrics,
  }) = _$AuthLockedImpl;

  bool get biometricEnabled;
  bool get hasAttemptedBiometrics;

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthLockedImplCopyWith<_$AuthLockedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AuthUnlockedImplCopyWith<$Res> {
  factory _$$AuthUnlockedImplCopyWith(
    _$AuthUnlockedImpl value,
    $Res Function(_$AuthUnlockedImpl) then,
  ) = __$$AuthUnlockedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({Uint8List derivedKey});
}

/// @nodoc
class __$$AuthUnlockedImplCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$AuthUnlockedImpl>
    implements _$$AuthUnlockedImplCopyWith<$Res> {
  __$$AuthUnlockedImplCopyWithImpl(
    _$AuthUnlockedImpl _value,
    $Res Function(_$AuthUnlockedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? derivedKey = null}) {
    return _then(
      _$AuthUnlockedImpl(
        derivedKey: null == derivedKey
            ? _value.derivedKey
            : derivedKey // ignore: cast_nullable_to_non_nullable
                  as Uint8List,
      ),
    );
  }
}

/// @nodoc

class _$AuthUnlockedImpl implements AuthUnlocked {
  const _$AuthUnlockedImpl({required this.derivedKey});

  @override
  final Uint8List derivedKey;

  @override
  String toString() {
    return 'AuthState.unlocked(derivedKey: $derivedKey)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthUnlockedImpl &&
            const DeepCollectionEquality().equals(
              other.derivedKey,
              derivedKey,
            ));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(derivedKey));

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthUnlockedImplCopyWith<_$AuthUnlockedImpl> get copyWith =>
      __$$AuthUnlockedImplCopyWithImpl<_$AuthUnlockedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() uninitialized,
    required TResult Function(
      bool biometricEnabled,
      bool hasAttemptedBiometrics,
    )
    locked,
    required TResult Function(Uint8List derivedKey) unlocked,
    required TResult Function(String message) error,
  }) {
    return unlocked(derivedKey);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? uninitialized,
    TResult? Function(bool biometricEnabled, bool hasAttemptedBiometrics)?
    locked,
    TResult? Function(Uint8List derivedKey)? unlocked,
    TResult? Function(String message)? error,
  }) {
    return unlocked?.call(derivedKey);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? uninitialized,
    TResult Function(bool biometricEnabled, bool hasAttemptedBiometrics)?
    locked,
    TResult Function(Uint8List derivedKey)? unlocked,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (unlocked != null) {
      return unlocked(derivedKey);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthUninitialized value) uninitialized,
    required TResult Function(AuthLocked value) locked,
    required TResult Function(AuthUnlocked value) unlocked,
    required TResult Function(AuthError value) error,
  }) {
    return unlocked(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthUninitialized value)? uninitialized,
    TResult? Function(AuthLocked value)? locked,
    TResult? Function(AuthUnlocked value)? unlocked,
    TResult? Function(AuthError value)? error,
  }) {
    return unlocked?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthUninitialized value)? uninitialized,
    TResult Function(AuthLocked value)? locked,
    TResult Function(AuthUnlocked value)? unlocked,
    TResult Function(AuthError value)? error,
    required TResult orElse(),
  }) {
    if (unlocked != null) {
      return unlocked(this);
    }
    return orElse();
  }
}

abstract class AuthUnlocked implements AuthState {
  const factory AuthUnlocked({required final Uint8List derivedKey}) =
      _$AuthUnlockedImpl;

  Uint8List get derivedKey;

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthUnlockedImplCopyWith<_$AuthUnlockedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AuthErrorImplCopyWith<$Res> {
  factory _$$AuthErrorImplCopyWith(
    _$AuthErrorImpl value,
    $Res Function(_$AuthErrorImpl) then,
  ) = __$$AuthErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$AuthErrorImplCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$AuthErrorImpl>
    implements _$$AuthErrorImplCopyWith<$Res> {
  __$$AuthErrorImplCopyWithImpl(
    _$AuthErrorImpl _value,
    $Res Function(_$AuthErrorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$AuthErrorImpl(
        null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$AuthErrorImpl implements AuthError {
  const _$AuthErrorImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'AuthState.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthErrorImplCopyWith<_$AuthErrorImpl> get copyWith =>
      __$$AuthErrorImplCopyWithImpl<_$AuthErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() uninitialized,
    required TResult Function(
      bool biometricEnabled,
      bool hasAttemptedBiometrics,
    )
    locked,
    required TResult Function(Uint8List derivedKey) unlocked,
    required TResult Function(String message) error,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? uninitialized,
    TResult? Function(bool biometricEnabled, bool hasAttemptedBiometrics)?
    locked,
    TResult? Function(Uint8List derivedKey)? unlocked,
    TResult? Function(String message)? error,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? uninitialized,
    TResult Function(bool biometricEnabled, bool hasAttemptedBiometrics)?
    locked,
    TResult Function(Uint8List derivedKey)? unlocked,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthUninitialized value) uninitialized,
    required TResult Function(AuthLocked value) locked,
    required TResult Function(AuthUnlocked value) unlocked,
    required TResult Function(AuthError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthUninitialized value)? uninitialized,
    TResult? Function(AuthLocked value)? locked,
    TResult? Function(AuthUnlocked value)? unlocked,
    TResult? Function(AuthError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthUninitialized value)? uninitialized,
    TResult Function(AuthLocked value)? locked,
    TResult Function(AuthUnlocked value)? unlocked,
    TResult Function(AuthError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class AuthError implements AuthState {
  const factory AuthError(final String message) = _$AuthErrorImpl;

  String get message;

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthErrorImplCopyWith<_$AuthErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
