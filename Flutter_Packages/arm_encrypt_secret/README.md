# arm_encrypt_secret 🔐

A lightweight Dart package for **AES/CFB8 encryption and decryption**
Ideal for encrypting timestamps, tokens, or short secret keys between **Flutter apps** and **.NET backends**.

---

## ✨ Features

- AES encryption using **CFB8 mode (8-bit feedback)**
- **IV prepended** to ciphertext for C# compatibility
- No padding required (stream cipher behavior)
- Unit-tested for correctness and failure handling

---

## 🧩 Installation

Add this to your app’s `pubspec.yaml`:

```yaml
dependencies:
  arm_encrypt_secret:
    git:
      url: https://github.com/Agileaxpert/Axpert.git
      path: "Axpert Samples/Flutter_Packages/arm_encrypt_secret"
```

# ⚠️ Important: Always wrap the path in quotes since it contains spaces and dots.

> Or use a local path if it’s part of your monorepo:
>
> ```yaml
> dependencies:
>   arm_encrypt_secret:
>     path: ../repo_root/dart_utils/arm_encrypt_secret
> ```

Then run:

```bash
flutter pub get
```

---

## 🚀 Usage

```dart
import 'package:arm_encrypt_secret/arm_encrypt_secret.dart';

void main() {
  const secretKey = '1234567890123456'; // 16-char AES key
  print('--- ARM Encrypt Secret Example ---');

  try {
    // Encrypt the current UTC timestamp
    final encrypted = EncryptDecryptSecretKeys.encryptSecretKey(secretKey);
    print('🔒 Encrypted (Base64): $encrypted');

    // Decrypt back to timestamp string
    final decrypted = EncryptDecryptSecretKeys.decryptSecretKey(encrypted, secretKey);
    print('🔓 Decrypted timestamp: $decrypted');
  } on AesEncryptionException catch (e) {
    print('❌ Encryption error: ${e.message}');
  }

  // Example of invalid input handling
  try {
    EncryptDecryptSecretKeys.decryptSecretKey('not_base64_text', secretKey);
  } on AesEncryptionException catch (e) {
    print('⚠️ Expected error: ${e.message}');
  }
}
```

---

## ⚙️ API Overview

### `EncryptDecryptSecretKeys.encryptSecretKey(String secretKey)`

Encrypts using the provided 16-character AES key.  
Returns a Base64-encoded string with the IV prepended.

### `EncryptDecryptSecretKeys.decryptSecretKey(String encryptedText, String secretKey)`

Decrypts a Base64 ciphertext back into original.  
Throws `AesEncryptionException` if decryption fails (wrong key, bad Base64, etc).

### `AesEncryptionException`

A custom exception for predictable error handling:

```dart
try {
  ...
} on AesEncryptionException catch (e) {
  print(e.message);
}
```

---

## 🧪 Testing

Run unit tests to verify encryption/decryption consistency and error handling:

```bash
dart test
```

Example output:

```
✅ Test 1 passed: Round-trip encryption/decryption successful.
✅ Test 2 passed: Wrong key correctly triggered exception.
✅ Test 3 passed: Empty key correctly rejected.
✅ Test 4 passed: Malformed Base64 input correctly rejected.
+4: All tests passed!
```

---

## 📂 Example Project

A ready-to-run example is included at [`example/main.dart`](example/main.dart):

Run it using:

```bash
dart run example/main.dart
```

Expected output:

```
--- ARM Encrypt Secret Example ---
🔒 Encrypted (Base64): XzvB5oKj7G0b2m...
🔓 Decrypted timestamp: 20251106193022
⚠️ Expected error: Failed to decrypt secret key | Cause: FormatException: Invalid Base64 input
```

---

## 🧠 Notes

- The AES key **must be exactly 16 characters** (128-bit).
- Each encryption generates a unique 16-byte IV.
- The IV is automatically prepended to the ciphertext before Base64 encoding.
- The output format is compatible with **C# AES/CFB8** decryptors.

---

### 💬 Feedback

If you encounter any issue or want to contribute improvements,  
create a pull request or open an issue in your team’s repository.
