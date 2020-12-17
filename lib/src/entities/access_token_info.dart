/// 토큰 정보 요청 API 응답으로 제공되는 토큰 정보입니다.
class AccessTokenInfo {
  /// 사용자 아이디
  final int uuid;

  /// 액세스 토큰의 남은 만료시간 (단위: 초)
  final int expiresIn;

  AccessTokenInfo._({
    this.uuid,
    this.expiresIn,
  });

  factory AccessTokenInfo.fromJson(Map<String, dynamic> json) {
    return AccessTokenInfo._(
      uuid: json['uuid'],
      expiresIn: json['expiresIn'],
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'uuid': uuid,
      'expiresIn': expiresIn,
    };
  }

  @override
  String toString() => toJson().toString();
}
