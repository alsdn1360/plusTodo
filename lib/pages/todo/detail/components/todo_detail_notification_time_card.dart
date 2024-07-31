import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:plus_todo/models/todo.dart';
import 'package:plus_todo/functions/general_format_time.dart';
import 'package:plus_todo/themes/custom_color.dart';
import 'package:plus_todo/themes/custom_decoration.dart';
import 'package:plus_todo/themes/custom_font.dart';

class TodoDetailNotificationTimeCard extends StatelessWidget {
  final Todo todoData;

  const TodoDetailNotificationTimeCard({
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
        border: Border.all(color: gray.withOpacity(0.2), width: 0.2),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            GeneralFormatTime.formatNotificationTime(todoData.notificationTime),
            style: CustomTextStyle.body1,
          ),
          const Gap(defaultGapS),
          Text(
            '알림 시간',
            style: CustomTextStyle.body1.copyWith(color: gray),
          ),
        ],
      ),
    );
  }
}
