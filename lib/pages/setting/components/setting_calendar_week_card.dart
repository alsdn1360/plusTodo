import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

    final List<Map<String, dynamic>> dropdownItems = [
      {'label': '월요일', 'value': 1},
      {'label': '일요일', 'value': 7},
    ];

    return Container(
      padding: const EdgeInsets.all(defaultPaddingS),
      width: double.infinity,
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(defaultBorderRadiusM),
        border: Border.all(color: gray.withOpacity(0.2), width: 0.3),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  '시작 요일',
                  style: CustomTextStyle.title3,
                ),
              ),
              const Gap(defaultGapXL),
              SizedBox(
                height: 20.h,
                child: DropdownButton<int>(
                  isExpanded: false,
                  value: startingWeekday,
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
                      (startingWeekday == 1)
                          ? {
                              ref.read(calendarWeekSettingProvider.notifier).changeStartingWeekday(7),
                              GeneralSnackBar.showSnackBar(context, '이제 캘린더가 일요일부터 시작돼요.'),
                            }
                          : {
                              ref.read(calendarWeekSettingProvider.notifier).changeStartingWeekday(1),
                              GeneralSnackBar.showSnackBar(context, '이제 캘린더가 월요일부터 시작돼요.'),
                            };
                    }
                  },
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
                child: Text(
                  '주말 강조 표시',
                  style: CustomTextStyle.title3,
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
                  height: 20.h,
                  width: 20.w,
                  decoration: BoxDecoration(
                    color: saturdayHighlight ? blue : lightGray,
                    borderRadius: BorderRadius.circular(defaultBorderRadiusM / 3),
                  ),
                  child: Center(
                    child: Text(
                      '토',
                      style: CustomTextStyle.body1.copyWith(color: saturdayHighlight ? white : gray),
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
                  height: 20.h,
                  width: 20.w,
                  decoration: BoxDecoration(
                    color: sundayHighlight ? red : lightGray,
                    borderRadius: BorderRadius.circular(defaultBorderRadiusM / 3),
                  ),
                  child: Center(
                    child: Text(
                      '일',
                      style: CustomTextStyle.body1.copyWith(color: sundayHighlight ? white : gray),
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
