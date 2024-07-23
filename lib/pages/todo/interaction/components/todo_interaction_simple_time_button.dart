import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:plus_todo/themes/custom_color.dart';
import 'package:plus_todo/themes/custom_decoration.dart';
import 'package:plus_todo/themes/custom_font.dart';

class TodoInteractionSimpleTimeButton extends StatefulWidget {
  final Function(TimeOfDay) onTimeSelected;

  const TodoInteractionSimpleTimeButton({
    super.key,
    required this.onTimeSelected,
  });

  @override
  State<TodoInteractionSimpleTimeButton> createState() => _TodoInteractionSimpleTimeButtonState();
}

class _TodoInteractionSimpleTimeButtonState extends State<TodoInteractionSimpleTimeButton> {
  TimeOfDay? selectedTime;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildTimeButton('오전 6시', 6, 0),
          const Gap(defaultGapS),
          _buildTimeButton('오전 9시', 9, 0),
          const Gap(defaultGapS),
          _buildTimeButton('오후 12시', 12, 0),
          const Gap(defaultGapS),
          _buildTimeButton('오후 3시', 15, 0),
          const Gap(defaultGapS),
          _buildTimeButton('오후 6시', 18, 0),
          const Gap(defaultGapS),
          _buildTimeButton('오후 9시', 21, 0),
        ],
      ),
    );
  }

  Widget _buildTimeButton(String content, int setHours, int setMinutes) {
    TimeOfDay time = TimeOfDay(hour: setHours, minute: setMinutes);
    bool isSelected = (selectedTime != null && selectedTime == time);

    return InkWell(
      onTap: () {
        setState(() {
          selectedTime = TimeOfDay(hour: setHours, minute: setMinutes);
        });
        widget.onTimeSelected(time);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: defaultPaddingM / 2,
          vertical: defaultPaddingL / 6,
        ),
        decoration: BoxDecoration(
          color: isSelected ? black : background,
          borderRadius: BorderRadius.circular(defaultBorderRadiusL / 3),
        ),
        child: Center(
          child: Text(
            content,
            style: isSelected ? CustomTextStyle.body3.copyWith(color: white, fontWeight: FontWeight.w600) : CustomTextStyle.body3.copyWith(color: gray),
          ),
        ),
      ),
    );
  }
}
