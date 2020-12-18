# Sign in with Kakao

[![pub package](https://img.shields.io/pub/v/sign_in_with_kakao)](https://pub.dartlang.org/packages/sign_in_with_kakao)

카카오 SDK를 이용하여 로그인 v2 기능을 지원하기 위한 플러그인 입니다.

**해당 플러그인은 카카오에서 공식으로 지원하는 플러그인이 아닙니다.**

공식 플러그인 사용을 원하신다면 아래의 플러그인을 이용해주세요. :pray:

:point_right: [Official Links](https://github.com/kakao/kakao_flutter_sdk)

## Supported platforms

- Android 21 이상
- iOS 11 이상

## Features

- [x] 카카오톡으로 로그인
- [x] 카카오계정으로 로그인
- [x] 로그아웃
- [x] 연결끊기
- [x] 토큰정보 보기
- [x] 사용자 정보 가져오기
- [x] 사용자 정보 저장하기
- [ ] 추가 항목 동의 받기

## Getting Started

자세한 사용법은 `example` 디렉토리를 참고해주세요. :pray:

### pubspec.yaml 추가

```
dependencies:
  kakao_flutter_sdk: latest version
```

### 애플리케이션 등록

아래의 링크를 참고하여 카카오 SDK 사용을 위한 애플리케이션 등록을 완료해주세요.

:point_right:  [애플리케이션 등록](https://developers.kakao.com/docs/latest/ko/getting-started/app)

### 카카오 로그인 설정

아래의 링크를 참고하여 카카오 로그인 설정을 완료해주세요.

:point_right:  [카카오 로그인 설정하기](https://developers.kakao.com/docs/latest/ko/kakaologin/prerequisite)

### Android 설정

#### 키 해시 등록

아래의 링크를 참고하여 안드로이드 키 해시를 등록해주세요.

:point_right:  [안드로이드 키 해시 등록](https://developers.kakao.com/docs/latest/ko/getting-started/sdk-android#add-key-hash)

#### AndroidManifest.xml 설정

```xml
<application>
    <!-- 플러터 플러그인 v2 버전만 지원합니다. -->
    <meta-data
      android:name="flutterEmbedding"
      android:value="2" />

    <!-- 카카오 SDK 초기화 과정에 사용됩니다. -->
    <meta-data
      android:name="plugin.dev.juyoung.kakao.KakaoAppKey"
      android:value="네이티브 앱 키를 입력해주세요." />

    <!-- 카카오 로그인 처리에 사용됩니다. -->
    <activity android:name="com.kakao.sdk.auth.AuthCodeHandlerActivity">
      <intent-filter>
          <action android:name="android.intent.action.VIEW" />
          <category android:name="android.intent.category.DEFAULT" />
          <category android:name="android.intent.category.BROWSABLE" />

          <data
              android:host="oauth"
              android:scheme="kakao{NATIVE_APP_KEY}" />
      </intent-filter>
    </activity>
</application>
```

### iOS 설정

#### Info.plist 설정

```xml
<plist version="1.0">
<dict>
    <!-- 카카오 SDK 초기화 과정에 사용됩니다. -->
    <key>KakaoAppKey</key>
    <string>네이티브 앱 키를 입력해주세요.</string>
    <!-- 카카오 인증을 통한 앱 실행에 사용됩니다. -->
    <key>CFBundleURLTypes</key>
    <array>
        <dict>
            <key>CFBundleTypeRole</key>
            <string>Editor</string>
            <key>CFBundleURLSchemes</key>
            <array>
                <string>kakao{NATIVE_APP_KEY}</string>
            </array>
        </dict>
    </array>
    <!-- 카카오 애플리케이션 실행을 위해 사용됩니다. -->
    <key>LSApplicationQueriesSchemes</key>
     <array>
         <string>kakaokompassauth</string>
         <string>kakaolink</string>
     </array>
</dict>
</plist>
```
