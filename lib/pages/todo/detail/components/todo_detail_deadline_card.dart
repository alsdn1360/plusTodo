import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
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
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(defaultPaddingS),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(defaultBorderRadiusM),
            color: white,
          ),
          child: Text(
            '${todoData.deadline!.year}년 ${todoData.deadline!.month}월 ${todoData.deadline!.day}일 (${_getDayOfWeek(todoData.deadline!.weekday)})',
            style: CustomTextStyle.body1,
          ),
        ),
        const Gap(defaultGapL),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(defaultPaddingS),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(defaultBorderRadiusM),
            color: white,
          ),
          child: Text(
            _formatTime(todoData.deadline!),
            style: CustomTextStyle.body1,
          ),
        ),
      ],
    );
  }

  String _getDayOfWeek(int day) {
    switch (day) {
      case 1:
        return '월';
      case 2:
        return '화';
      case 3:
        return '수';
      case 4:
        return '목';
      case 5:
        return '금';
      case 6:
        return '토';
      case 7:
        return '일';
      default:
        return '';
    }
  }

  String _formatTime(DateTime time) {
    final hours = time!.hour % 12 == 0 ? 12 : time.hour % 12;
    final period = time.hour < 12 ? '오전' : '오후';
    final minutes = time.minute.toString().padLeft(2, '0');
    return '$period $hours:$minutes';
  }
}
