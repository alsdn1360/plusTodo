import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:plus_todo/themes/custom_color.dart';
import 'package:plus_todo/themes/custom_decoration.dart';
import 'package:plus_todo/themes/custom_font.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final void Function() onTap;

  const CustomDialog({
    super.key,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 1,
      backgroundColor: white,
      surfaceTintColor: white,
      alignment: Alignment.bottomCenter,
      insetAnimationCurve: Curves.easeOutQuad,
      insetAnimationDuration: const Duration(milliseconds: 200),
      insetPadding: const EdgeInsets.only(
        left: defaultPaddingM,
        right: defaultPaddingM,
        bottom: defaultPaddingM,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(defaultBorderRadiusM),
      ),
      child: Container(
        padding: const EdgeInsets.all(defaultPaddingL),
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: CustomTextStyle.body2,
            ),
            const Gap(defaultGapXL),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Text(
                    '취소',
                    style: CustomTextStyle.title3,
                  ),
                ),
                Container(width: 0.5, height: 15, color: gray),
                InkWell(
                  onTap: () {
                    onTap();
                    Navigator.pop(context);
                  },
                  child: Text(
                    '삭제',
                    style: CustomTextStyle.title3,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
