import 'dart:async';

import 'package:flutter/services.dart';

import 'entities/entities.dart';
import 'exceptions/exceptions.dart';
import 'extensions/extensions.dart';

/// 카카오 로그인 v2 SDK 지원을 위한 플러그인.
///
/// 카카오 SDK를 통해 로그인, 로그아웃, 연결끊기 및 사용자 정보 획득 기능을 지원합니다.
/// 현재는 Android 와 iOS 플랫폼만 지원합니다.
class SignInWithKakao {
  SignInWithKakao._();

  static const MethodChannel _channel = const MethodChannel(
    'plugins.juyoung.dev/sign_in_with_kakao',
  );

  /// 카카오 SDK를 통해 카카오에 로그인을 요청합니다.
  ///
  /// 카카오톡 앱 설치 여부에 따라 카카오톡으로 이동 또는 웹으로 이동하여 로그인을 진행합니다.
  /// 로그인 요청이 성공하면 토큰 발급을 요청하고 토큰 발급이 완료되면 로그인이 완료됩니다.
  ///
  /// 로그인 처리 중 SDK 오류가 발생한 경우 [AuthFailureException]을 throw 합니다.
  /// SDK 오류 이외의 예외는 [Exception] 객체를 rethrow 합니다.
  /// 정상적으로 처리가 완료되면 발급된 토큰 정보인 [AuthToken] 객체를 반환합니다.
  static Future<AuthToken> login() async {
    try {
      final data = await _channel.invokeMethod('login');
      return AuthToken.fromJson(Map<String, dynamic>.from(data));
    } on PlatformException catch (error) {
      throw AuthFailureException(error.code.authFailureReason, error.message);
    } catch (error) {
      rethrow;
    }
  }

  /// 카카오 SDK를 통해 카카오에 로그아웃을 요청합니다.
  ///
  /// 요청 성공여부와 상관없이 SDK 내부에 캐시된 토큰은 삭제됩니다.
  ///
  /// 로그아웃 요청 성공유무에 따라 [bool] 값을 반환합니다.
  static Future<bool> logout() async {
    return await _channel.invokeMethod('logout');
  }

  /// 카카오 SDK를 통해 카카오 플랫폼과 앱의 사용자 계정 연결 상태를 해제합니다.
  ///
  /// 요청 성공 시 로그아웃 처리가 함께 이뤄져 토큰정보가 삭제되므로 기존의 토큰은 더 이상 사용할 수 없습니다.
  ///
  /// 연결 끊기 요청 성공유무에 따라 [bool] 값을 반환합니다.
  static Future<bool> unlink() async {
    return await _channel.invokeMethod('unlink');
  }

  /// 카카오 SDK를 통해 현재 캐시에 저장하여 사용 중인 사용자 액세스 토큰 정보를 불러옵니다.
  ///
  /// [me]에서 제공되는 다양한 사용자 정보 없이 가볍게 토큰의 유효성을 체크하는 용도로 사용하는 것을 추천합니다.
  ///
  /// 사용자 액세스 토큰 정보 요청 중 SDK 오류가 발생한 경우 [ApiFailureException]을 throw 합니다.
  /// SDK 오류 이외의 예외는 [Exception] 객체를 rethrow 합니다.
  /// 정상적으로 처리가 완료되면 액세스 토큰 정보인 [AccessTokenInfo] 객체를 반환합니다.
  static Future<AccessTokenInfo> accessTokenInfo() async {
    try {
      final data = await _channel.invokeMethod('accessTokenInfo');
      return AccessTokenInfo.fromJson(Map<String, dynamic>.from(data));
    } on PlatformException catch (error) {
      throw ApiFailureException(error.code.apiFailureReason, error.message);
    } catch (error) {
      rethrow;
    }
  }

  /// 카카오 SDK를 통해 현재 로그인한 사용자의 정보를 불러옵니다.
  ///
  /// 사용자 정보 요청 중 SDK 오류가 발생한 경우 [ApiFailureException] throw 합니다.
  /// SDK 오류 이외의 예외는 [Exception] 객체를 rethrow 합니다.
  /// 정상적으로 처리가 완료되면 사용자 정보인 [bool] 객체를 반환합니다.
  static Future<User> me() async {
    try {
      final data = await _channel.invokeMethod('me');
      return User.fromJson(Map<String, dynamic>.from(data));
    } on PlatformException catch (error) {
      throw ApiFailureException(error.code.apiFailureReason, error.message);
    } catch (error) {
      rethrow;
    }
  }

  /// 카카오 SDK를 통해 사용자 정보를 저장합니다.
  ///
  /// 사용자 정보 저장하기 기능은 사용자 프로퍼티인 properties 하위 정보의 값을 저장합니다.
  /// 키 값은 [내 애플리케이션] > [사용자 프로퍼티]에 정의한 값을 사용해야 합니다.
  ///
  /// 사용자 정보 저장 성공 유무에 따라 [bool] 값을 반환합니다.
  static Future<bool> updateProfile(Map<String, String> properties) async {
    return await _channel.invokeMethod('updateProfile', properties);
  }
}
