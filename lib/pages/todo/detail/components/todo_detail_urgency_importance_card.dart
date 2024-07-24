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
        color: cardColor(todoData.urgency, todoData.importance, 0.1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(
            visible: todoData.urgency >= 5 && todoData.importance >= 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Do', style: CustomTextStyle.title2.copyWith(color: red)),
                const Gap(defaultGapS / 4),
                Text('긴급하고 중요한 일', style: CustomTextStyle.caption1),
              ],
            ),
          ),
          Visibility(
            visible: todoData.urgency >= 5 && todoData.importance < 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Delegate', style: CustomTextStyle.title2.copyWith(color: blue)),
                const Gap(defaultGapS / 4),
                Text('긴급하지만 중요하진 않은 일', style: CustomTextStyle.caption1),
              ],
            ),
          ),
          Visibility(
            visible: todoData.urgency < 5 && todoData.importance >= 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Schedule', style: CustomTextStyle.title2.copyWith(color: orange)),
                const Gap(defaultGapS / 4),
                Text('중요하지만 급하지 않은 일', style: CustomTextStyle.caption1),
              ],
            ),
          ),
          Visibility(
            visible: todoData.urgency < 5 && todoData.importance < 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Eliminate', style: CustomTextStyle.title2.copyWith(color: green)),
                const Gap(defaultGapS / 4),
                Text('긴급하지도 중요하지도 않은 일', style: CustomTextStyle.caption1),
              ],
            ),
          ),
          const Gap(defaultGapS),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: defaultPaddingM / 2,
              vertical: defaultPaddingL / 6,
            ),
            decoration: BoxDecoration(
              color: cardColor(todoData.urgency, todoData.importance, 0.6),
              borderRadius: BorderRadius.circular(defaultBorderRadiusL / 3),
            ),
            child: Text(
              '긴급도: ${todoData.urgency.toInt()}',
              style: CustomTextStyle.body1.copyWith(color: white),
            ),
          ),
          CustomSlider(
            value: todoData.urgency,
            color: cardColor(todoData.urgency, todoData.importance, 1),
            isEnabled: false,
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: defaultPaddingM / 2,
              vertical: defaultPaddingL / 6,
            ),
            decoration: BoxDecoration(
              color: cardColor(todoData.urgency, todoData.importance, 0.6),
              borderRadius: BorderRadius.circular(defaultBorderRadiusL / 3),
            ),
            child: Text(
              '중요도: ${todoData.importance.toInt()}',
              style: CustomTextStyle.body1.copyWith(color: white),
            ),
          ),
          CustomSlider(
            value: todoData.importance,
            color: cardColor(todoData.urgency, todoData.importance, 1),
            isEnabled: false,
          ),
        ],
      ),
    );
  }

  Color cardColor(double urgency, double importance, double opacity) {
    if (urgency >= 5 && importance >= 5) {
      return red.withOpacity(opacity);
    } else if (urgency >= 5 && importance < 5) {
      return blue.withOpacity(opacity);
    } else if (urgency < 5 && importance >= 5) {
      return orange.withOpacity(opacity);
    } else {
      return green.withOpacity(opacity);
    }
  }
}
