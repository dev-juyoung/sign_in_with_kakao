package dev.juyoung.sign_in_with_kakao

import android.content.Context
import com.kakao.sdk.auth.LoginClient
import com.kakao.sdk.auth.model.OAuthToken
import com.kakao.sdk.common.model.ApiError
import com.kakao.sdk.common.model.AuthError
import com.kakao.sdk.user.UserApiClient
import com.kakao.sdk.user.model.AccessTokenInfo
import com.kakao.sdk.user.model.User
import dev.juyoung.sign_in_with_kakao.extensions.rawValue

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

class SignInWithKakaoPlugin : FlutterPlugin, MethodCallHandler {
    private lateinit var channel: MethodChannel
    private lateinit var context: Context

    companion object {
        const val TAG = "[Plugins] KakaoSDK"
        const val CHANNEL = "plugins.juyoung.dev/sign_in_with_kakao"

        // METHODS
        const val METHOD_LOGIN = "login"
        const val METHOD_LOGOUT = "logout"
        const val METHOD_UNLINK = "unlink"
        const val METHOD_ACCESS_TOKEN_INFO = "accessTokenInfo"
        const val METHOD_ME = "me"
        const val METHOD_UPDATE_PROFILE = "updateProfile"

        // ERROR CODES
        const val UNCAUGHT_EXCEPTION = "uncaught_exception"
        const val MISSING_REQUIRED_ARGUMENTS = "missing_required_arguments"

        const val UNCAUGHT_EXCEPTION_MESSAGE = "KAKAO SDK 처리 도중 알 수 없는 예외가 발생했습니다."
        const val MISSING_REQUIRED_ARGUMENTS_MESSAGE = "요청을 위한 필수 정보가 누락되었습니다."
    }

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        context = binding.applicationContext
        MethodChannel(binding.binaryMessenger, CHANNEL).apply {
            channel = this
            setMethodCallHandler(this@SignInWithKakaoPlugin)
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        try {
            when (call.method) {
                METHOD_LOGIN -> login(call, result)
                METHOD_LOGOUT -> logout(call, result)
                METHOD_UNLINK -> unlink(call, result)
                METHOD_ACCESS_TOKEN_INFO -> accessTokenInfo(call, result)
                METHOD_ME -> me(call, result)
                METHOD_UPDATE_PROFILE -> updateProfile(call, result)
                else -> result.notImplemented()
            }
        } catch (e: Throwable) {
            when (e) {
                is MissingArgumentException -> result.error(
                    MISSING_REQUIRED_ARGUMENTS,
                    MISSING_REQUIRED_ARGUMENTS_MESSAGE,
                    null
                )
                else -> result.error(UNCAUGHT_EXCEPTION, UNCAUGHT_EXCEPTION_MESSAGE, null)
            }
        }
    }

    private fun login(call: MethodCall, result: Result) {
        val callback: (OAuthToken?, Throwable?) -> Unit = { authToken, error ->
            when {
                error != null -> parseError(error, result)
                authToken != null -> parseAuthToken(authToken, result)
                else -> result.error(UNCAUGHT_EXCEPTION, UNCAUGHT_EXCEPTION_MESSAGE, null)
            }
        }

        // 카카오톡 설치 유무에 따른 동작 분기
        if (LoginClient.instance.isKakaoTalkLoginAvailable(context)) {
            LoginClient.instance.loginWithKakaoTalk(context, callback = callback)
        } else {
            LoginClient.instance.loginWithKakaoAccount(context, callback = callback)
        }
    }

    private fun logout(call: MethodCall, result: Result) {
        UserApiClient.instance.logout { error ->
            if (error != null) {
                result.success(false)
            } else {
                result.success(true)
            }
        }
    }

    private fun unlink(call: MethodCall, result: Result) {
        UserApiClient.instance.unlink { error ->
            if (error != null) {
                result.success(false)
            } else {
                result.success(true)
            }
        }
    }

    private fun accessTokenInfo(call: MethodCall, result: Result) {
        UserApiClient.instance.accessTokenInfo { tokenInfo, error ->
            if (error != null) {
                parseError(error, result)
            } else if (tokenInfo != null) {
                parseTokenInfo(tokenInfo, result)
            }
        }
    }

    private fun me(call: MethodCall, result: Result) {
        UserApiClient.instance.me { user, error ->
            when {
                error != null -> parseError(error, result)
                user != null -> parseUserData(user, result)
                else -> result.error(UNCAUGHT_EXCEPTION, UNCAUGHT_EXCEPTION_MESSAGE, null)
            }
        }
    }

    private fun updateProfile(call: MethodCall, result: Result) {
        val properties = call.arguments<Map<String, String>>() ?: throw MissingArgumentException()
        UserApiClient.instance.updateProfile(properties) { error ->
            if (error != null) {
                result.success(false)
            } else {
                result.success(true)
            }
        }
    }

    private fun parseAuthToken(authToken: OAuthToken, result: Result) {
        val data = mapOf(
            // Android 버전에서는 토큰 타입 미지원.
            // 현재는 "Bearer" 타입만 사용하므로 고정해서 전달.
            "tokenType" to "bearer",
            "accessToken" to authToken.accessToken,
            "refreshToken" to authToken.refreshToken,
            "expiredAt" to authToken.accessTokenExpiresAt.time,
            "refreshTokenExpiredAt" to authToken.refreshTokenExpiresAt?.time,
            "scopes" to authToken.scopes
        )

        result.success(data)
    }

    private fun parseUserData(user: User, result: Result) {
        val data = mapOf(
            "uuid" to user.id,
            if (user.kakaoAccount != null)
                "account" to mapOf(
                    /// 프로필 정보
                    if (user.kakaoAccount!!.profile != null)
                        "profile" to mapOf(
                            "nickname" to user.kakaoAccount!!.profile!!.nickname,
                            "profileImageUrl" to user.kakaoAccount!!.profile!!.profileImageUrl,
                            "thumbnailImageUrl" to user.kakaoAccount!!.profile!!.thumbnailImageUrl
                        )
                    else
                        "profile" to null,
                    "profileNeedsAgreement" to user.kakaoAccount!!.profileNeedsAgreement,
                    /// 이메일 정보
                    "email" to user.kakaoAccount!!.email,
                    "isEmailValid" to user.kakaoAccount!!.isEmailValid,
                    "isEmailVerified" to user.kakaoAccount!!.isEmailVerified,
                    "emailNeedsAgreement" to user.kakaoAccount!!.emailNeedsAgreement,
                    /// 나이 정보
                    "ageRange" to user.kakaoAccount!!.ageRange?.rawValue,
                    "birthyear" to user.kakaoAccount!!.birthyear,
                    "birthday" to user.kakaoAccount!!.birthday,
                    "ageRangeNeedsAgreement" to user.kakaoAccount!!.ageRangeNeedsAgreement,
                    "birthyearNeedsAgreement" to user.kakaoAccount!!.birthyearNeedsAgreement,
                    "birthdayNeedsAgreement" to user.kakaoAccount!!.birthdayNeedsAgreement,
                    /// 성별 정보
                    "gender" to user.kakaoAccount!!.gender?.rawValue,
                    "genderNeedsAgreement" to user.kakaoAccount!!.genderNeedsAgreement,
                    /// 연락처 정보
                    "phoneNumber" to user.kakaoAccount!!.phoneNumber,
                    "phoneNumberNeedsAgreement" to user.kakaoAccount!!.phoneNumberNeedsAgreement,
                    /// 연계정보 (CI)
                    "ci" to user.kakaoAccount!!.ci,
                    "ciAuthenticatedAt" to user.kakaoAccount!!.ciAuthenticatedAt?.time,
                    "ciNeedsAgreement" to user.kakaoAccount!!.ciNeedsAgreement
                )
            else
                "account" to null,
            "properties" to user.properties,
            "groupUserToken" to user.groupUserToken,
            "connectedAt" to user.connectedAt?.time,
            "synchedAt" to user.synchedAt?.time
        )

        result.success(data)
    }

    private fun parseTokenInfo(tokenInfo: AccessTokenInfo, result: Result) {
        val data = mapOf(
            "uuid" to tokenInfo.id,
            "expiresIn" to tokenInfo.expiresIn
        )

        result.success(data)
    }

    private fun parseError(error: Throwable, result: Result) {
        when (error) {
            is ApiError -> result.error(error.reason.rawValue, error.response.msg, null)
            is AuthError -> result.error(
                error.response.error,
                error.response.errorDescription,
                null
            )
            else -> result.error(UNCAUGHT_EXCEPTION, UNCAUGHT_EXCEPTION_MESSAGE, null)
        }
    }
}
