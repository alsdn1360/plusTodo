import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:plus_todo/models/todo.dart';
import 'package:plus_todo/themes/custom_color.dart';
import 'package:plus_todo/themes/custom_decoration.dart';
import 'package:plus_todo/themes/custom_font.dart';
import 'package:plus_todo/widgets/custom_slider.dart';

class TodoDetailUrgencyImportanceCard extends StatelessWidget {
  const TodoDetailUrgencyImportanceCard({
    super.key,
    required this.todoData,
  });

  final Todo todoData;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(
        top: defaultPaddingS,
        bottom: defaultPaddingM / 4,
        left: defaultPaddingS,
        right: defaultPaddingS,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(defaultBorderRadiusM),
        color: white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (todoData.urgency >= 5 && todoData.importance >= 5)
            Text(
              'Do',
              style: CustomTextStyle.title2.copyWith(color: red),
            )
          else if (todoData.urgency >= 5 && todoData.importance < 5)
            Text(
              'Delegate',
              style: CustomTextStyle.title2.copyWith(color: blue),
            )
          else if (todoData.urgency < 5 && todoData.importance >= 5)
              Text(
                'Schedule',
                style: CustomTextStyle.title2.copyWith(color: orange),
              )
            else
              Text(
                'Eliminate',
                style: CustomTextStyle.title2,
              ),
          const Gap(defaultGapM),
          Text(
            '긴급도: ${todoData.urgency.toInt()}',
            style: CustomTextStyle.body2,
          ),
          const Gap(defaultGapS / 2),
          CustomSlider(
            value: todoData.urgency,
            isEnabled: false,
          ),
          const Gap(defaultGapM),
          Text(
            '중요도: ${todoData.importance.toInt()}',
            style: CustomTextStyle.body2,
          ),
          const Gap(defaultGapS / 2),
          CustomSlider(
            value: todoData.importance,
            isEnabled: false,
          ),
        ],
      ),
    );
  }
}