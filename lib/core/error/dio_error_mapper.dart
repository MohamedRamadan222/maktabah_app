import 'package:dio/dio.dart';

import 'failure.dart';

AppFailure mapDioError(DioException e) {
  final data = e.response?.data;
  if (data is Map<String, dynamic> && data['error'] is Map<String, dynamic>) {
    final error = data['error'] as Map<String, dynamic>;
    return AppFailure(
      message: error['message'] as String,
      code: error['code'] as String?,
      statusCode: e.response?.statusCode,
    );
  }
  if (e.type == DioExceptionType.connectionTimeout ||
      e.type == DioExceptionType.receiveTimeout) {
    return const AppFailure(message: 'انتهت مهلة الاتصال');
  }

  return const AppFailure(message: 'تعذّر الاتصال بالخادم');
}
