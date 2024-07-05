import 'package:flutter/material.dart';
import 'package:plus_todo/themes/custom_color.dart';
import 'package:plus_todo/themes/custom_decoration.dart';
import 'package:plus_todo/themes/custom_font.dart';

class CustomAppbarTheme {
  static AppBarTheme customAppBarThemeData() {
    return AppBarTheme(
      backgroundColor: background,
      titleTextStyle: CustomTextStyle.header2,
      titleSpacing: defaultPaddingM,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
    );
  }
}
