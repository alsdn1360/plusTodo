import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:plus_todo/models/todo.dart';
import 'package:plus_todo/pages/home/components/home_summary_count.dart';
import 'package:plus_todo/providers/filtered/filtered_sorting_index_provider.dart';
import 'package:plus_todo/themes/custom_color.dart';
import 'package:plus_todo/themes/custom_decoration.dart';
import 'package:plus_todo/themes/custom_font.dart';
import 'package:plus_todo/widgets/custom_divider.dart';

class HomeSummary extends ConsumerWidget {
  const HomeSummary({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int filteredSortingIndex = ref.watch(filteredSortingIndexProvider);

    return Container(
      padding: const EdgeInsets.all(defaultPaddingS),
      width: double.infinity,
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(defaultBorderRadiusM),
        border: Border.all(color: gray.withOpacity(0.2), width: 0.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('남은 할 일 수', style: CustomTextStyle.title3),
          const Gap(defaultGapS),
          const CustomDivider(),
          const Gap(defaultGapS),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              HomeSummaryCount(
                title: 'Do',
                color: red,
                filteredTodoData: (Todo doData) => doData.urgency >= 5 && doData.importance >= 5,
              ),
              HomeSummaryCount(
                title: (filteredSortingIndex == 1) ? 'Delegate' : 'Schedule',
                color: (filteredSortingIndex == 1) ? blue : orange,
                filteredTodoData: (filteredSortingIndex == 1)
                    ? (Todo delegateData) => delegateData.urgency >= 5 && delegateData.importance < 5
                    : (Todo scheduleData) => scheduleData.urgency < 5 && scheduleData.importance >= 5,
              ),
              HomeSummaryCount(
                title: (filteredSortingIndex == 2) ? 'Delegate' : 'Schedule',
                color: (filteredSortingIndex == 2) ? blue : orange,
                filteredTodoData: (filteredSortingIndex == 2)
                    ? (Todo delegateData) => delegateData.urgency >= 5 && delegateData.importance < 5
                    : (Todo scheduleData) => scheduleData.urgency < 5 && scheduleData.importance >= 5,
              ),
              HomeSummaryCount(
                title: 'Eliminate',
                color: green,
                filteredTodoData: (Todo eliminateData) => eliminateData.urgency < 5 && eliminateData.importance < 5,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
