import 'package:flutter/material.dart';
import 'package:plus_todo/themes/custom_color.dart';
import 'package:plus_todo/themes/custom_font.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController textController;
  final FocusNode? focusNode;

  const CustomTextField({
    super.key,
    required this.hintText,
    required this.textController,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration.collapsed(
        hintText: hintText,
        hintStyle: const TextStyle(color: gray),
        border: InputBorder.none,
      ),
      style: CustomTextStyle.body1,
      textAlignVertical: TextAlignVertical.center,
      controller: textController,
      focusNode: focusNode,
      maxLines: null,
      cursorWidth: 1,
    );
  }
}