import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:plus_todo/models/day_of_week.dart';
import 'package:plus_todo/models/todo.dart';
import 'package:plus_todo/functions/general_format_time.dart';
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
            '${todoData.deadline!.year}년 ${todoData.deadline!.month}월 ${todoData.deadline!.day}일 (${dayOfWeekToKorean(DayOfWeek.values[todoData.deadline!.weekday - 1])})',
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
            GeneralFormatTime.formatShowTime(todoData.deadline!),
            style: CustomTextStyle.body1,
          ),
        ),
      ],
    );
  }
}
