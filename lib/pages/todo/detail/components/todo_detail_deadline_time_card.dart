import 'package:flutter/material.dart';
import 'package:plus_todo/functions/general_format_time.dart';
import 'package:plus_todo/models/todo.dart';
import 'package:plus_todo/themes/custom_color.dart';
import 'package:plus_todo/themes/custom_decoration.dart';
import 'package:plus_todo/themes/custom_font.dart';

class TodoDetailDeadlineTimeCard extends StatelessWidget {
  final Todo todoData;

  const TodoDetailDeadlineTimeCard({
    super.key,
    required this.todoData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(defaultPaddingS),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(defaultBorderRadiusM),
        color: white,
      ),
      child: Text(
        GeneralFormatTime.formatTime(todoData.deadline!),
        style: CustomTextStyle.body1,
      ),
    );
  }
}
