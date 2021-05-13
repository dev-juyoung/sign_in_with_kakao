/// 사용자 정보 - 성별 정보 열거형
enum Gender {
  /// 남자
  male,

  /// 여자
  female,
}

extension GenderExtension on Gender {
  String get rawValue => this.toString().split('.').last;

  static Gender? toGender(String? rawValue) {
    final value = rawValue != null ? rawValue.toLowerCase() : null;

    if (Gender.male.rawValue == value) {
      return Gender.male;
    } else if (Gender.female.rawValue == value) {
      return Gender.female;
    } else {
      return null;
    }
  }
}
