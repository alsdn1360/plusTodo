import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:plus_todo/models/todo.dart';
import 'package:plus_todo/pages/todo/components/todo_completed_card.dart';
import 'package:plus_todo/pages/todo/components/todo_completed_list.dart';
import 'package:plus_todo/pages/todo/components/todo_filter_text_button.dart';
import 'package:plus_todo/pages/todo/components/todo_list_or_card_popup_menu_button.dart';
import 'package:plus_todo/pages/todo/components/todo_uncompleted_card.dart';
import 'package:plus_todo/pages/todo/components/todo_uncompleted_list.dart';
import 'package:plus_todo/providers/filtered/filtered_show_completed_provider.dart';
import 'package:plus_todo/providers/filtered/filtered_show_list_or_card.dart';
import 'package:plus_todo/providers/filtered/filtered_sorting_index_provider.dart';
import 'package:plus_todo/themes/custom_color.dart';
import 'package:plus_todo/themes/custom_decoration.dart';

class TodoPage extends ConsumerWidget {
  const TodoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showCompleted = ref.watch(filteredShowCompletedProvider);
    final sortingIndex = ref.watch(filteredSortingIndexProvider);
    final listOrCard = ref.watch(filteredShowListOrCardProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('할 일 목록'),
        actions: const [TodoListOrCardPopupMenuButton()],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: defaultPaddingM),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const TodoFilterTextButton(),
                const Gap(defaultGapM),
                if (listOrCard == 1)
                  Column(
                    // 목록 보기
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TodoUncompletedList(filteredIndex: sortingIndex),
                      Visibility(
                        visible: showCompleted,
                        child: const TodoCompletedList(),
                      ),
                    ],
                  )
                else
                  Column(
                    // 카드 보기
                    children: [
                      TodoUncompletedCard(
                        title: 'Do',
                        subtitle: '긴급하고 중요한 일',
                        color: red,
                        isDoOrEliminateCard: true,
                        filteredIndex: sortingIndex,
                        filteredTodoData: (Todo doData) => doData.urgency >= 5 && doData.importance >= 5,
                      ),
                      const Gap(defaultGapM),
                      // 긴급도 우선 정렬일 때
                      Visibility(
                        visible: sortingIndex == 1,
                        child: TodoUncompletedCard(
                          title: 'Delegate',
                          subtitle: '긴급하지만 중요하진 않은 일',
                          color: blue,
                          filteredIndex: 1,
                          filteredTodoData: (Todo delegateData) => delegateData.urgency >= 5 && delegateData.importance < 5,
                        ),
                      ),
                      Visibility(
                        visible: sortingIndex == 2,
                        child: TodoUncompletedCard(
                          title: 'Schedule',
                          subtitle: '긴급하진 않지만 중요한 일',
                          color: orange,
                          filteredIndex: 2,
                          filteredTodoData: (Todo scheduleData) => scheduleData.urgency < 5 && scheduleData.importance >= 5,
                        ),
                      ),
                      const Gap(defaultGapM),
                      // 중요도 우선 정렬일 때
                      Visibility(
                        visible: sortingIndex == 1,
                        child: TodoUncompletedCard(
                          title: 'Schedule',
                          subtitle: '긴급하진 않지만 중요한 일',
                          color: orange,
                          filteredIndex: 2,
                          filteredTodoData: (Todo scheduleData) => scheduleData.urgency < 5 && scheduleData.importance >= 5,
                        ),
                      ),
                      Visibility(
                        visible: sortingIndex == 2,
                        child: TodoUncompletedCard(
                          title: 'Delegate',
                          subtitle: '긴급하지만 중요하진 않은 일',
                          color: blue,
                          filteredIndex: 1,
                          filteredTodoData: (Todo delegateData) => delegateData.urgency >= 5 && delegateData.importance < 5,
                        ),
                      ),
                      const Gap(defaultGapM),
                      TodoUncompletedCard(
                        title: 'Eliminate',
                        subtitle: '긴급하지도 중요하지도 않은 일',
                        color: green,
                        isDoOrEliminateCard: true,
                        filteredIndex: sortingIndex,
                        filteredTodoData: (Todo eliminateData) => eliminateData.urgency < 5 && eliminateData.importance < 5,
                      ),
                      // 완료된 할 일 보기 선택 했을 때 토글
                      Visibility(
                        visible: showCompleted,
                        child: const Column(
                          children: [
                            Gap(defaultGapM),
                            TodoCompletedCard(),
                          ],
                        ),
                      ),
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
