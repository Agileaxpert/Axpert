import 'dart:developer';

import 'package:arm_encrypt_secret/arm_encrypt_secret.dart';
import 'package:arm_encrypt_secret/src/ax_exceptions.dart';

void main() {
  const secretKey = '1234567890123456';
  log('--- Axpert AES Encryption Example ---');

  try {
    final encrypted = EncryptDecryptSecretKeys.encryptSecretKey(secretKey);
    log('🔓 Encrypted (Base64): $encrypted');

    final decrypted = EncryptDecryptSecretKeys.decryptSecretKey(
      encrypted,
      secretKey,
    );
    log('🔓 Decrypted timestamp: $decrypted');
  } on AesEncryptionException catch (e) {
    log('! Encryption error: ${e.message}');
  } catch (e) {
    log('! Unexpected error: $e');
  }

  try {
    EncryptDecryptSecretKeys.decryptSecretKey('not_base64_text', secretKey);
  } on AesEncryptionException catch (e) {
    log('⚠️ Expected error (invalid input): ${e.message}');
  }
}
