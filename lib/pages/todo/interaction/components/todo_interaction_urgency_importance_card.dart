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
        color: white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (urgency >= 5 && importance >= 5)
            Text('Do', style: CustomTextStyle.title2.copyWith(color: red))
          else if (urgency >= 5 && importance < 5)
            Text('Delegate', style: CustomTextStyle.title2.copyWith(color: blue))
          else if (urgency < 5 && importance >= 5)
            Text('Schedule', style: CustomTextStyle.title2.copyWith(color: orange))
          else
            Text('Eliminate', style: CustomTextStyle.title2.copyWith(color: green)),
          const Gap(defaultGapM),
          Text(
            '긴급도: ${urgency.toInt()}',
            style: CustomTextStyle.body1,
          ),
          const Gap(defaultGapS / 2),
          CustomSlider(
            value: urgency,
            onChanged: onUrgencyChanged,
          ),
          const Gap(defaultGapM),
          Text(
            '중요도: ${importance.toInt()}',
            style: CustomTextStyle.body1,
          ),
          const Gap(defaultGapS / 2),
          CustomSlider(
            value: importance,
            onChanged: onImportanceChanged,
          ),
        ],
      ),
    );
  }
}
