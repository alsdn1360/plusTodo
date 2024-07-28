import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plus_todo/providers/calendar/calendar_date_provider.dart';
import 'package:plus_todo/providers/calendar/calendar_week_setting.dart';
import 'package:plus_todo/themes/custom_color.dart';
import 'package:plus_todo/themes/custom_decoration.dart';
import 'package:plus_todo/themes/custom_font.dart';

class CalendarTodayButton extends ConsumerWidget {
  const CalendarTodayButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final saturdayHighlight = ref.watch(calendarWeekSettingProvider.select((value) => value['saturdayHighlight']));
    final sundayHighlight = ref.watch(calendarWeekSettingProvider.select((value) => value['sundayHighlight']));

    return InkWell(
      onTap: () {
        ref.read(calendarFocusedDateProvider.notifier).state = DateTime.now();
        ref.read(calendarSelectedDateProvider.notifier).state = DateTime.now();
        ref.read(calendarLastedSelectedDateProvider.notifier).state = DateTime.now();
      },
      child: Container(
        width: 24,
        height: 24,
        margin: const EdgeInsets.only(right: defaultPaddingM),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(defaultBorderRadiusL / 4),
          border: Border.all(
            color: black,
            width: 1.5,
          ),
        ),
        child: Center(
          child: Text(
            DateTime.now().day.toString(),
            style: CustomTextStyle.caption1.copyWith(
              color: DateTime.now().weekday == DateTime.sunday && sundayHighlight
                  ? red
                  : DateTime.now().weekday == DateTime.saturday && saturdayHighlight
                      ? blue
                      : black,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
