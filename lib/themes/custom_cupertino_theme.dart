import 'package:flutter/cupertino.dart';
import 'package:plus_todo/themes/custom_color.dart';
import 'package:plus_todo/themes/custom_font.dart';

class CustomCupertinoTheme {
  static CupertinoThemeData customCupertinoThemeData() {
    return CupertinoThemeData(
      brightness: Brightness.light,
      primaryColor: black,
      textTheme: CupertinoTextThemeData(
        dateTimePickerTextStyle: CustomTextStyle.title2,
      ),
    );
  }
}