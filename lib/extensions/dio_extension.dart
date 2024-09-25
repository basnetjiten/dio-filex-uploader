
import 'package:dio/dio.dart';

extension DioExceptionX on DioException {
  String handleException({String? errorMessage}) {
    switch (type) {
      case DioExceptionType.connectionTimeout:
        return errorMessage ?? 'Connection timed out';
      case DioExceptionType.sendTimeout:
        return errorMessage ?? 'Send request timed out';
      case DioExceptionType.receiveTimeout:
        return errorMessage ?? 'Response timed out';
      case DioExceptionType.badResponse:
        return errorMessage ?? 'Received invalid status: ${response?.statusCode}';
      case DioExceptionType.cancel:
        return errorMessage ?? 'Request was cancelled';
      case DioExceptionType.unknown:
      default:
        return errorMessage ?? 'Unknown error occurred';
    }
  }
}
