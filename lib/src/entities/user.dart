import '../types/types.dart';

/// 사용자 정보 요청 API 응답으로 제공되는 사용자 정보입니다.
class User {
  /// 카카오 플랫폼 내에서 사용되는 사용자의 고유 아이디입니다.
  /// - note:
  /// 2018년 9월 19일부터 신규로 생성되는 앱에 대해 **사용자 아이디 고정**을 자동으로 활성화하고 있습니다. https://devtalk.kakao.com/t/api/58481?u=karl.lee&source_topic_id=60227
  final int? uuid;

  /// 사용자의 카카오계정 정보
  /// 이메일, 프로필 정보 등이 제공됩니다.
  final Account? account;

  /// 앱 별로 제공되는 사용자 정보 데이터베이스입니다.
  ///
  /// 기본 제공되는 사용자 프로필 정보의 키 이름은 아래와 같습니다.
  /// - nickname : 카카오계정에 설정된 닉네임
  /// - profile_image : 프로필 이미지 URL 문자열
  /// - thumbnail_image : 썸네일 사이즈의 프로필 이미지 URL 문자열
  final Map<String, String>? properties;

  /// 앱이 그룹에 속해 있는 경우 그룹 내 사용자 식별 토큰입니다. 앱의 그룹정보가 변경될 경우 토큰 값도 변경됩니다. 제휴를 통해 권한이 부여된 특정 앱에만 제공됩니다.
  final String? groupUserToken;

  /// 해당 서비스에 연결 완료된 시각
  final DateTime? connectedAt;

  /// 카카오싱크 간편가입창을 통해 카카오 로그인 한 시각
  final DateTime? synchedAt;

  User._({
    this.uuid,
    this.account,
    this.properties,
    this.groupUserToken,
    this.connectedAt,
    this.synchedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User._(
      uuid: json['uuid'],
      account: Account.fromJson(
        json['account'] != null
            ? Map<String, dynamic>.from(json['account'])
            : null,
      ),
      properties: json['properties'] != null
          ? Map<String, String>.from(json['properties'])
          : null,
      groupUserToken: json['groupUserToken'],
      connectedAt: json['connectedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['connectedAt'])
          : null,
      synchedAt: json['synchedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['synchedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'uuid': uuid,
      'account': account,
      'properties': properties,
      'groupUserToken': groupUserToken,
      'connectedAt': connectedAt,
      'synchedAt': synchedAt,
    };
  }

  @override
  String toString() => toJson().toString();
}

/// 카카오계정에 등록된 사용자 개인정보를 제공합니다.
///
/// 내려오는 실제 정보는 https://accounts.kakao.com 으로 접속하여 해당 계정으로 로그인한 후 확인하실 수 있습니다.
class Account {
  /// 카카오계정에 등록한 프로필 정보
  final Profile? profile;

  /// 카카오계정에 등록된 이메일
  final String? email;

  /// 카카오계정에 등록된 이메일의 유효성
  final bool? isEmailValid;

  /// 카카오계정에 이메일 등록 시 이메일 인증을 받았는지 여부
  final bool? isEmailVerified;

  /// 연령대
  final String? ageRange;

  /// 출생 연도 (YYYY)
  final String? birthyear;

  /// 생일 (MMDD)
  final String? birthday;

  /// 생일의 양력/음력
  ///
  /// 해당 프로퍼티는 iOS 플랫폼에서만 지원합니다.
  final BirthdayType? birthdayType;

  /// 성별
  final Gender? gender;

  /// 카카오톡에서 인증한 전화번호
  final String? phoneNumber;

  /// 암호화된 사용자 확인값
  final String? ci;

  /// ci 발급시간
  final DateTime? ciAuthenticatedAt;

  /// profile 제공에 대한 사용자 동의 필요 여부
  final bool? profileNeedsAgreement;

  /// email 제공에 대한 사용자 동의 필요 여부
  final bool? emailNeedsAgreement;

  /// ageRange 제공에 대한 사용자 동의 필요 여부
  final bool? ageRangeNeedsAgreement;

  /// birthyear 제공에 대한 사용자 동의 필요 여부
  final bool? birthyearNeedsAgreement;

  /// birthday 제공에 대한 사용자 동의 필요 여부
  final bool? birthdayNeedsAgreement;

  /// gender 제공에 대한 사용자의 동의 필요 여부
  final bool? genderNeedsAgreement;

  /// phoneNumber 제공에 대한 사용자 동의 필요 여부
  final bool? phoneNumberNeedsAgreement;

  /// ci 제공에 대한 사용자의 동의 필요 여부
  final bool? ciNeedsAgreement;

  Account._({
    this.profile,
    this.email,
    this.isEmailValid,
    this.isEmailVerified,
    this.ageRange,
    this.birthyear,
    this.birthday,
    this.birthdayType,
    this.gender,
    this.phoneNumber,
    this.ci,
    this.ciAuthenticatedAt,
    this.profileNeedsAgreement,
    this.emailNeedsAgreement,
    this.ageRangeNeedsAgreement,
    this.birthyearNeedsAgreement,
    this.birthdayNeedsAgreement,
    this.genderNeedsAgreement,
    this.phoneNumberNeedsAgreement,
    this.ciNeedsAgreement,
  });

  factory Account.fromJson(Map<String, dynamic>? json) {
    return json != null
        ? Account._(
            profile: Profile.fromJson(
              json['profile'] != null
                  ? Map<String, dynamic>.from(json['profile'])
                  : null,
            ),
            email: json['email'],
            isEmailValid: json['isEmailValid'],
            isEmailVerified: json['isEmailVerified'],
            ageRange: json['ageRange'],
            birthyear: json['birthyear'],
            birthday: json['birthday'],
            birthdayType:
                BirthdayTypeExtension.toBirthdayType(json['birthdayType']),
            gender: GenderExtension.toGender(json['gender']),
            phoneNumber: json['phoneNumber'],
            ci: json['ci'],
            ciAuthenticatedAt: json['ciAuthenticatedAt'] != null
                ? DateTime.fromMillisecondsSinceEpoch(json['ciAuthenticatedAt'])
                : null,
            profileNeedsAgreement: json['profileNeedsAgreement'],
            emailNeedsAgreement: json['emailNeedsAgreement'],
            ageRangeNeedsAgreement: json['ageRangeNeedsAgreement'],
            birthyearNeedsAgreement: json['birthyearNeedsAgreement'],
            birthdayNeedsAgreement: json['birthdayNeedsAgreement'],
            genderNeedsAgreement: json['genderNeedsAgreement'],
            phoneNumberNeedsAgreement: json['phoneNumberNeedsAgreement'],
            ciNeedsAgreement: json['ciNeedsAgreement'],
          )
        : Account._();
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'profile': profile,
      'email': email,
      'isEmailValid': isEmailValid,
      'isEmailVerified': isEmailVerified,
      'ageRange': ageRange,
      'birthyear': birthyear,
      'birthday': birthday,
      'birthdayType': birthdayType,
      'gender': gender,
      'phoneNumber': phoneNumber,
      'ci': ci,
      'ciAuthenticatedAt': ciAuthenticatedAt,
      'profileNeedsAgreement': profileNeedsAgreement,
      'emailNeedsAgreement': emailNeedsAgreement,
      'ageRangeNeedsAgreement': ageRangeNeedsAgreement,
      'birthyearNeedsAgreement': birthyearNeedsAgreement,
      'birthdayNeedsAgreement': birthdayNeedsAgreement,
      'genderNeedsAgreement': genderNeedsAgreement,
      'phoneNumberNeedsAgreement': phoneNumberNeedsAgreement,
      'ciNeedsAgreement': ciNeedsAgreement,
    };
  }

  @override
  String toString() => toJson().toString();
}

/// 사용자 정보 요청 API 응답으로 제공되는 사용자의 프로필 정보입니다.
class Profile {
  /// 사용자의 닉네임
  final String? nickname;

  /// 카카오계정에 등록된 프로필 이미지 URL
  ///
  /// 사용자가 프로필 이미지를 등록하지 않은 경우 null입니다.
  /// 사용자가 등록한 프로필 이미지가 사진인 경우 640 * 640 규격의 이미지가, 동영상인 경우 480 * 480 규격의 스냅샷 이미지가 제공됩니다.
  final String? profileImageUrl;

  /// 카카오계정에 등록된 프로필 이미지의 썸네일 규격 이미지 URL
  ///
  /// 사용자가 프로필 이미지를 등록하지 않은 경우 null 입니다.
  /// 사용자가 등록한 프로필 이미지가 사진인 경우 110 * 110 규격의 이미지가, 동영상인 경우 100 * 100 규격의 스냅샷 이미지가 제공됩니다.
  final String? thumbnailImageUrl;

  Profile._({
    this.nickname,
    this.profileImageUrl,
    this.thumbnailImageUrl,
  });

  factory Profile.fromJson(Map<String, dynamic>? json) {
    return json != null
        ? Profile._(
            nickname: json['nickname'],
            profileImageUrl: json['profileImageUrl'],
            thumbnailImageUrl: json['thumbnailImageUrl'],
          )
        : Profile._();
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'nickname': nickname,
      'profileImageUrl': profileImageUrl,
      'thumbnailImageUrl': thumbnailImageUrl,
    };
  }

  @override
  String toString() => toJson().toString();
}
