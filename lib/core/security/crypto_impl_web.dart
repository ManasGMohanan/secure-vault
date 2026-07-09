import 'dart:convert';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'dart:typed_data';
import 'crypto_impl_stub.dart';

@JS('crypto.subtle')
external JSObject? get subtleCrypto;

@JS('window.crypto.subtle')
external JSObject? get windowSubtleCrypto;

@JS()
@staticInterop
class SubtleCrypto {}

extension SubtleCryptoExtension on SubtleCrypto {
  external JSPromise importKey(
    JSString format,
    JSAny keyData,
    JSObject algorithm,
    bool extractable,
    JSArray keyUsages,
  );

  external JSPromise deriveBits(
    JSObject algorithm,
    JSObject baseKey,
    JSNumber length,
  );

  external JSPromise encrypt(
    JSObject algorithm,
    JSObject key,
    JSAny data,
  );

  external JSPromise decrypt(
    JSObject algorithm,
    JSObject key,
    JSAny data,
  );
}

class WebCryptoImpl implements CryptoImpl {
  SubtleCrypto get _subtle {
    final subtle = subtleCrypto ?? windowSubtleCrypto;
    if (subtle == null) {
      throw UnsupportedError('Web Crypto Subtle API is not supported in this browser.');
    }
    return subtle as SubtleCrypto;
  }

  @override
  Future<Uint8List> deriveMasterKey({
    required String password,
    required Uint8List salt,
    required int iterations,
  }) async {
    final subtle = _subtle;
    final passwordBytes = utf8.encode(password);

    // 1. Import raw password as key material
    final keyMaterial = await subtle.importKey(
      'raw'.toJS,
      passwordBytes.toJS,
      { 'name': 'PBKDF2' }.jsify() as JSObject,
      false,
      ['deriveBits'].jsify() as JSArray,
    ).toDart as JSObject;

    // 2. Derive master key bits using PBKDF2
    final pbkdf2Params = {
      'name': 'PBKDF2',
      'salt': salt.toJS,
      'iterations': iterations,
      'hash': 'SHA-256',
    }.jsify() as JSObject;

    final masterKeyBuffer = await subtle.deriveBits(
      pbkdf2Params,
      keyMaterial,
      256.toJS, // 256 bits = 32 bytes
    ).toDart as JSObject;

    return _bufferToUint8List(masterKeyBuffer);
  }

  @override
  Future<Uint8List> hkdfExpand({
    required Uint8List masterKey,
    required String info,
    required int length,
  }) async {
    final subtle = _subtle;
    final infoBytes = utf8.encode(info);

    // 1. Import MasterKey bits as HKDF key material
    final hkdfKeyMaterial = await subtle.importKey(
      'raw'.toJS,
      masterKey.toJS,
      { 'name': 'HKDF' }.jsify() as JSObject,
      false,
      ['deriveBits'].jsify() as JSArray,
    ).toDart as JSObject;

    // 2. Expand derived key using HKDF-Expand
    final hkdfParams = {
      'name': 'HKDF',
      'hash': 'SHA-256',
      'salt': Uint8List(0).toJS, // empty salt for HKDF-Expand
      'info': infoBytes.toJS,
    }.jsify() as JSObject;

    final keyBuffer = await subtle.deriveBits(
      hkdfParams,
      hkdfKeyMaterial,
      (length * 8).toJS, // length in bits (e.g. 32 * 8 = 256)
    ).toDart as JSObject;

    return _bufferToUint8List(keyBuffer);
  }

  @override
  Future<Uint8List> aesGcmEncrypt({
    required Uint8List key,
    required Uint8List iv,
    required Uint8List plaintext,
  }) async {
    final subtle = _subtle;

    // 1. Import raw key bytes as AES-GCM CryptoKey
    final aesKey = await subtle.importKey(
      'raw'.toJS,
      key.toJS,
      { 'name': 'AES-GCM' }.jsify() as JSObject,
      false,
      ['encrypt', 'decrypt'].jsify() as JSArray,
    ).toDart as JSObject;

    // 2. Encrypt using AES-GCM
    final encryptParams = {
      'name': 'AES-GCM',
      'iv': iv.toJS,
      'tagLength': 128,
    }.jsify() as JSObject;

    final encryptedBuffer = await subtle.encrypt(
      encryptParams,
      aesKey,
      plaintext.toJS,
    ).toDart as JSObject;

    return _bufferToUint8List(encryptedBuffer);
  }

  @override
  Future<Uint8List> aesGcmDecrypt({
    required Uint8List key,
    required Uint8List iv,
    required Uint8List ciphertextAndTag,
  }) async {
    final subtle = _subtle;

    // 1. Import raw key bytes as AES-GCM CryptoKey
    final aesKey = await subtle.importKey(
      'raw'.toJS,
      key.toJS,
      { 'name': 'AES-GCM' }.jsify() as JSObject,
      false,
      ['encrypt', 'decrypt'].jsify() as JSArray,
    ).toDart as JSObject;

    // 2. Decrypt using AES-GCM
    final decryptParams = {
      'name': 'AES-GCM',
      'iv': iv.toJS,
      'tagLength': 128,
    }.jsify() as JSObject;

    final decryptedBuffer = await subtle.decrypt(
      decryptParams,
      aesKey,
      ciphertextAndTag.toJS,
    ).toDart as JSObject;

    return _bufferToUint8List(decryptedBuffer);
  }

  Uint8List _bufferToUint8List(JSObject buffer) {
    // Wrap ArrayBuffer in a JSUint8Array to convert to Dart Uint8List.
    final uint8ArrayConstructor = globalContext.getProperty('Uint8Array'.toJS) as JSFunction;
    final jsArray = uint8ArrayConstructor.callAsConstructor(buffer) as JSUint8Array;
    return jsArray.toDart;
  }
}

CryptoImpl get cryptoProvider => WebCryptoImpl();
