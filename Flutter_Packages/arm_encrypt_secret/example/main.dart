import 'package:arm_encrypt_secret/arm_encrypt_secret.dart';

void main() async {
  var encryptedKey = await EncryptSecretKeys.encryptSecretKey(
    armUrl: "https://alpha.agilecloud.biz/armmobile/",
    key: "1111111111111111",
  );
  print(encryptedKey);
}
