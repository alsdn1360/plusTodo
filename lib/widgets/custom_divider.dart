import 'package:flutter/material.dart';
import 'package:plus_todo/themes/custom_color.dart';

class CustomDivider extends StatelessWidget {
  const CustomDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 1,
      color: black.withOpacity(0.1),
    );
  }
}
