import 'dart:convert';
import 'dart:typed_data';
import 'package:arm_encrypt_secret/src/ax_exceptions.dart';
import 'package:pointycastle/export.dart';

class EncryptDecryptSecretKeys {
  static String encryptSecretKey(String secretKey) {
    try {
      if (secretKey.isEmpty || secretKey.length != 16) {
        throw AesEncryptionException(
          'Invalid key: must be 16 characters (128-bit AES key)',
        );
      }

      final now = DateTime.now();
      final currentTime =
          '${now.year.toString().padLeft(4, '0')}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}${now.second.toString().padLeft(2, '0')}';
      return _encryptString(currentTime, secretKey);
    } catch (e) {
      throw AesEncryptionException('Failed to encrypt secret key', e);
    }
  }

  static String decryptSecretKey(String encryptedText, String secretKey) {
    try {
      if (encryptedText.isEmpty) {
        throw AesEncryptionException('Encrypted text is empty');
      }
      if (secretKey.isEmpty || secretKey.length != 16) {
        throw AesEncryptionException(
          'Invalid key: must be 16 characters (128-bit AES key)',
        );
      }

      return _decryptString(encryptedText, secretKey);
    } catch (e) {
      throw AesEncryptionException('Failed to decrypt secret key', e);
    }
  }

  static String _encryptString(String plainText, String key) {
    final keyBytes = Uint8List.fromList(utf8.encode(key));
    final iv = _generateIV(16);

    final cfb = CFBBlockCipher(AESEngine(), 1);
    final params = ParametersWithIV(KeyParameter(keyBytes), iv);
    cfb.init(true, params);

    final input = Uint8List.fromList(utf8.encode(plainText));
    final output = Uint8List(input.length);
    for (int i = 0; i < input.length; i++) {
      final singleIn = Uint8List.fromList([input[i]]);
      final singleOut = Uint8List(1);
      cfb.processBlock(singleIn, 0, singleOut, 0);
      output[i] = singleOut[0];
    }

    final combined = Uint8List.fromList(iv + output);
    return base64Encode(combined);
  }

  static String _decryptString(String cipherText, String key) {
    final combined = base64Decode(cipherText);
    if (combined.length < 17) {
      throw AesEncryptionException('Ciphertext too short or invalid format');
    }

    final iv = combined.sublist(0, 16);
    final encryptedBytes = combined.sublist(16);
    final keyBytes = Uint8List.fromList(utf8.encode(key));

    final cfb = CFBBlockCipher(AESEngine(), 1);
    final params = ParametersWithIV(KeyParameter(keyBytes), iv);
    cfb.init(false, params);

    final output = Uint8List(encryptedBytes.length);
    for (int i = 0; i < encryptedBytes.length; i++) {
      final singleIn = Uint8List.fromList([encryptedBytes[i]]);
      final singleOut = Uint8List(1);
      cfb.processBlock(singleIn, 0, singleOut, 0);
      output[i] = singleOut[0];
    }
    return utf8.decode(output);
  }

  static Uint8List _generateIV(int length) {
    final rnd = SecureRandom('Fortuna')..seed(
      KeyParameter(
        Uint8List.fromList(
          List<int>.generate(32, (i) => DateTime.now().microsecond % 256),
        ),
      ),
    );
    return rnd.nextBytes(length);
  }
}
