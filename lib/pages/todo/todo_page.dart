import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:plus_todo/models/todo.dart';
import 'package:plus_todo/pages/todo/components/todo_completed_card.dart';
import 'package:plus_todo/pages/todo/components/todo_uncompleted_card.dart';
import 'package:plus_todo/providers/filtered/filtered_show_completed_provider.dart';
import 'package:plus_todo/providers/filtered/filtered_sorting_index_provider.dart';
import 'package:plus_todo/themes/custom_color.dart';
import 'package:plus_todo/themes/custom_decoration.dart';
import 'package:plus_todo/themes/custom_font.dart';

class TodoPage extends ConsumerWidget {
  const TodoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showCompleted = ref.watch(filteredShowCompletedProvider);
    final sortingIndex = ref.watch(filteredSortingIndexProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('할 일 목록'),
        actions: [
          PopupMenuButton(
            elevation: 1,
            color: white,
            surfaceTintColor: white,
            icon: const Icon(Icons.more_vert_rounded, color: black),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(defaultBorderRadiusM),
            ),
            padding: const EdgeInsets.all(defaultPaddingS),
            onSelected: (value) => ref.read(filteredShowCompletedProvider.notifier).toggleFilteredShow(value),
            itemBuilder: (context) => <PopupMenuEntry>[
              PopupMenuItem(
                value: true,
                child: Text(
                  '완료된 할 일 목록 보기',
                  style: CustomTextStyle.body3,
                ),
              ),
              PopupMenuItem(
                value: false,
                child: Text(
                  '완료된 할 일 목록 숨기기',
                  style: CustomTextStyle.body3,
                ),
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: defaultPaddingM),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () => (sortingIndex == 1)
                      ? ref.read(filteredSortingIndexProvider.notifier).toggleFilteredIndex(2)
                      : ref.read(filteredSortingIndexProvider.notifier).toggleFilteredIndex(1),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        (sortingIndex == 1) ? '긴급도 우선 정렬' : '중요도 우선 정렬',
                        style: CustomTextStyle.caption2,
                      ),
                      const Gap(defaultGapS),
                      const Icon(Icons.swap_vert_rounded, color: black, size: 16),
                    ],
                  ),
                ),
                const Gap(defaultGapL),
                TodoUncompletedCard(
                  title: 'Do',
                  subtitle: '긴급하고 중요한 일',
                  color: red,
                  isDoOrEliminateCard: true,
                  filteredIndex: sortingIndex,
                  filteredTodoData: (Todo doData) => doData.urgency >= 5 && doData.importance >= 5,
                ),
                const Gap(defaultGapL),
                if (sortingIndex == 1)
                  Column(
                    children: [
                      TodoUncompletedCard(
                        title: 'Delegate',
                        subtitle: '긴급하지만 중요하진 않은 일',
                        color: blue,
                        filteredIndex: 1,
                        filteredTodoData: (Todo delegateData) => delegateData.urgency >= 5 && delegateData.importance < 5,
                      ),
                      const Gap(defaultGapL),
                      TodoUncompletedCard(
                        title: 'Schedule',
                        subtitle: '긴급하진 않지만 중요한 일',
                        color: orange,
                        filteredIndex: 2,
                        filteredTodoData: (Todo scheduleData) => scheduleData.urgency < 5 && scheduleData.importance >= 5,
                      ),
                    ],
                  )
                else if (sortingIndex == 2)
                  Column(
                    children: [
                      TodoUncompletedCard(
                        title: 'Schedule',
                        subtitle: '긴급하진 않지만 중요한 일',
                        color: orange,
                        filteredIndex: 2,
                        filteredTodoData: (Todo scheduleData) => scheduleData.urgency < 5 && scheduleData.importance >= 5,
                      ),
                      const Gap(defaultGapL),
                      TodoUncompletedCard(
                        title: 'Delegate',
                        subtitle: '긴급하지만 중요하진 않은 일',
                        color: blue,
                        filteredIndex: 1,
                        filteredTodoData: (Todo delegateData) => delegateData.urgency >= 5 && delegateData.importance < 5,
                      ),
                    ],
                  ),
                const Gap(defaultGapL),
                TodoUncompletedCard(
                  title: 'Eliminate',
                  subtitle: '긴급하지도 중요하지도 않은 일',
                  color: green,
                  isDoOrEliminateCard: true,
                  filteredIndex: sortingIndex,
                  filteredTodoData: (Todo eliminateData) => eliminateData.urgency < 5 && eliminateData.importance < 5,
                ),
                if (showCompleted)
                  const Column(
                    children: [
                      Gap(defaultGapL),
                      TodoCompletedCard(),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
