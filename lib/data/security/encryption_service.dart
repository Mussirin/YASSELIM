import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';

/// Provides authenticated symmetric encryption at rest for local JSON payloads
/// and salted SHA-256 hashing for the 4-digit PIN lock.
class EncryptionService {
  static const String _defaultKeyPhrase =
      'yasselim_local_vault_key_2026_private_offline_v1';
  static const String _pinSalt = 'yasselim_pin_salt_2026_v1';

  final List<int> _secretKeyBytes;
  final Random _random;

  EncryptionService({String? secretKey, Random? random})
    : _secretKeyBytes = sha256
          .convert(utf8.encode(secretKey ?? _defaultKeyPhrase))
          .bytes,
      _random = random ?? _createSecureOrFallbackRandom();

  static Random _createSecureOrFallbackRandom() {
    try {
      return Random.secure();
    } catch (_) {
      return Random();
    }
  }

  /// Encrypts [plainText] using a 16-byte random IV, SHA-256 counter-mode
  /// keystream, and HMAC-SHA256 authentication tag.
  /// Format: `v1:<base64Url(iv)>:<base64Url(cipher)>:<base64Url(mac)>`
  String encryptPayload(String plainText) {
    final iv = List<int>.generate(16, (_) => _random.nextInt(256));
    final plainBytes = utf8.encode(plainText);
    final cipherBytes = _xorWithKeystream(plainBytes, iv);
    final mac = _computeMac(iv, cipherBytes);

    return 'v1:${base64Url.encode(iv)}:'
        '${base64Url.encode(cipherBytes)}:'
        '${base64Url.encode(mac)}';
  }

  /// Verifies the `v1:` prefix and HMAC tag, then decrypts [stored] back into
  /// the original UTF-8 string. Returns `null` if tampered or malformed.
  String? decryptPayload(String stored) {
    if (!stored.startsWith('v1:')) return null;
    final parts = stored.split(':');
    if (parts.length != 4) return null;

    try {
      final iv = base64Url.decode(parts[1]);
      final cipherBytes = base64Url.decode(parts[2]);
      final expectedMac = base64Url.decode(parts[3]);
      if (iv.length != 16) return null;

      final actualMac = _computeMac(iv, cipherBytes);
      if (!_constantTimeEquals(actualMac, expectedMac)) return null;

      final plainBytes = _xorWithKeystream(cipherBytes, iv);
      return utf8.decode(plainBytes);
    } catch (_) {
      return null;
    }
  }

  /// Returns a salted SHA-256 hex digest of a 4-digit [pin].
  String hashPin(String pin) {
    final bytes = utf8.encode('$_pinSalt:$pin');
    return sha256.convert(bytes).toString();
  }

  List<int> _xorWithKeystream(List<int> input, List<int> iv) {
    final output = List<int>.filled(input.length, 0);
    var blockIndex = 0;
    var offset = 0;

    while (offset < input.length) {
      final blockBytes = sha256.convert([
        ..._secretKeyBytes,
        ...iv,
        (blockIndex >> 24) & 0xFF,
        (blockIndex >> 16) & 0xFF,
        (blockIndex >> 8) & 0xFF,
        blockIndex & 0xFF,
      ]).bytes;

      final chunkLength = min(32, input.length - offset);
      for (var i = 0; i < chunkLength; i++) {
        output[offset + i] = input[offset + i] ^ blockBytes[i];
      }
      offset += chunkLength;
      blockIndex++;
    }
    return output;
  }

  List<int> _computeMac(List<int> iv, List<int> cipherBytes) {
    final hmac = Hmac(sha256, _secretKeyBytes);
    return hmac.convert([...iv, ...cipherBytes]).bytes;
  }

  bool _constantTimeEquals(List<int> a, List<int> b) {
    if (a.length != b.length) return false;
    var diff = 0;
    for (var i = 0; i < a.length; i++) {
      diff |= a[i] ^ b[i];
    }
    return diff == 0;
  }
}
