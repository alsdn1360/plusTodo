import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:plus_todo/functions/general_time_picker.dart';
import 'package:plus_todo/providers/notification/notification_daily_porvider.dart';
import 'package:plus_todo/providers/todo/todo_provider.dart';
import 'package:plus_todo/themes/custom_color.dart';
import 'package:plus_todo/themes/custom_decoration.dart';
import 'package:plus_todo/themes/custom_font.dart';

class NotificationSettingPage extends ConsumerStatefulWidget {
  const NotificationSettingPage({super.key});

  @override
  ConsumerState<NotificationSettingPage> createState() => _NotificationSettingPageState();
}

class _NotificationSettingPageState extends ConsumerState<NotificationSettingPage> {
  TimeOfDay? selectedTime;

  @override
  Widget build(BuildContext context) {
    final notificationTime = ref.watch(notificationDailyProvider);

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: defaultPaddingM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('알림 시간 설정', style: CustomTextStyle.header2),
              const Gap(defaultGapL),
              InkWell(
                onTap: () {
                  GeneralTimePicker.showTimePicker(
                    context: context,
                    initialTime: TimeOfDay(hour: notificationTime['hour'], minute: notificationTime['minute']),
                    onTimeSelected: (TimeOfDay? newTime) {
                      if (newTime != null) {
                        ref.read(notificationDailyProvider.notifier).setNotificationTime(newTime.hour, newTime.minute);
                        ref.read(todoProvider.notifier).scheduleDailyTodoCountNotification(newTime.hour, newTime.minute);
                      }
                    },
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(defaultPaddingS),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.circular(defaultBorderRadiusM),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '오늘 해야 할 일 알림 시간',
                            style: CustomTextStyle.title3,
                          ),
                          Text(
                            '매일 해당 시각에 오늘 해야 할 일의 개수를 알려줍니다.',
                            style: CustomTextStyle.caption1,
                          ),
                        ],
                      ),
                      Text(
                        formatTime(notificationTime['hour'], notificationTime['minute']),
                        style: CustomTextStyle.body1,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String formatTime(int hour, int minute) {
    final hours = hour % 12 == 0 ? 12 : hour % 12;
    final period = hour < 12 ? '오전' : '오후';
    final minutes = minute.toString().padLeft(2, '0');
    return '$period $hours:$minutes';
  }
}
