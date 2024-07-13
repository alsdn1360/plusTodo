import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:plus_todo/themes/custom_color.dart';
import 'package:plus_todo/themes/custom_decoration.dart';
import 'package:plus_todo/themes/custom_font.dart';

class TodoDetailBottomButton extends StatelessWidget {
  final void Function() onTap;
  final IconData icon;
  final String content;

  const TodoDetailBottomButton({
    super.key,
    required this.onTap,
    required this.icon,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () => onTap(),
        child: SizedBox(
          width: double.infinity,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: black),
                const Gap(defaultGapS / 4),
                Text(content, style: CustomTextStyle.caption1),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
