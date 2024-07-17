import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:plus_todo/themes/custom_color.dart';
import 'package:plus_todo/themes/custom_decoration.dart';
import 'package:plus_todo/themes/custom_font.dart';

class TodoInteractionSimpleNotificationButton extends StatefulWidget {
  final Function(int) onNotificationTimeSelected;

  const TodoInteractionSimpleNotificationButton({
    super.key,
    required this.onNotificationTimeSelected,
  });

  @override
  State<TodoInteractionSimpleNotificationButton> createState() => _TodoInteractionSimpleNotificationButtonState();
}

class _TodoInteractionSimpleNotificationButtonState extends State<TodoInteractionSimpleNotificationButton> {
  int? selectedNotificationTime;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildNotificationTimeButton('마감 시간', 0),
          const Gap(defaultGapS),
          _buildNotificationTimeButton('10분 전', 10),
          const Gap(defaultGapS),
          _buildNotificationTimeButton('30분 전', 30),
          const Gap(defaultGapS),
          _buildNotificationTimeButton('1시간 전', 60),
          const Gap(defaultGapS),
          _buildNotificationTimeButton('3시간 전', 180),
        ],
      ),
    );
  }

  Widget _buildNotificationTimeButton(String content, int minuteBefore) {
    bool isSelected = (selectedNotificationTime == minuteBefore);

    return InkWell(
      onTap: () {
        setState(() {
          selectedNotificationTime = minuteBefore;
        });
        widget.onNotificationTimeSelected(minuteBefore);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: defaultPaddingL / 2,
          vertical: defaultPaddingL / 4,
        ),
        decoration: BoxDecoration(
          color: isSelected ? black : black.withOpacity(0.1),
          borderRadius: BorderRadius.circular(defaultBorderRadiusL / 2),
        ),
        child: Center(
          child: Text(
            content,
            style: isSelected ? CustomTextStyle.body3.copyWith(color: white, fontWeight: FontWeight.w600) : CustomTextStyle.body3,
          ),
        ),
      ),
    );
  }
}
