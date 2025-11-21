import 'dart:convert';
import 'dart:typed_data';
import 'package:pointycastle/export.dart';

class EncryptDecryptSecretKeys {
  static String encryptSecretKey(String secretKey) {
    final now = DateTime.now();
    final currentTime =
        '${now.year.toString().padLeft(4, '0')}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}${now.second.toString().padLeft(2, '0')}';
    return _encryptString(currentTime, secretKey);
  }

  static String decryptSecretKey(String encryptedText, String secretKey) {
    return _decryptString(encryptedText, secretKey);
  }

  static String _encryptString(String plainText, String key) {
    final keyBytes = Uint8List.fromList(utf8.encode(key));
    final iv = _generateIV(16);
    final cfb = CFBBlockCipher(AESEngine(), 1);
    final params = ParametersWithIV(KeyParameter(keyBytes), iv);
    cfb.init(true, params);
    final input = Uint8List.fromList(utf8.encode(plainText));
    final paddedInput = _pkcs7Pad(input, 16);

    final output = Uint8List(paddedInput.length);
    for (int i = 0; i < paddedInput.length; i++) {
      final singleIn = Uint8List.fromList([paddedInput[i]]);
      final singleOut = Uint8List(1);
      cfb.processBlock(singleIn, 0, singleOut, 0);
      output[i] = singleOut[0];
    }
    final combined = Uint8List.fromList(iv + output);
    return base64Encode(combined);
  }

  static String _decryptString(String cipherText, String key) {
    final combined = base64Decode(cipherText);
    final iv = combined.sublist(0, 16);
    final encryptedBytes = combined.sublist(16);
    final keyBytes = Uint8List.fromList(utf8.encode(key));
    final cfb = CFBBlockCipher(AESEngine(), 1);
    final params = ParametersWithIV(KeyParameter(keyBytes), iv);
    cfb.init(false, params);
    // final encryptedBytes = combined.sublist(16);
    final output = Uint8List(encryptedBytes.length);
    for (int i = 0; i < encryptedBytes.length; i++) {
      final singleIn = Uint8List.fromList([encryptedBytes[i]]);
      final singleOut = Uint8List(1);
      cfb.processBlock(singleIn, 0, singleOut, 0);
      output[i] = singleOut[0];
    }
    // remove PKCS7 padding
    final unpadded = _pkcs7Unpad(output);
    return utf8.decode(unpadded);
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

  static Uint8List _pkcs7Pad(Uint8List data, int blockSize) {
    final padLen = blockSize - (data.length % blockSize);
    final padded = Uint8List(data.length + padLen)..setAll(0, data);
    for (int i = data.length; i < padded.length; i++) {
      padded[i] = padLen;
    }
    return padded;
  }

  static Uint8List _pkcs7Unpad(Uint8List data) {
    if (data.isEmpty) return data;
    final padLen = data.last;
    if (padLen <= 0 || padLen > 16) return data; // basic safety
    return data.sublist(0, data.length - padLen);
  }
}
