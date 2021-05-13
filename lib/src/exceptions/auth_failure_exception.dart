import '../types/types.dart';

/// 카카오 로그인 예외
class AuthFailureException implements Exception {
  final AuthFailureReason reason;
  final String? message;

  AuthFailureException(this.reason, this.message);

  @override
  String toString() {
    return "AuthFailureException(reason: $reason, message: $message)";
  }
}
