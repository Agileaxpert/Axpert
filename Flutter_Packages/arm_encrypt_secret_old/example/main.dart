import 'dart:developer';

import 'package:arm_encrypt_secret/arm_encrypt_secret.dart';

void main() {
  const secretKey = '4789815519056380';
  log('--- Axpert AES Encryption Example ---');

  try {
    final encrypted = EncryptDecryptSecretKeys.encryptSecretKey(secretKey);
    print('🔓 Encrypted (Base64): $encrypted');

    final decrypted = EncryptDecryptSecretKeys.decryptSecretKey(
      encrypted,
      secretKey,
    );
    print('🔓 Decrypted timestamp: $decrypted');
  } on AesEncryptionException catch (e) {
    print('! Encryption error: ${e.message}');
  } catch (e) {
    print('! Unexpected error: $e');
  }

  try {
    EncryptDecryptSecretKeys.decryptSecretKey('not_base64_text', secretKey);
  } on AesEncryptionException catch (e) {
    print('⚠️ Expected error (invalid input): ${e.message}');
  } catch (e) {
    print('! Unexpected error: $e');
  }
}
