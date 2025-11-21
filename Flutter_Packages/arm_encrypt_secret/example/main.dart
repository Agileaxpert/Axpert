import 'package:arm_encrypt_secret/arm_encrypt_secret.dart';

void main() async {
  try {
    var encryptedKey = await EncryptSecretKeys.encryptSecretKey(
      armUrl: "your-arm-url",
      key: "your-secret-key",
    );
    print(encryptedKey);
  } catch (e) {
    print("Error $e");
  }
}
