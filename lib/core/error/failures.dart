import 'package:freezed_annotation/freezed_annotation.dart';

part 'failures.freezed.dart';

@freezed
class Failure with _$Failure implements Exception {
  const Failure._();

  const factory Failure.invalidPassword() = _InvalidPassword;
  const factory Failure.biometricFailed() = _BiometricFailed;
  const factory Failure.biometricNotAvailable() = _BiometricNotAvailable;
  const factory Failure.storageError(String message) = _StorageError;
  const factory Failure.databaseError(String message) = _DatabaseError;
  const factory Failure.unknown(String message) = _Unknown;

  @override
  String toString() {
    return when(
      invalidPassword: () => 'Invalid master password.',
      biometricFailed: () => 'Biometric authentication failed.',
      biometricNotAvailable: () => 'Biometric authentication is not available or not enrolled.',
      storageError: (msg) => 'Secure storage error: $msg',
      databaseError: (msg) => 'Database error: $msg',
      unknown: (msg) => 'An unknown error occurred: $msg',
    );
  }
}
