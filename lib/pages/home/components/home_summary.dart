import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:plus_todo/providers/filtered/filtered_sorting_index_provider.dart';
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
        color: white,
        borderRadius: BorderRadius.circular(defaultBorderRadiusM),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('남은 할 일 수', style: CustomTextStyle.title2),
          const Gap(defaultGapS / 2),
          const CustomDivider(),
          const Gap(defaultGapS / 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Flexible(
                flex: 1,
                child: _buildSummaryColumn('Do', '${doData.length}', red),
              ),
              Flexible(
                flex: 1,
                child: _buildSummaryColumn(
                  (ref.watch(filteredSortingIndexProvider) == 1) ? 'Delegate' : 'Schedule',
                  (ref.watch(filteredSortingIndexProvider) == 1) ? '${delegateData.length}' : '${scheduleData.length}',
                  (ref.watch(filteredSortingIndexProvider) == 1) ? blue : orange,
                ),
              ),
              Flexible(
                flex: 1,
                child: _buildSummaryColumn(
                  (ref.watch(filteredSortingIndexProvider) == 2) ? 'Delegate' : 'Schedule',
                  (ref.watch(filteredSortingIndexProvider) == 2) ? '${delegateData.length}' : '${scheduleData.length}',
                  (ref.watch(filteredSortingIndexProvider) == 2) ? blue : orange,
                ),
              ),
              Flexible(
                flex: 1,
                child: _buildSummaryColumn('Eliminate', '${eliminateData.length}', green),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryColumn(String title, String count, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AutoSizeText(
          title,
          style: CustomTextStyle.body1.copyWith(color: color),
          maxLines: 1,
          maxFontSize: 40,
          softWrap: true,
        ),
        const Gap(defaultGapS / 2),
        Text(count, style: CustomTextStyle.body2),
      ],
    );
  }
}
