class AppFailure implements Exception {
  final String message;
  final String? code;
  final int? statusCode;

  const AppFailure({required this.message, this.code, this.statusCode});

  @override
  String toString() => message;
}
