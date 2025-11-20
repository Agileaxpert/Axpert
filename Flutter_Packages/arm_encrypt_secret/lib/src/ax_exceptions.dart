class AesEncryptionException implements Exception {
  final String message;
  final dynamic cause;
  AesEncryptionException(this.message, [this.cause]);
  @override
  String toString() =>
      'AesEncryptionException: $message${cause != null ? " | Cause: $cause" : ""}';
}
