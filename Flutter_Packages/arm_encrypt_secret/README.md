# arm_encrypt_secret 🔐

A lightweight internal Dart package that sends a **16-digit key** to your ARM server and returns the **encrypted value**.
This package is not public and is intended only for specific internal users.

---

## 🧩 Installation

Add this to your app’s `pubspec.yaml`:

```yaml
dependencies:
  arm_encrypt_secret:
    git:
      url: https://github.com/Agileaxpert/Axpert.git
      path: "Flutter_Packages/arm_encrypt_secret"
```

---

Then run:

```bash
flutter pub get
```

---

## 🚀 Usage

```dart
import 'package:arm_encrypt_secret/arm_encrypt_secret.dart';

void main() async {
  try {
    final encrypted = await EncryptSecretKeys.encryptSecretKey(
      armUrl: "https://your-arm-url",   // must NOT end with "/"
      key: "1234567890123456",             // must be 16 characters
    );

    print("Encrypted Key: $encrypted");
  } catch (e) {
    print("Error: $e");
  }
}
```

---

## 🧪 Testing

Run unit tests to verify encryption/decryption consistency and error handling:

```bash
dart test
```
