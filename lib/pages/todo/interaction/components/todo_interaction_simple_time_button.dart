import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:plus_todo/themes/custom_color.dart';
import 'package:plus_todo/themes/custom_decoration.dart';
import 'package:plus_todo/themes/custom_font.dart';

class TodoInteractionSimpleTimeButton extends StatelessWidget {
  final Function(TimeOfDay) onTimeSelected;

  const TodoInteractionSimpleTimeButton({
    super.key,
    required this.onTimeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildTimeButton('오전 6시', 6, 0),
          const Gap(defaultGapM),
          _buildTimeButton('오전 9시', 9, 0),
          const Gap(defaultGapM),
          _buildTimeButton('오후 12시', 12, 0),
          const Gap(defaultGapM),
          _buildTimeButton('오후 3시', 15, 0),
          const Gap(defaultGapM),
          _buildTimeButton('오후 6시', 18, 0),
          const Gap(defaultGapM),
          _buildTimeButton('오후 9시', 21, 0),
          const Gap(defaultGapM),
          _buildTimeButton('오전 12시', 00, 0),
        ],
      ),
    );
  }

  Widget _buildTimeButton(String content, int setHours, int setMinutes) {
    return InkWell(
      onTap: () {
        onTimeSelected(TimeOfDay(hour: setHours, minute: setMinutes));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: defaultPaddingL / 2,
          vertical: defaultPaddingS / 4,
        ),
        decoration: BoxDecoration(
          color: black.withOpacity(0.1),
          borderRadius: BorderRadius.circular(defaultBorderRadiusL / 3),
        ),
        child: Center(
          child: Text(
            content,
            style: CustomTextStyle.body3,
          ),
        ),
      ),
    );
  }
}
