import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:plus_todo/providers/todo/todo_uncompleted_provider.dart';
import 'package:plus_todo/themes/custom_color.dart';
import 'package:plus_todo/themes/custom_decoration.dart';
import 'package:plus_todo/themes/custom_font.dart';
import 'package:plus_todo/widgets/custom_divider.dart';

class HomeSummary extends ConsumerWidget {
  const HomeSummary({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todoData = ref.watch(todoUncompletedProvider);
    final doData = todoData.where((doData) => doData.urgency >= 5 && doData.importance >= 5).toList();
    final delegateData = todoData.where((delegateData) => delegateData.urgency >= 5 && delegateData.importance < 5).toList();
    final scheduleData = todoData.where((scheduleData) => scheduleData.urgency < 5 && scheduleData.importance >= 5).toList();
    final eliminateData = todoData.where((eliminateData) => eliminateData.urgency < 5 && eliminateData.importance < 5).toList();

    return Container(
      padding: const EdgeInsets.all(defaultPaddingS),
      width: double.infinity,
      decoration: BoxDecoration(
        color: darkWhite,
        borderRadius: BorderRadius.circular(defaultBorderRadiusM),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '남은 할 일 수',
            style: CustomTextStyle.title2,
          ),
          const Gap(defaultGapS),
          const CustomDivider(),
          const Gap(defaultGapS),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Do', style: CustomTextStyle.body1.copyWith(color: red)),
                  const Gap(defaultGapS / 2),
                  Text('${doData.length}', style: CustomTextStyle.body2),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Delegate', style: CustomTextStyle.body1.copyWith(color: blue)),
                  const Gap(defaultGapS / 2),
                  Text('${delegateData.length}', style: CustomTextStyle.body2),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Schedule', style: CustomTextStyle.body1.copyWith(color: orange)),
                  const Gap(defaultGapS / 2),
                  Text('${scheduleData.length}', style: CustomTextStyle.body2),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Eliminate', style: CustomTextStyle.body1.copyWith(color: green)),
                  const Gap(defaultGapS / 2),
                  Text('${eliminateData.length}', style: CustomTextStyle.body2),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
