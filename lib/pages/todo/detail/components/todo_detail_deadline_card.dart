import 'package:flutter/material.dart';
import 'package:plus_todo/models/todo.dart';
import 'package:plus_todo/themes/custom_color.dart';
import 'package:plus_todo/themes/custom_decoration.dart';
import 'package:plus_todo/themes/custom_font.dart';

class TodoDetailDeadlineCard extends StatelessWidget {
  final Todo todoData;

  const TodoDetailDeadlineCard({
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
        '${todoData.deadline!.year}년 ${todoData.deadline!.month}월 ${todoData.deadline!.day}일',
        style: CustomTextStyle.body1,
      ),
    );
  }
}
