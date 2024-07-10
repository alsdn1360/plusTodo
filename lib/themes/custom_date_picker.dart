import 'package:flutter/material.dart';
import 'package:plus_todo/themes/custom_color.dart';
import 'package:plus_todo/themes/custom_decoration.dart';
import 'package:plus_todo/themes/custom_font.dart';

class CustomDatePickerTheme {
  static DatePickerThemeData customDatePickerThemeData() {
    return DatePickerThemeData(
      elevation: 0,
      backgroundColor: white,
      surfaceTintColor: white,
      dividerColor: black.withOpacity(0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(defaultBorderRadiusM)),
      headerHelpStyle: CustomTextStyle.title3,
      yearStyle: CustomTextStyle.body1,
      weekdayStyle: CustomTextStyle.body1,
      dayStyle: CustomTextStyle.body2,
    );
  }
}
