/// 사용자 정보 - 생일의 양력/음력 열거형
enum BirthdayType {
  /// 양력
  solar,

  /// 음력
  lunar,
}

extension BirthdayTypeExtension on BirthdayType {
  String get rawValue => this.toString().split('.').last;

  static BirthdayType? toBirthdayType(String? rawValue) {
    final value = rawValue != null ? rawValue.toLowerCase() : null;

    if (BirthdayType.solar.rawValue == value) {
      return BirthdayType.solar;
    } else if (BirthdayType.lunar.rawValue == value) {
      return BirthdayType.lunar;
    } else {
      return null;
    }
  }
}
