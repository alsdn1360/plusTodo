import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:plus_todo/functions/general_snack_bar.dart';
import 'package:plus_todo/notification/notification.dart';
import 'package:plus_todo/providers/notification/notification_daily_porvider.dart';
import 'package:plus_todo/providers/todo/todo_provider.dart';
import 'package:plus_todo/themes/custom_color.dart';
import 'package:plus_todo/themes/custom_decoration.dart';
import 'package:plus_todo/themes/custom_font.dart';
import 'package:plus_todo/widgets/custom_divider.dart';

class SettingDailyNotificationCard extends ConsumerWidget {
  const SettingDailyNotificationCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dailyNotificationTime = ref.watch(notificationDailyProvider);
    final todoNotifier = ref.read(todoProvider.notifier);

    final List<Map<String, dynamic>> dropdownItems = [
      {'label': '끄기', 'value': 0},
      {'label': '오전 7시', 'value': 7},
      {'label': '오전 8시', 'value': 8},
      {'label': '오전 9시', 'value': 9},
      {'label': '오전 10시', 'value': 10},
      {'label': '오전 11시', 'value': 11}
    ];

    int selectedValue = dailyNotificationTime['isNotification'] ? dailyNotificationTime['hour'] : 0;

    return Container(
      padding: const EdgeInsets.all(defaultPaddingS),
      width: double.infinity,
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(defaultBorderRadiusM),
        border: Border.all(color: gray.withOpacity(0.2), width: 0.2),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              AppSettings.openAppSettings();
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    '권한 설정',
                    style: CustomTextStyle.title3,
                  ),
                ),
                const Gap(defaultGapXL),
                const Icon(Icons.chevron_right_rounded, color: gray),
              ],
            ),
          ),
          const Gap(defaultGapS),
          const CustomDivider(),
          const Gap(defaultGapS),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  '오늘 해야 할 일 알림',
                  style: CustomTextStyle.title3,
                ),
              ),
              const Gap(defaultGapXL),
              SizedBox(
                height: 24.h,
                child: DropdownButton<int>(
                  isExpanded: false,
                  value: selectedValue,
                  elevation: 1,
                  style: CustomTextStyle.body1.copyWith(color: gray),
                  underline: Container(),
                  icon: const Icon(Icons.unfold_more_rounded, color: gray),
                  iconSize: 16,
                  dropdownColor: white,
                  borderRadius: BorderRadius.circular(defaultBorderRadiusM),
                  padding: EdgeInsets.zero,
                  alignment: AlignmentDirectional.centerEnd,
                  items: dropdownItems.map((item) {
                    return DropdownMenuItem<int>(
                      value: item['value'],
                      child: Text(item['label']),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    if (newValue != null) {
                      bool isNotificationEnabled = newValue != 0;
                      ref.read(notificationDailyProvider.notifier).setDailyNotificationTime(isNotificationEnabled ? newValue : 0, 0);
                      if (isNotificationEnabled) {
                        todoNotifier.enabledDailyNotificationSettings();
                        GeneralSnackBar.showSnackBar(
                            context, '이제 ${dropdownItems.firstWhere((item) => item['value'] == newValue)['label']}에 오늘 해야 할 일 알림이 울려요.');
                      } else {
                        cancelNotification(0);
                        GeneralSnackBar.showSnackBar(context, '이제 오늘 해야 할 일 알림이 안 울려요.');
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
