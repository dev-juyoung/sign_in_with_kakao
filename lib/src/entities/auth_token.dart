/// 카카오 로그인을 통해 발급 받은 토큰 정보입니다.
/// 이 토큰을 이용하여 로그인 기반 API를 호출할 수 있습니다.
class AuthToken {
  /// 토큰 타입. 현재는 "Bearer" 타입만 사용됩니다.
  final String tokenType;

  /// 액세스 토큰
  final String accessToken;

  /// 액세스 토큰의 남은 만료시간 (단위: 초)
  ///
  /// 해당 프로퍼티는 iOS 플랫폼에서만 지원합니다.
  final int? expiresIn;

  /// 액세스 토큰의 만료 시각
  final DateTime expiredAt;

  /// 리프레시 토큰
  final String refreshToken;

  /// 리프레시 토큰의 남은 만료시간 (단위: 초)
  ///
  /// 해당 프로퍼티는 iOS 플랫폼에서만 지원합니다.
  final int? refreshTokenExpiresIn;

  /// 리프레시 토큰의 만료 시각
  final DateTime refreshTokenExpiredAt;

  /// 현재까지 사용자로부터 획득에 성공한 scope 정보 (공백으로 구분됨)
  ///
  /// 해당 프로퍼티는 iOS 플랫폼에서만 지원합니다.
  final String? scope;

  /// 현재까지 사용자로부터 획득에 성공한 scope 목록
  final List<String>? scopes;

  AuthToken._({
    required this.tokenType,
    required this.accessToken,
    this.expiresIn,
    required this.expiredAt,
    required this.refreshToken,
    this.refreshTokenExpiresIn,
    required this.refreshTokenExpiredAt,
    this.scope,
    this.scopes,
  });

  factory AuthToken.fromJson(Map<String, dynamic> json) {
    return AuthToken._(
      tokenType: json['tokenType'],
      accessToken: json['accessToken'],
      expiresIn: json['expiresIn'],
      expiredAt: DateTime.fromMillisecondsSinceEpoch(json['expiredAt']),
      refreshToken: json['refreshToken'],
      refreshTokenExpiresIn: json['refreshTokenExpiresIn'],
      refreshTokenExpiredAt:
          DateTime.fromMillisecondsSinceEpoch(json['refreshTokenExpiredAt']),
      scope: json['scope'],
      scopes: json['scopes']?.cast<String>(),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'tokenType': tokenType,
      'accessToken': accessToken,
      'expiresIn': expiresIn,
      'expiredAt': expiredAt,
      'refreshToken': refreshToken,
      'refreshTokenExpiresIn': refreshTokenExpiresIn,
      'refreshTokenExpiredAt': refreshTokenExpiredAt,
      'scope': scope,
      'scopes': scopes,
    };
  }

  @override
  String toString() => toJson().toString();
}
