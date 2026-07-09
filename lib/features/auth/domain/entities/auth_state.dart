import 'dart:typed_data';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_state.freezed.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState.uninitialized() = AuthUninitialized;
  
  const factory AuthState.locked({
    required bool biometricEnabled,
    @Default(false) bool hasAttemptedBiometrics,
  }) = AuthLocked;
  
  const factory AuthState.unlocked({
    required Uint8List derivedKey,
  }) = AuthUnlocked;
  
  const factory AuthState.error(String message) = AuthError;
}
