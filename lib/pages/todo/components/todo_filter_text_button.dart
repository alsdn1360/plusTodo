import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:plus_todo/functions/general_snack_bar.dart';
import 'package:plus_todo/providers/filtered/filtered_show_completed_provider.dart';
import 'package:plus_todo/providers/filtered/filtered_sorting_index_provider.dart';
import 'package:plus_todo/themes/custom_color.dart';
import 'package:plus_todo/themes/custom_decoration.dart';
import 'package:plus_todo/themes/custom_font.dart';

class TodoFilterTextButton extends ConsumerWidget {
  const TodoFilterTextButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showCompleted = ref.watch(filteredShowCompletedProvider);
    final sortingIndex = ref.watch(filteredSortingIndexProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        InkWell(
          onTap: () => (showCompleted)
              ? {
                  ref.read(filteredShowCompletedProvider.notifier).toggleFilteredShow(false),
                  GeneralSnackBar.showSnackBar(context, '이제 완료된 할 일이 안 보여요.'),
                }
              : {
                  ref.read(filteredShowCompletedProvider.notifier).toggleFilteredShow(true),
                  GeneralSnackBar.showSnackBar(context, '이제 완료된 할 일이 보여요.'),
                },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon((showCompleted) ? Icons.visibility_rounded : Icons.visibility_off_rounded, color: black, size: 14),
              const Gap(defaultGapS / 2),
              Text(
                (showCompleted) ? '완료된 할 일 보기' : '완료된 할 일 숨기기',
                style: CustomTextStyle.caption1,
              ),
            ],
          ),
        ),
        const Gap(defaultGapS / 2),
        Container(width: 0.5, height: 15, color: gray),
        const Gap(defaultGapS / 2),
        InkWell(
          onTap: () => (sortingIndex == 1)
              ? {
                  ref.read(filteredSortingIndexProvider.notifier).toggleFilteredIndex(2),
                  GeneralSnackBar.showSnackBar(context, '이제 중요한 일이 먼저 보여요.'),
                }
              : {
                  ref.read(filteredSortingIndexProvider.notifier).toggleFilteredIndex(1),
                  GeneralSnackBar.showSnackBar(context, '이제 긴급한 일이 먼저 보여요.'),
                },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Icon(Icons.swap_vert_rounded, color: black, size: 14),
              const Gap(defaultGapS / 2),
              Text(
                (sortingIndex == 1) ? '긴급도 우선 정렬' : '중요도 우선 정렬',
                style: CustomTextStyle.caption1,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
