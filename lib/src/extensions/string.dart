import '../types/types.dart';

extension StringExtension on String {
  String toSnakeCase() {
    final regex = RegExp(r'(?<=[a-z])[A-Z]');
    return replaceAllMapped(
      regex,
      (match) => ('_' + match.group(0)),
    ).toLowerCase();
  }

  AuthFailureReason get authFailureReason =>
      AuthFailureReasonExtension.toReason(this);

  ApiFailureReason get apiFailureReason =>
      ApiFailureReasonExtension.toReason(this);
}
