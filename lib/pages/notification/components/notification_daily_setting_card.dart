import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:plus_todo/functions/general_format_time.dart';
import 'package:plus_todo/functions/general_snack_bar.dart';
import 'package:plus_todo/functions/general_time_picker.dart';
import 'package:plus_todo/notification/notification.dart';
import 'package:plus_todo/providers/notification/notification_daily_porvider.dart';
import 'package:plus_todo/providers/todo/todo_provider.dart';
import 'package:plus_todo/themes/custom_color.dart';
import 'package:plus_todo/themes/custom_decoration.dart';
import 'package:plus_todo/themes/custom_font.dart';

class NotificationDailySettingCard extends ConsumerWidget {
  const NotificationDailySettingCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dailyNotificationTime = ref.watch(notificationDailyProvider);
    final todoNotifier = ref.read(todoProvider.notifier);

    return Container(
      padding: const EdgeInsets.all(defaultPaddingS),
      width: double.infinity,
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(defaultBorderRadiusM),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '오늘 해야 할 일 알림 시간',
                      style: CustomTextStyle.title3,
                    ),
                    Text(
                      '매일 오늘 해야 할 일의 개수를 알려줍니다.',
                      style: CustomTextStyle.caption1,
                    ),
                  ],
                ),
              ),
              const Gap(defaultGapXL),
              CupertinoSwitch(
                value: dailyNotificationTime['isNotification'],
                onChanged: (value) async {
                  await ref.read(notificationDailyProvider.notifier).toggleDailyNotification(value);
                  if (value) {
                    await todoNotifier.enabledDailyNotificationSettings();
                  } else {
                    await cancelNotification(0);
                  }
                },
              ),
            ],
          ),
          Visibility(
            visible: dailyNotificationTime['isNotification'],
            child: InkWell(
              onTap: () {
                GeneralTimePicker.showTimePicker(
                  context: context,
                  initialTime: TimeOfDay(hour: dailyNotificationTime['hour'], minute: dailyNotificationTime['minute']),
                  onTimeSelected: (TimeOfDay? newTime) {
                    if (newTime != null) {
                      ref.read(notificationDailyProvider.notifier).setDailyNotificationTime(newTime.hour, newTime.minute);
                      ref.read(todoProvider.notifier).enabledDailyNotificationSettings();
                      GeneralSnackBar.showSnackBar(
                        context,
                        '이제 ${GeneralFormatTime.formatTime(DateTime(2000, 2, 10, newTime.hour, newTime.minute))}에 오늘 해야 할 일 알림이 울려요.',
                      );
                    }
                  },
                );
              },
              child: Container(
                padding: const EdgeInsets.only(top: defaultGapM),
                width: double.infinity,
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    GeneralFormatTime.formatTime(DateTime(2000, 2, 10, dailyNotificationTime['hour'], dailyNotificationTime['minute'])),
                    style: CustomTextStyle.body1,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
