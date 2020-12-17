import '../extensions/extensions.dart';

/// 카카오 로그인 요청 에러 종류.
enum AuthFailureReason {
  /// 기타 에러
  unknown,

  /// 요청 파라미터 오류
  invalidRequest,

  /// 유효하지 않은 앱
  invalidClient,

  /// 유효하지 않은 scope
  invalidScope,

  /// 인증 수단이 유효하지 않아 인증할 수 없는 상태
  invalidGrant,

  /// 설정이 올바르지 않음. 예) bundle id
  misConfigured,

  /// 앱이 요청 권한이 없음
  unauthorized,

  /// 접근이 거부 됨 (동의 취소)
  accessDenied,

  /// 카카오싱크 전용
  autoLogin,

  /// 서버 내부 에러
  serverError,
}

extension AuthFailureReasonExtension on AuthFailureReason {
  String get rawValue => this.toString().split('.').last.toSnakeCase();

  static AuthFailureReason toReason(String rawValue) {
    if (AuthFailureReason.invalidRequest.rawValue == rawValue) {
      return AuthFailureReason.invalidRequest;
    } else if (AuthFailureReason.invalidClient.rawValue == rawValue) {
      return AuthFailureReason.invalidClient;
    } else if (AuthFailureReason.invalidScope.rawValue == rawValue) {
      return AuthFailureReason.invalidScope;
    } else if (AuthFailureReason.invalidGrant.rawValue == rawValue) {
      return AuthFailureReason.invalidGrant;
    } else if (AuthFailureReason.misConfigured.rawValue == rawValue) {
      return AuthFailureReason.misConfigured;
    } else if (AuthFailureReason.unauthorized.rawValue == rawValue) {
      return AuthFailureReason.unauthorized;
    } else if (AuthFailureReason.accessDenied.rawValue == rawValue) {
      return AuthFailureReason.accessDenied;
    } else if (AuthFailureReason.autoLogin.rawValue == rawValue) {
      return AuthFailureReason.autoLogin;
    } else if (AuthFailureReason.serverError.rawValue == rawValue) {
      return AuthFailureReason.serverError;
    } else {
      return AuthFailureReason.unknown;
    }
  }
}
