import Flutter
import UIKit
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser

public class SwiftSignInWithKakaoPlugin: NSObject, FlutterPlugin {
    private let TAG = "[Plugins] SignInWithKakao"
    private static let CHANNEL = "plugins.juyoung.dev/sign_in_with_kakao"
    
    // ERROR CODES
    private let UNCAUGHT_EXCEPTION = "uncaught_exception"
    private let MISSING_REQUIRED_ARGUMENTS = "missing_required_arguments"
    
    private let UNCAUGHT_EXCEPTION_MESSAGE = "KAKAO SDK 처리 도중 알 수 없는 예외가 발생했습니다."
    private let MISSING_REQUIRED_ARGUMENTS_MESSAGE = "요청을 위한 필수 정보가 누락되었습니다."
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let instance = SwiftSignInWithKakaoPlugin()
        let channel = FlutterMethodChannel(name: CHANNEL, binaryMessenger: registrar.messenger())
        
        registrar.addApplicationDelegate(instance)
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [AnyHashable : Any] = [:]) -> Bool {
        let infoDictionary = Bundle.main.infoDictionary!
        let appKey = infoDictionary["KakaoAppKey"] as! String
        KakaoSDKCommon.initSDK(appKey: appKey)
        return true
    }
    
    public func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if (AuthApi.isKakaoTalkLoginUrl(url)) {
            return AuthController.handleOpenUrl(url: url)
        }
        
        return false
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "login":
            login(call: call, result: result)
        case "logout":
            logout(call: call, result: result)
        case "unlink":
            unlink(call: call, result: result)
        case "accessTokenInfo":
            accessTokenInfo(call: call, result: result)
        case "me":
            me(call: call, result: result)
        case "updateProfile":
            updateProfile(call: call, result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    private func login(call: FlutterMethodCall, result: @escaping FlutterResult) {
        if (UserApi.isKakaoTalkLoginAvailable()) {
            UserApi.shared.loginWithKakaoTalk { authToken, error in
                if let error = error {
                    self.parseError(error: error, result: result)
                    return
                }
                
                guard let authToken = authToken else {
                    result(FlutterError(code: self.UNCAUGHT_EXCEPTION, message: self.UNCAUGHT_EXCEPTION_MESSAGE, details: nil))
                    return
                }
                
                self.parseAuthToken(authToken: authToken, result: result);
            }
        } else {
            UserApi.shared.loginWithKakaoAccount { (authToken, error) in
                if let error = error {
                    self.parseError(error: error, result: result)
                    return
                }
                
                guard let authToken = authToken else {
                    result(FlutterError(code: self.UNCAUGHT_EXCEPTION, message: self.UNCAUGHT_EXCEPTION_MESSAGE, details: nil))
                    return
                }
                
                self.parseAuthToken(authToken: authToken, result: result);
            }
        }
    }
    
    private func logout(call: FlutterMethodCall, result: @escaping FlutterResult) {
        UserApi.shared.logout { error in
            guard error == nil else {
                result(false)
                return
            }
            
            result(true)
        }
    }
    
    private func unlink(call: FlutterMethodCall, result: @escaping FlutterResult) {
        UserApi.shared.unlink { error in
            guard error == nil else {
                result(false)
                return
            }
            
            result(true)
        }
    }
    
    private func accessTokenInfo(call: FlutterMethodCall, result: @escaping FlutterResult) {
        UserApi.shared.accessTokenInfo { tokenInfo, error in
            if let error = error {
                self.parseError(error: error, result: result)
                return
            }
            
            guard let tokenInfo = tokenInfo else {
                result(FlutterError(code: self.UNCAUGHT_EXCEPTION, message: self.UNCAUGHT_EXCEPTION_MESSAGE, details: nil))
                return
            }
            
            self.parseTokenInfo(tokenInfo: tokenInfo, result: result)
        }
    }
    
    private func me(call: FlutterMethodCall, result: @escaping FlutterResult) {
        UserApi.shared.me { user, error in
            if let error = error {
                self.parseError(error: error, result: result)
                return
            }
            
            guard let user = user else {
                result(FlutterError(code: self.UNCAUGHT_EXCEPTION, message: self.UNCAUGHT_EXCEPTION_MESSAGE, details: nil))
                return
            }
            
            self.parseUserData(user: user, result: result)
        }
    }
    
    private func updateProfile(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let properties = call.arguments as? Dictionary<String, String> else {
            result(FlutterError(code: MISSING_REQUIRED_ARGUMENTS, message: MISSING_REQUIRED_ARGUMENTS_MESSAGE, details: nil))
            return
        }
        
        UserApi.shared.updateProfile(properties: properties) { error in
            guard error == nil else {
                result(false)
                return
            }
            
            result(true)
        }
    }
    
    private func parseAuthToken(authToken: OAuthToken, result: @escaping FlutterResult) {
        let data: [String : Any?] = [
            "tokenType": authToken.tokenType,
            "accessToken": authToken.accessToken,
            "refreshToken": authToken.refreshToken,
            "expiresIn": Int(authToken.expiresIn),
            "expiredAt": Int(authToken.expiredAt.timeIntervalSince1970 * 1000),
            "refreshTokenExpiresIn": Int(authToken.refreshTokenExpiresIn),
            "refreshTokenExpiredAt": Int(authToken.refreshTokenExpiredAt.timeIntervalSince1970 * 1000),
            "scope": authToken.scope,
            "scopes": authToken.scopes
        ]
        
        result(data)
    }
    
    private func parseTokenInfo(tokenInfo: AccessTokenInfo, result: @escaping FlutterResult) {
        let data: [String : Any?] = [
            "uuid": tokenInfo.id,
            "expiresIn": tokenInfo.expiresIn,
        ]
        
        result(data)
    }
    
    private func parseUserData(user: User, result: @escaping FlutterResult) {
        let data: [String : Any?] = [
            "uuid": user.id,
            "account": user.kakaoAccount != nil ? [
                /// 프로필 정보
                "profile": user.kakaoAccount!.profile != nil ? [
                    "nickname": user.kakaoAccount!.profile!.nickname,
                    "profileImageUrl": user.kakaoAccount!.profile!.profileImageUrl?.absoluteString,
                    "thumbnailImageUrl": user.kakaoAccount!.profile!.thumbnailImageUrl?.absoluteString
                ] as [String : Any?] : nil,
                "profileNeedsAgreement": user.kakaoAccount!.profileNeedsAgreement,
                /// 이메일 정보
                "email": user.kakaoAccount!.email,
                "isEmailValid": user.kakaoAccount!.isEmailValid,
                "isEmailVerified": user.kakaoAccount!.isEmailVerified,
                "emailNeedsAgreement": user.kakaoAccount!.emailNeedsAgreement,
                /// 나이 정보
                "ageRange": user.kakaoAccount!.ageRange?.rawValue,
                "birthyear": user.kakaoAccount!.birthyear,
                "birthday": user.kakaoAccount!.birthday,
                "birthdayType": user.kakaoAccount!.birthdayType?.rawValue,
                "ageRangeNeedsAgreement": user.kakaoAccount!.ageRangeNeedsAgreement,
                "birthyearNeedsAgreement": user.kakaoAccount!.birthyearNeedsAgreement,
                "birthdayNeedsAgreement": user.kakaoAccount!.birthdayNeedsAgreement,
                /// 성별 정보
                "gender": user.kakaoAccount!.gender?.rawValue,
                "genderNeedsAgreement": user.kakaoAccount!.genderNeedsAgreement,
                /// 연락처 정보
                "phoneNumber": user.kakaoAccount!.phoneNumber,
                "phoneNumberNeedsAgreement": user.kakaoAccount!.phoneNumberNeedsAgreement,
                /// 연계정보 (CI)
                "ci": user.kakaoAccount!.ci,
                "ciAuthenticatedAt": user.kakaoAccount!.ciAuthenticatedAt != nil ? Int(user.kakaoAccount!.ciAuthenticatedAt!.timeIntervalSince1970 * 1000) : nil,
                "ciNeedsAgreement": user.kakaoAccount!.ciNeedsAgreement
            ] as [String : Any?] : nil,
            "properties": user.properties,
            "groupUserToken": user.groupUserToken,
            "connectedAt": user.connectedAt != nil ? Int(user.connectedAt!.timeIntervalSince1970 * 1000) : nil,
            "synchedAt": user.synchedAt != nil ? Int(user.synchedAt!.timeIntervalSince1970 * 1000) : nil
        ]
        
        result(data)
    }
    
    private func parseError(error: Error, result: @escaping FlutterResult) {
        guard let sdkError = error as? SdkError, sdkError.isApiFailed || sdkError.isAuthFailed else {
            result(FlutterError(code: UNCAUGHT_EXCEPTION, message: UNCAUGHT_EXCEPTION_MESSAGE, details: nil))
            return
        }
        
        if sdkError.isApiFailed {
            result(FlutterError(code: sdkError.getApiError().reason.errorCode, message: sdkError.getApiError().info?.msg, details: nil))
            return
        }
        
        if sdkError.isAuthFailed {
            result(FlutterError(code: sdkError.getAuthError().reason.rawValue, message: sdkError.getAuthError().info?.errorDescription, details: nil))
            return
        }
    }
}

extension ApiFailureReason {
    var errorCode: String {
        switch self {
        case .Unknown:
            return "unknown"
        case .Internal:
            return "internal"
        case .BadParameter:
            return "bad_parameter"
        case .UnsupportedApi:
            return "unsupported_api"
        case .Blocked:
            return "blocked"
        case .Permission:
            return "permission"
        case .DeprecatedApi:
            return "deprecated_api"
        case .ApiLimitExceed:
            return "api_limit_exceed"
        case .NotSignedUpUser:
            return "not_signed_up_user"
        case .AlreadySignedUpUsercase:
            return "already_signed_up_usercase"
        case .NotKakaoAccountUser:
            return "not_kakao_account_user"
        case .InvalidUserPropertyKey:
            return "invalid_user_property_key"
        case .NoSuchApp:
            return "no_such_app"
        case .InvalidAccessToken:
            return "invalid_access_token"
        case .InsufficientScope:
            return "insufficient_scope"
        case .RequiredAgeVerification:
            return "required_age_verification"
        case .UnderAgeLimit:
            return "under_age_limit"
        case .LowerAgeLimit:
            return "lower_age_limit"
        case .AlreadyAgeAuthorized:
            return "already_age_authorized"
        case .AgeCheckLimitExceed:
            return "age_check_limit_exceed"
        case .AgeResultMismatched:
            return "age_result_mismatched"
        case .CIResultMismatched:
            return "ci_result_mismatched"
        case .NotTalkUser:
            return "not_talk_user"
        case .UserDevicedUnsupported:
            return "user_deviced_unsupported"
        case .TalkMessageDisabled:
            return "talk_message_disabled"
        case .TalkSendMessageMonthlyLimitExceed:
            return "talk_send_message_monthly_limit_exceed"
        case .TalkSendMessageDailyLimitExceed:
            return "talk_send_message_daily_limit_exceed"
        case .NotStoryUser:
            return "not_story_user"
        case .StoryImageUploadSizeExceed:
            return "story_image_upload_size_exceed"
        case .StoryUploadTimeout:
            return "story_upload_timeout"
        case .StoryInvalidScrapUrl:
            return "story_invalid_scrap_url"
        case .StoryInvalidPostId:
            return "story_invalid_post_id"
        case .StoryMaxUploadNumberExceed:
            return "story_max_upload_number_exceed"
        case .UnderMaintenance:
            return "under_maintenance"
        }
    }
}
