import 'package:flutter/cupertino.dart';
import 'package:plus_todo/themes/custom_color.dart';
import 'package:plus_todo/themes/custom_decoration.dart';
import 'package:plus_todo/themes/custom_font.dart';

class GeneralDatePicker {
  static void showDatePicker({
    required BuildContext context,
    required initialDate,
    required ValueChanged<DateTime?> onDateSelected,
  }) {
    DateTime? tempPickedDate = initialDate;

    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height / 3,
          width: double.infinity,
          decoration: const BoxDecoration(
            color: white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(defaultBorderRadiusM),
              topRight: Radius.circular(defaultBorderRadiusM),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: defaultPaddingS),
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 5,
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date,
                    initialDateTime: initialDate ?? DateTime.now(),
                    minimumYear: 2024,
                    onDateTimeChanged: (DateTime newDateTime) {
                      tempPickedDate = newDateTime;
                    },
                  ),
                ),
                CupertinoButton(
                  onPressed: () {
                    onDateSelected(tempPickedDate);
                    Navigator.pop(context);
                  },
                  child: Text(
                    '확인',
                    style: CustomTextStyle.title3,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
