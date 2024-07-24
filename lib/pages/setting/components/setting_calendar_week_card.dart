import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:plus_todo/functions/general_snack_bar.dart';
import 'package:plus_todo/providers/calendar/calendar_week_setting.dart';
import 'package:plus_todo/themes/custom_color.dart';
import 'package:plus_todo/themes/custom_decoration.dart';
import 'package:plus_todo/themes/custom_font.dart';
import 'package:plus_todo/widgets/custom_divider.dart';

class SettingCalendarWeekCard extends ConsumerWidget {
  const SettingCalendarWeekCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final startingWeekday = ref.watch(calendarWeekSettingProvider.select((value) => value['startingWeekday']));
    final saturdayHighlight = ref.watch(calendarWeekSettingProvider.select((value) => value['saturdayHighlight']));
    final sundayHighlight = ref.watch(calendarWeekSettingProvider.select((value) => value['sundayHighlight']));

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
                      '캘린더 시작 요일',
                      style: CustomTextStyle.title3,
                    ),
                    Text(
                      '캘린더의 시작 요일을 설정합니다.',
                      style: CustomTextStyle.caption1,
                    ),
                  ],
                ),
              ),
              const Gap(defaultGapXL),
              InkWell(
                onTap: () {
                  (startingWeekday == 1)
                      ? {
                          ref.read(calendarWeekSettingProvider.notifier).changeStartingWeekday(7),
                          GeneralSnackBar.showSnackBar(context, '이제 캘린더가 일요일부터 시작돼요.'),
                        }
                      : {
                          ref.read(calendarWeekSettingProvider.notifier).changeStartingWeekday(1),
                          GeneralSnackBar.showSnackBar(context, '이제 캘린더가 월요일부터 시작돼요.'),
                        };
                },
                child: Text(
                  (startingWeekday == 1) ? '월요일' : '일요일',
                  style: CustomTextStyle.title3,
                ),
              ),
            ],
          ),
          const Gap(defaultGapS),
          const CustomDivider(),
          const Gap(defaultGapS),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '캘린더 강조 표시',
                      style: CustomTextStyle.title3,
                    ),
                    Text(
                      '주말을 강조하여 표시합니다.',
                      style: CustomTextStyle.caption1,
                    ),
                  ],
                ),
              ),
              const Gap(defaultGapXL),
              InkWell(
                onTap: () {
                  (saturdayHighlight)
                      ? {
                          ref.read(calendarWeekSettingProvider.notifier).toggleSaturdayHighlight(false),
                          GeneralSnackBar.showSnackBar(context, '이제 토요일이 강조되지 않아요.'),
                        }
                      : {
                          ref.read(calendarWeekSettingProvider.notifier).toggleSaturdayHighlight(true),
                          GeneralSnackBar.showSnackBar(context, '이제 토요일이 강조되어 보여요.'),
                        };
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: defaultPaddingM / 2, vertical: defaultPaddingL / 4),
                  decoration: BoxDecoration(
                    color: saturdayHighlight ? blue : background,
                    borderRadius: BorderRadius.circular(defaultBorderRadiusL / 2),
                  ),
                  child: Center(
                    child: Text(
                      '토',
                      style: CustomTextStyle.title3.copyWith(color: saturdayHighlight ? white : gray),
                    ),
                  ),
                ),
              ),
              const Gap(defaultGapS),
              InkWell(
                onTap: () {
                  (sundayHighlight)
                      ? {
                          ref.read(calendarWeekSettingProvider.notifier).toggleSundayHighlight(false),
                          GeneralSnackBar.showSnackBar(context, '이제 일요일이 강조되지 않아요.'),
                        }
                      : {
                          ref.read(calendarWeekSettingProvider.notifier).toggleSundayHighlight(true),
                          GeneralSnackBar.showSnackBar(context, '이제 일요일이 강조되어 보여요.'),
                        };
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: defaultPaddingM / 2, vertical: defaultPaddingL / 4),
                  decoration: BoxDecoration(
                    color: sundayHighlight ? red : background,
                    borderRadius: BorderRadius.circular(defaultBorderRadiusL / 2),
                  ),
                  child: Center(
                    child: Text(
                      '일',
                      style: CustomTextStyle.title3.copyWith(color: sundayHighlight ? white : gray),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
