import 'package:flutter/material.dart';
import 'package:plus_todo/themes/custom_color.dart';
import 'package:plus_todo/themes/custom_decoration.dart';
import 'package:plus_todo/themes/custom_font.dart';

class TodoUrgencyImportanceCard extends StatelessWidget {
  final Color color;
  final String content;
  final bool isCompleted;

  const TodoUrgencyImportanceCard({
    super.key,
    required this.color,
    required this.content,
    this.isCompleted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: defaultPaddingM / 2,
        vertical: defaultPaddingL / 6,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.6),
        borderRadius: BorderRadius.circular(defaultBorderRadiusL / 3),
      ),
      child: Text(
        content,
        style: (isCompleted)
            ? CustomTextStyle.body3.copyWith(
                color: white,
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.lineThrough,
              )
            : CustomTextStyle.body3.copyWith(color: white, fontWeight: FontWeight.w600),
      ),
    );
  }
}
