library;

import 'dart:convert';
import 'package:http/http.dart' as http;

class EncryptSecretKeys {
  static const String _endpoint = "api/v1/ARMGetEncryptedSecret";

  static Future<String> encryptSecretKey({
    required String armUrl,
    required String key,
    http.Client? client,
  }) async {
    final httpClient = client ?? http.Client();

    final parsedUri = Uri.tryParse(armUrl);

    if (parsedUri == null ||
        !parsedUri.hasScheme ||
        (parsedUri.scheme != "http" && parsedUri.scheme != "https") ||
        parsedUri.host.isEmpty) {
      throw Exception("Specified URL is not valid.");
    }

    if (!armUrl.endsWith("/")) {
      throw Exception("Make sure your ARM URL ends with '/' ");
    }

    if (key.length != 16) {
      throw Exception("Specified key is not a valid size for this algorithm.");
    }

    final url = Uri.parse("$armUrl$_endpoint");

    try {
      final response = await httpClient.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"secretkey": key}),
      );

      if (response.statusCode == 200) {
        return response.body;
      }

      if (response.statusCode == 500) {
        try {
          final json = jsonDecode(response.body);
          final msg =
              json["result"]?["message"] ??
              "Unknown error - check your secretkey length and url";
          throw Exception(msg);
        } catch (e) {
          throw Exception(
            "Server error (500) but invalid JSON: ${response.body}",
          );
        }
      }

      throw Exception(
        "Unexpected status code ${response.statusCode}: ${response.body}",
      );
    } catch (e) {
      throw Exception("Network error: $e");
    } finally {
      if (client == null) {
        httpClient.close();
      }
    }
  }
}
