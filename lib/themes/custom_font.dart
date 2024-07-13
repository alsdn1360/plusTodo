import 'package:flutter/material.dart';
import 'package:plus_todo/themes/custom_color.dart';

/// 기본 폰트
const TextStyle baseTextStyle = TextStyle(
  color: black,
  fontFamily: 'Pretendard',
  leadingDistribution: TextLeadingDistribution.even,
  fontWeight: FontWeight.w400,
);

class CustomTextStyle {
  // Headers
  /// header1 28px, 1.21, 400, Itim
  static TextStyle header1 = const TextStyle(
    fontFamily: 'Itim',
    fontSize: 30,
    height: 1.20,
    letterSpacing: 0,
    color: black,
    fontWeight: FontWeight.w400,
  );

  /// header2 22px, 1.27, 700, Pretendard
  static TextStyle header2 = baseTextStyle.copyWith(
    fontSize: 22,
    height: 1.27,
    letterSpacing: 0,
    fontWeight: FontWeight.w700,
  );

  // Titles
  /// title1 22px, 1.22, 600, Pretendard
  static TextStyle title1 = baseTextStyle.copyWith(
    fontSize: 22,
    height: 1.22,
    letterSpacing: 0,
    fontWeight: FontWeight.w600,
  );

  /// title2 20px, 1.25, 600, Pretendard
  static TextStyle title2 = baseTextStyle.copyWith(
    fontSize: 20,
    height: 1.25,
    letterSpacing: 0,
    fontWeight: FontWeight.w600,
  );

  /// title3 18px, 1.27, 600, Pretendard
  static TextStyle title3 = baseTextStyle.copyWith(
    fontSize: 18,
    height: 1.27,
    letterSpacing: 0,
    fontWeight: FontWeight.w600,
  );

  // Bodies
  /// body1 16px, 1.25, 600, Pretendard
  static TextStyle body1 = baseTextStyle.copyWith(
    fontSize: 16,
    height: 1.25,
    letterSpacing: 0,
    fontWeight: FontWeight.w600,
  );

  /// body2 16px, 1.25, 400, Pretendard
  static TextStyle body2 = baseTextStyle.copyWith(
    fontSize: 16,
    height: 1.25,
    letterSpacing: 0,
  );

  /// body3 14px, 1.28, 400, Pretendard
  static TextStyle body3 = baseTextStyle.copyWith(
    fontSize: 14,
    height: 1.28,
    letterSpacing: 0,
  );

  // Captions
  /// caption2 12px, 1.25, 400, Pretendard
  static TextStyle caption1 = baseTextStyle.copyWith(
    fontSize: 12,
    height: 1.25,
    letterSpacing: 0,
  );
}
