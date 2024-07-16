import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:plus_todo/functions/general_snack_bar.dart';
import 'package:plus_todo/providers/notification/notification_provider.dart';
import 'package:plus_todo/providers/todo/todo_provider.dart';
import 'package:plus_todo/themes/custom_color.dart';
import 'package:plus_todo/themes/custom_decoration.dart';
import 'package:plus_todo/themes/custom_font.dart';

class NotificationSettingCard extends ConsumerWidget {
  const NotificationSettingCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationTime = ref.watch(notificationProvider);

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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '마감 전 알림 시간',
                    style: CustomTextStyle.title3,
                  ),
                  Text(
                    '할 일의 마감 시간 전에 알림을 보냅니다.',
                    style: CustomTextStyle.caption1,
                  ),
                ],
              ),
              Text(
                _formatNotificationTime(notificationTime),
                style: CustomTextStyle.body1,
              ),
            ],
          ),
          const Gap(defaultGapM),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildNotificationTimeButton(context, ref, '마감 시간', 0),
                const Gap(defaultGapM),
                _buildNotificationTimeButton(context, ref, '5분 전', 5),
                const Gap(defaultGapM),
                _buildNotificationTimeButton(context, ref, '10분 전', 10),
                const Gap(defaultGapM),
                _buildNotificationTimeButton(context, ref, '30분 전', 30),
                const Gap(defaultGapM),
                _buildNotificationTimeButton(context, ref, '1시간 전', 60),
                const Gap(defaultGapM),
                _buildNotificationTimeButton(context, ref, '3시간 전', 180),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationTimeButton(
    BuildContext context,
    WidgetRef ref,
    String content,
    int minutesBefore,
  ) {
    bool isSelected = ref.watch(notificationProvider) == minutesBefore;
    return InkWell(
      onTap: () {
        ref.read(notificationProvider.notifier).updateNotificationTime(minutesBefore);
        ref.read(todoProvider.notifier).updateNotificationSettings(minutesBefore);
        ref.read(todoProvider.notifier).updateNotificationForAllTodos(minutesBefore);
        if (minutesBefore == 0) {
          GeneralSnackBar.showSnackBar(context, '이제 마감 시간에 알림이 울려요.');
        } else {
          GeneralSnackBar.showSnackBar(context, '이제 마감 시간 ${_formatNotificationTime(minutesBefore)}에 알림이 울려요.');
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: defaultPaddingL / 2,
          vertical: defaultPaddingL / 4,
        ),
        decoration: BoxDecoration(
          color: isSelected ? black : black.withOpacity(0.1),
          borderRadius: BorderRadius.circular(defaultBorderRadiusL / 2),
        ),
        child: Center(
          child: Text(
            content,
            style: isSelected ? CustomTextStyle.body3.copyWith(color: white, fontWeight: FontWeight.w600) : CustomTextStyle.body3,
          ),
        ),
      ),
    );
  }

  String _formatNotificationTime(int minutesBefore) {
    int hours = minutesBefore ~/ 60;
    if (minutesBefore == 0) {
      return '마감 시간';
    } else if (minutesBefore < 60) {
      return '$minutesBefore분 전';
    } else {
      return '$hours시간 전';
    }
  }
}
