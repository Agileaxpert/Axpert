import 'dart:convert';
import 'package:test/test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:arm_encrypt_secret/arm_encrypt_secret.dart';

void main() {
  group('EncryptSecretKeys.encryptSecretKey', () {
    test('returns encrypted string when statusCode = 200', () async {
      final mockClient = MockClient((request) async {
        return http.Response(
          'uyDf8YOcL1IugFbJ2SNqOuFvZhYYSElCqWYgeuMtEw==',
          200,
        );
      });

      final result = await EncryptSecretKeys.encryptSecretKey(
        armUrl: "https://example.com/",
        key: "1234567890123456",
        client: mockClient,
      );

      expect(result, 'uyDf8YOcL1IugFbJ2SNqOuFvZhYYSElCqWYgeuMtEw==');
    });

    test('throws message when HTTP 500 JSON error occurs', () async {
      final mockClient = MockClient((request) async {
        return http.Response(
          jsonEncode({
            "result": {
              "statuscode": 500,
              "message":
                  "Specified key is not a valid size for this algorithm.",
            },
            "Result": null,
          }),
          500,
        );
      });

      expect(
        () => EncryptSecretKeys.encryptSecretKey(
          armUrl: "https://example.com/",
          key: "1234567890123456",
          client: mockClient,
        ),
        throwsA(
          predicate(
            (e) => e.toString().contains(
              "Specified key is not a valid size for this algorithm.",
            ),
          ),
        ),
      );
    });

    test('throws error when key length is not 16', () async {
      expect(
        () => EncryptSecretKeys.encryptSecretKey(
          armUrl: "https://example.com/",
          key: "123",
        ),
        throwsA(predicate((e) => e.toString().contains("valid size"))),
      );
    });

    test('throws error when armUrl does not end with slash', () async {
      expect(
        () => EncryptSecretKeys.encryptSecretKey(
          armUrl: "https://example.com",
          key: "1234567890123456",
        ),
        throwsA(predicate((e) => e.toString().contains("ends with"))),
      );
    });

    test('throws network error when post throws exception', () async {
      final mockClient = MockClient((_) async {
        throw Exception("Network Broken");
      });

      expect(
        () => EncryptSecretKeys.encryptSecretKey(
          armUrl: "https://example.com/",
          key: "1234567890123456",
          client: mockClient,
        ),
        throwsA(predicate((e) => e.toString().contains("Network error"))),
      );
    });

    test('throws error when HTTP 500 returns invalid JSON', () async {
      final mockClient = MockClient((_) async {
        return http.Response("THIS_IS_NOT_JSON", 500);
      });

      expect(
        () => EncryptSecretKeys.encryptSecretKey(
          armUrl: "https://example.com/",
          key: "1234567890123456",
          client: mockClient,
        ),
        throwsA(predicate((e) => e.toString().contains("invalid JSON"))),
      );
    });
  });
}
