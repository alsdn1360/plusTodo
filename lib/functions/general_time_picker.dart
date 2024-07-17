import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plus_todo/themes/custom_color.dart';
import 'package:plus_todo/themes/custom_decoration.dart';
import 'package:plus_todo/themes/custom_font.dart';

class GeneralTimePicker {
  static void showTimePicker({
    required BuildContext context,
    required TimeOfDay? initialTime,
    required ValueChanged<TimeOfDay?> onTimeSelected,
    int minuteInterval = 5,
  }) {
    TimeOfDay? tempPickedTime = initialTime;

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
            padding: const EdgeInsets.only(top: defaultPaddingL),
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 5,
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.time,
                    initialDateTime: DateTime(2000, 2, 10, initialTime?.hour ?? DateTime.now().hour, initialTime?.minute ?? DateTime.now().minute),
                    minuteInterval: minuteInterval,
                    onDateTimeChanged: (DateTime newDateTime) {
                      tempPickedTime = TimeOfDay(hour: newDateTime.hour, minute: newDateTime.minute);
                    },
                  ),
                ),
                CupertinoButton(
                  onPressed: () {
                    if (tempPickedTime != null) {
                      onTimeSelected(tempPickedTime!);
                    }
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
