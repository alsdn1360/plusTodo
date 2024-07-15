import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:plus_todo/themes/custom_color.dart';
import 'package:plus_todo/themes/custom_decoration.dart';
import 'package:plus_todo/themes/custom_font.dart';
import 'package:plus_todo/widgets/custom_slider.dart';

class TodoInteractionUrgencyImportanceCard extends StatelessWidget {
  final double urgency;
  final double importance;
  final ValueChanged<double> onUrgencyChanged;
  final ValueChanged<double> onImportanceChanged;

  const TodoInteractionUrgencyImportanceCard({
    super.key,
    required this.urgency,
    required this.importance,
    required this.onUrgencyChanged,
    required this.onImportanceChanged,
  });

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
        color: (urgency >= 5 && importance >= 5)
            ? red.withOpacity(0.1)
            : (urgency >= 5 && importance < 5)
                ? blue.withOpacity(0.1)
                : (urgency < 5 && importance >= 5)
                    ? orange.withOpacity(0.1)
                    : green.withOpacity(0.1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(
            visible: urgency >= 5 && importance >= 5,
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
            visible: urgency >= 5 && importance < 5,
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
            visible: urgency < 5 && importance >= 5,
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
            visible: urgency < 5 && importance < 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Eliminate', style: CustomTextStyle.title2.copyWith(color: green)),
                const Gap(defaultGapS / 4),
                Text('긴급하지도 중요하지도 않은 일', style: CustomTextStyle.caption1),
              ],
            ),
          ),
          const Gap(defaultGapM),
          Text(
            '긴급도: ${urgency.toInt()}',
            style: CustomTextStyle.body1,
          ),
          CustomSlider(
            value: urgency,
            color: sliderColor(urgency, importance),
            onChanged: onUrgencyChanged,
          ),
          Text(
            '중요도: ${importance.toInt()}',
            style: CustomTextStyle.body1,
          ),
          CustomSlider(
            value: importance,
            color: sliderColor(urgency, importance),
            onChanged: onImportanceChanged,
          ),
        ],
      ),
    );
  }

  Color sliderColor(double urgency, double importance) {
    if (urgency >= 5 && importance >= 5) {
      return red;
    } else if (urgency >= 5 && importance < 5) {
      return blue;
    } else if (urgency < 5 && importance >= 5) {
      return orange;
    } else {
      return green;
    }
  }
}
