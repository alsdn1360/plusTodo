import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:plus_todo/themes/custom_color.dart';
import 'package:plus_todo/themes/custom_decoration.dart';
import 'package:plus_todo/themes/custom_font.dart';

class TodoInteractionSimpleDateButton extends StatelessWidget {
  final Function(DateTime) onDateSelected;

  const TodoInteractionSimpleDateButton({
    super.key,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildDateButton('오늘', 0),
          const Gap(defaultGapM),
          _buildDateButton('내일', 1),
          const Gap(defaultGapM),
          _buildDateButton('모레', 2),
          const Gap(defaultGapM),
          _buildDateButton('1주 후', 7),
          const Gap(defaultGapM),
          _buildDateButton('2주 후', 14),
          const Gap(defaultGapM),
          _buildDateButton('1개월 후', 30),
        ],
      ),
    );
  }

  Widget _buildDateButton(String content, int afterDate) {
    return InkWell(
      onTap: () => onDateSelected(DateTime.now().add(Duration(days: afterDate))),
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
