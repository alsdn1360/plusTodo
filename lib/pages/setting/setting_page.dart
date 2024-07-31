import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:plus_todo/pages/setting/components/setting_calendar_week_card.dart';
import 'package:plus_todo/pages/setting/components/setting_daily_notification_card.dart';
import 'package:plus_todo/pages/setting/components/setting_information.dart';
import 'package:plus_todo/themes/custom_decoration.dart';
import 'package:plus_todo/themes/custom_font.dart';

class SettingPage extends ConsumerWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('설정'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: defaultPaddingM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('알림', style: CustomTextStyle.title2),
              const Gap(defaultGapM),
              const SettingDailyNotificationCard(),
              const Gap(defaultGapM),
              Text('캘린더', style: CustomTextStyle.title2),
              const Gap(defaultGapM),
              const SettingCalendarWeekCard(),
              const Gap(defaultGapM),
              Text('앱 정보', style: CustomTextStyle.title2),
              const Gap(defaultGapM),
              const SettingInformation(),
            ],
          ),
        ),
      ),
    );
  }
}
