import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:plus_todo/pages/notification/components/notification_daily_setting_card.dart';
import 'package:plus_todo/pages/notification/components/notification_setting_card.dart';
import 'package:plus_todo/themes/custom_decoration.dart';
import 'package:plus_todo/themes/custom_font.dart';

class NotificationSettingPage extends ConsumerWidget {
  const NotificationSettingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              const NotificationSettingCard(),
              const Gap(defaultGapL),
              const NotificationDailySettingCard(),
            ],
          ),
        ),
      ),
    );
  }
}
