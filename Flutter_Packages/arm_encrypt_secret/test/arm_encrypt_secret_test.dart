import 'dart:developer';

import 'package:arm_encrypt_secret/arm_encrypt_secret.dart';
import 'package:arm_encrypt_secret/src/ax_exceptions.dart';
import 'package:test/test.dart';

void main() {
  const testKey = '1234567890123456';

  group('EncryptDecryptSecretKeys Tests', () {
    test('\n1️⃣ Encrypt and decrypt should round-trip correctly', () {
      final encrypted = EncryptDecryptSecretKeys.encryptSecretKey(testKey);
      final decrypted = EncryptDecryptSecretKeys.decryptSecretKey(
        encrypted,
        testKey,
      );

      expect(decrypted.length, 14, reason: 'Timestamp should be 14 chars long');
      log('✅ Test 1 passed: Round-trip encryption/decryption successful.');
      log('   Encrypted sample: $encrypted');
      log('   Decrypted output: $decrypted');
    });

    test('\n2️⃣ Decrypt should fail with wrong key', () {
      final encrypted = EncryptDecryptSecretKeys.encryptSecretKey(testKey);

      expect(
        () => EncryptDecryptSecretKeys.decryptSecretKey(
          encrypted,
          'wrongpassword!!',
        ),
        throwsA(isA<AesEncryptionException>()),
      );
      log('✅ Test 2 passed: Wrong key correctly triggered exception.');
    });

    test('\n3️⃣ Encrypt should throw error for empty key', () {
      expect(
        () => EncryptDecryptSecretKeys.encryptSecretKey(''),
        throwsA(isA<AesEncryptionException>()),
      );
      log('✅ Test 3 passed: Empty key correctly rejected.');
    });

    test('\n4️⃣ Decrypt should throw error for malformed Base64 input', () {
      expect(
        () => EncryptDecryptSecretKeys.decryptSecretKey(
          'not_base64_text',
          testKey,
        ),
        throwsA(isA<AesEncryptionException>()),
      );
      log('✅ Test 4 passed: Malformed Base64 input correctly rejected.');
    });
  });
}
