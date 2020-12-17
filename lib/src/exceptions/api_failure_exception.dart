import '../types/types.dart';

/// 카카오 API 호출 예외
class ApiFailureException implements Exception {
  final ApiFailureReason reason;
  final String message;

  ApiFailureException(this.reason, this.message);

  @override
  String toString() {
    return "ApiFailureException(reason: $reason, message: $message)";
  }
}
