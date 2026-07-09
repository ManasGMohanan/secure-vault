import 'dart:async';
import 'dart:convert';
import 'dart:isolate';
import 'dart:typed_data';
import 'package:pointycastle/export.dart';
import 'crypto_impl_stub.dart';

class NativeCryptoImpl implements CryptoImpl {
  @override
  Future<Uint8List> deriveMasterKey({
    required String password,
    required Uint8List salt,
    required int iterations,
  }) {
    // Offload CPU-heavy PBKDF2 calculation to a background isolate to keep UI smooth.
    return Isolate.run(() {
      final pkcs = PBKDF2KeyDerivator(HMac(SHA256Digest(), 64))
        ..init(Pbkdf2Parameters(salt, iterations, 32));
      return pkcs.process(Uint8List.fromList(utf8.encode(password)));
    });
  }

  @override
  Future<Uint8List> hkdfExpand({
    required Uint8List masterKey,
    required String info,
    required int length,
  }) async {
    // Standard RFC 5869 HKDF (Extract + Expand) matching SubtleCrypto
    final hkdf = HKDFKeyDerivator(SHA256Digest())
      ..init(HkdfParameters(masterKey, length, Uint8List(0), utf8.encode(info)));
    return hkdf.process(Uint8List(0));
  }

  @override
  Future<Uint8List> aesGcmEncrypt({
    required Uint8List key,
    required Uint8List iv,
    required Uint8List plaintext,
  }) async {
    final cipher = GCMBlockCipher(AESEngine())
      ..init(true, AEADParameters(KeyParameter(key), 128, iv, Uint8List(0)));
    return cipher.process(plaintext);
  }

  @override
  Future<Uint8List> aesGcmDecrypt({
    required Uint8List key,
    required Uint8List iv,
    required Uint8List ciphertextAndTag,
  }) async {
    final cipher = GCMBlockCipher(AESEngine())
      ..init(false, AEADParameters(KeyParameter(key), 128, iv, Uint8List(0)));
    return cipher.process(ciphertextAndTag);
  }
}

CryptoImpl get cryptoProvider => NativeCryptoImpl();
