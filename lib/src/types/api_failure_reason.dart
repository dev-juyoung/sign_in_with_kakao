import '../extensions/extensions.dart';

/// 카카오 API 요청 에러 종류.
///
/// TODO: 현재 모든 API 예외를 래핑했으나 추후 불필요 코드 정리 필요.
enum ApiFailureReason {
  /// 기타 서버 에러
  unknown,

  /// 기타 서버 에러
  internal,

  /// 잘못된 파라미터
  badParameter,

  /// 지원되지 않는 API
  unsupportedApi,

  /// API 호출이 금지됨
  blocked,

  /// 호출 권한이 없음
  permission,

  /// 더이상 지원하지 않은 API를 요청한 경우
  deprecatedApi,

  /// 쿼터 초과
  apiLimitExceed,

  /// 연결되지 않은 사용자
  notSignedUpUser,

  /// 이미 연결된 사용자에 대해 signup 시도
  alreadySignedUpUsercase,

  /// 존재하지 않는 카카오계정
  notKakaoAccountUser,

  /// 등록되지 않은 user property key
  invalidUserPropertyKey,

  /// 등록되지 않은 앱키의 요청 또는 존재하지 않는 앱으로의 요청. (앱키가 인증에 사용되는 경우는 -401 참조)
  noSuchApp,

  /// 앱키 또는 토큰이 잘못된 경우. 예) 토큰 만료
  invalidAccessToken,

  /// 해당 API에서 접근하는 리소스에 대해 사용자의 동의를 받지 않음
  insufficientScope,

  /// 카카오계정에 연령인증이 필요함
  notAgeAuthorized,

  /// 앱의 연령제한보다 사용자의 연령이 낮음
  lowerAgeLimit,

  /// 이미 연령인증이 완료 됨
  alreadyAgeAuthorized,

  /// 연령인증 허용 횟수 초과
  ageCheckLimitExceed,

  /// 이전 연령인증과 일치하지 않음
  ageResultMismatched,

  /// CI 불일치
  ciResultMismatched,

  /// 카카오톡 사용자가 아님
  notTalkUser,

  /// 지원되지 않는 기기로 메시지 보내는 경우
  userDevicedUnsupported,

  /// 메시지 수신자가 수신을 거부한 경우
  talkMessageDisabled,

  /// 월간 메시지 전송 허용 횟수 초과
  talkSendMessageMonthlyLimitExceed,

  /// 일간 메시지 전송 허용 횟수 초과
  talkSendMessageDailyLimitExceed,

  /// 카카오스토리 사용자가 아님
  notStoryUser,

  /// 카카오스토리 이미지 업로드 사이즈 제한 초과
  storyImageUploadSizeExceed,

  /// 카카오스토리 이미지 업로드 타임아웃
  storyUploadTimeout,

  /// 카카오스토리 스크랩시 잘못된 스크랩 URL로 호출할 경우
  storyInvalidScrapUrl,

  /// 카카오스토리의 내정보 요청시 잘못된 내스토리 아이디(포스트 아이디)로 호출할 경우
  storyInvalidPostId,

  /// 카카오스토리 이미지 업로드시 허용된 업로드 파일 수가 넘을 경우
  storyMaxUploadNumberExceed,

  /// 서버 점검 중
  underMaintenance,
}

extension ApiFailureReasonExtension on ApiFailureReason {
  String get rawValue => this.toString().split('.').last.toSnakeCase();

  static ApiFailureReason toReason(String rawValue) {
    if (ApiFailureReason.internal.rawValue == rawValue) {
      return ApiFailureReason.internal;
    } else if (ApiFailureReason.badParameter.rawValue == rawValue) {
      return ApiFailureReason.badParameter;
    } else if (ApiFailureReason.unsupportedApi.rawValue == rawValue) {
      return ApiFailureReason.unsupportedApi;
    } else if (ApiFailureReason.blocked.rawValue == rawValue) {
      return ApiFailureReason.blocked;
    } else if (ApiFailureReason.permission.rawValue == rawValue) {
      return ApiFailureReason.permission;
    } else if (ApiFailureReason.deprecatedApi.rawValue == rawValue) {
      return ApiFailureReason.deprecatedApi;
    } else if (ApiFailureReason.apiLimitExceed.rawValue == rawValue) {
      return ApiFailureReason.apiLimitExceed;
    } else if (ApiFailureReason.notSignedUpUser.rawValue == rawValue) {
      return ApiFailureReason.notSignedUpUser;
    } else if (ApiFailureReason.alreadySignedUpUsercase.rawValue == rawValue) {
      return ApiFailureReason.alreadySignedUpUsercase;
    } else if (ApiFailureReason.notKakaoAccountUser.rawValue == rawValue) {
      return ApiFailureReason.notKakaoAccountUser;
    } else if (ApiFailureReason.invalidUserPropertyKey.rawValue == rawValue) {
      return ApiFailureReason.invalidUserPropertyKey;
    } else if (ApiFailureReason.noSuchApp.rawValue == rawValue) {
      return ApiFailureReason.noSuchApp;
    } else if (ApiFailureReason.invalidAccessToken.rawValue == rawValue) {
      return ApiFailureReason.invalidAccessToken;
    } else if (ApiFailureReason.insufficientScope.rawValue == rawValue) {
      return ApiFailureReason.insufficientScope;
    } else if (ApiFailureReason.notAgeAuthorized.rawValue == rawValue) {
      return ApiFailureReason.notAgeAuthorized;
    } else if (ApiFailureReason.lowerAgeLimit.rawValue == rawValue) {
      return ApiFailureReason.lowerAgeLimit;
    } else if (ApiFailureReason.alreadyAgeAuthorized.rawValue == rawValue) {
      return ApiFailureReason.alreadyAgeAuthorized;
    } else if (ApiFailureReason.ageCheckLimitExceed.rawValue == rawValue) {
      return ApiFailureReason.ageCheckLimitExceed;
    } else if (ApiFailureReason.ageResultMismatched.rawValue == rawValue) {
      return ApiFailureReason.ageResultMismatched;
    } else if (ApiFailureReason.ciResultMismatched.rawValue == rawValue) {
      return ApiFailureReason.ciResultMismatched;
    } else if (ApiFailureReason.notTalkUser.rawValue == rawValue) {
      return ApiFailureReason.notTalkUser;
    } else if (ApiFailureReason.userDevicedUnsupported.rawValue == rawValue) {
      return ApiFailureReason.userDevicedUnsupported;
    } else if (ApiFailureReason.talkMessageDisabled.rawValue == rawValue) {
      return ApiFailureReason.talkMessageDisabled;
    } else if (ApiFailureReason.talkSendMessageMonthlyLimitExceed.rawValue ==
        rawValue) {
      return ApiFailureReason.talkSendMessageMonthlyLimitExceed;
    } else if (ApiFailureReason.talkSendMessageDailyLimitExceed.rawValue ==
        rawValue) {
      return ApiFailureReason.talkSendMessageDailyLimitExceed;
    } else if (ApiFailureReason.notStoryUser.rawValue == rawValue) {
      return ApiFailureReason.notStoryUser;
    } else if (ApiFailureReason.storyImageUploadSizeExceed.rawValue ==
        rawValue) {
      return ApiFailureReason.storyImageUploadSizeExceed;
    } else if (ApiFailureReason.storyUploadTimeout.rawValue == rawValue) {
      return ApiFailureReason.storyUploadTimeout;
    } else if (ApiFailureReason.storyInvalidScrapUrl.rawValue == rawValue) {
      return ApiFailureReason.storyInvalidScrapUrl;
    } else if (ApiFailureReason.storyInvalidPostId.rawValue == rawValue) {
      return ApiFailureReason.storyInvalidPostId;
    } else if (ApiFailureReason.storyMaxUploadNumberExceed.rawValue ==
        rawValue) {
      return ApiFailureReason.storyMaxUploadNumberExceed;
    } else if (ApiFailureReason.underMaintenance.rawValue == rawValue) {
      return ApiFailureReason.underMaintenance;
    } else {
      return ApiFailureReason.unknown;
    }
  }
}
