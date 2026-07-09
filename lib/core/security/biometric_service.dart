import 'package:local_auth/local_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'biometric_service.g.dart';

class BiometricService {
  final LocalAuthentication _auth;

  BiometricService(this._auth);

  /// Check if biometrics are supported and enrolled on the device.
  Future<bool> canAuthenticate() async {
    final isSupported = await _auth.isDeviceSupported();
    if (!isSupported) return false;
    final canCheck = await _auth.canCheckBiometrics;
    if (!canCheck) return false;
    
    final enrolledBiometrics = await _auth.getAvailableBiometrics();
    return enrolledBiometrics.isNotEmpty;
  }

  /// Perform biometric authentication.
  Future<bool> authenticate(String reason) async {
    try {
      return await _auth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          stickyAuth: false,
          biometricOnly: true,
        ),
      );
    } catch (_) {
      return false;
    }
  }
}

@riverpod
BiometricService biometricService(BiometricServiceRef ref) {
  return BiometricService(LocalAuthentication());
}
