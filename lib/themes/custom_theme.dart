import 'package:flutter/material.dart';
import 'package:plus_todo/themes/custom_appbar.dart';
import 'package:plus_todo/themes/custom_color.dart';
import 'package:plus_todo/themes/custom_date_picker.dart';
import 'package:plus_todo/themes/custom_text_selection.dart';

class CustomTheme {
  static ThemeData customThemeData() {
    return ThemeData(
      useMaterial3: true,

      /// 앱바 테마 설정
      appBarTheme: CustomAppbarTheme.customAppBarThemeData(),

      /// 텍스트 선택 테마 설정
      textSelectionTheme: CustomTextSelectionTheme.customTextSelectionThemeData(),

      /// 날짜 선택 다이어로그 테마 설정
      datePickerTheme: CustomDatePickerTheme.customDatePickerThemeData(),

      /// 컬러 설정
      scaffoldBackgroundColor: background,
      primaryColor: black,
      splashColor: transparent,
      highlightColor: transparent,
      applyElevationOverlayColor: false,
    );
  }
}
