import 'package:flutter/material.dart';
import 'package:plus_todo/themes/custom_font.dart';

class TodoInteractionBottomButton extends StatelessWidget {
  final void Function() onTap;

  const TodoInteractionBottomButton({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: SizedBox(
          height: 56,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => Navigator.pop(context),
                  child: SizedBox(
                    width: double.infinity,
                    child: Center(
                      child: Text('취소', style: CustomTextStyle.title3),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () => onTap(),
                  child: SizedBox(
                    width: double.infinity,
                    child: Center(
                      child: Text('저장', style: CustomTextStyle.title3),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
