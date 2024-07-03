import 'package:flutter/material.dart';
import 'package:plus_todo/themes/custom_color.dart';

class CustomTextField extends StatelessWidget {
  final String? hintText;
  final TextStyle textStyle;
  final TextEditingController textController;
  final FocusNode? focusNode;

  const CustomTextField({
    super.key,
    this.hintText,
    required this.textStyle,
    required this.textController,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration.collapsed(
        hintText: hintText,
        hintStyle: textStyle.copyWith(color: gray, letterSpacing: 0),
        border: InputBorder.none,
      ),
      style: textStyle,
      controller: textController,
      focusNode: focusNode,
      textAlign: TextAlign.justify,
      maxLines: null,
      cursorWidth: 1,
    );
  }
}
