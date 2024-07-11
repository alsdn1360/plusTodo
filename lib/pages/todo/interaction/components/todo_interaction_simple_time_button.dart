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
          _buildTimeButton('30분 후', 0, 30),
          const Gap(defaultGapM),
          _buildTimeButton('1시간 후', 1, 0),
          const Gap(defaultGapM),
          _buildTimeButton('2시간 후', 2, 0),
          const Gap(defaultGapM),
          _buildTimeButton('3시간 후', 3, 0),
          const Gap(defaultGapM),
          _buildTimeButton('6시간 후', 6, 0),
          const Gap(defaultGapM),
          _buildTimeButton('12시간 후', 12, 0),
        ],
      ),
    );
  }

  Widget _buildTimeButton(String content, int afterHours, int afterMinutes) {
    return InkWell(
      onTap: () {
        final now = TimeOfDay.now();
        final newHour = (now.hour + afterHours + (now.minute + afterMinutes) ~/ 60) % 24;
        final newMinute = (now.minute + afterMinutes) % 60;
        onTimeSelected(TimeOfDay(hour: newHour, minute: newMinute));
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
