import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plus_todo/models/todo.dart';
import 'package:plus_todo/pages/todo/components/todo_uncompleted_card.dart';
import 'package:plus_todo/providers/filtered/filtered_home_card_provider.dart';
import 'package:plus_todo/providers/filtered/filtered_sorting_index_provider.dart';
import 'package:plus_todo/themes/custom_color.dart';

class HomeIndexCard extends ConsumerWidget {
  final int filteredHomeCardIndex;

  const HomeIndexCard({
    super.key,
    required this.filteredHomeCardIndex,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity! < 0) {
          ref.read(filteredHomeCardIndexProvider.notifier).toggleFilteredHomeCardIndex((filteredHomeCardIndex % 4) + 1);
        } else if (details.primaryVelocity! > 0) {
          ref.read(filteredHomeCardIndexProvider.notifier).toggleFilteredHomeCardIndex((filteredHomeCardIndex % 4) - 1);
        }
      },
      child: (filteredHomeCardIndex != 4) ? IndexedStack(
        index: filteredHomeCardIndex % 4,
        children: [
          TodoUncompletedCard(
            title: 'Do',
            subtitle: '긴급하고 중요한 일',
            color: red,
            isDoOrEliminateCard: true,
            filteredIndex: ref.watch(filteredSortingIndexProvider),
            filteredTodoData: (Todo doData) => doData.urgency >= 5 && doData.importance >= 5,
          ),
          TodoUncompletedCard(
            title: 'Delegate',
            subtitle: '긴급하지만 중요하진 않은 일',
            color: blue,
            filteredIndex: ref.watch(filteredSortingIndexProvider),
            filteredTodoData: (Todo delegateData) => delegateData.urgency >= 5 && delegateData.importance < 5,
          ),
          TodoUncompletedCard(
            title: 'Schedule',
            subtitle: '중요하지만 급하지 않은 일',
            color: orange,
            filteredIndex: ref.watch(filteredSortingIndexProvider),
            filteredTodoData: (Todo scheduleData) => scheduleData.urgency < 5 && scheduleData.importance >= 5,
          ),
          TodoUncompletedCard(
            title: 'Eliminate',
            subtitle: '긴급하지도 중요하지도 않은 일',
            color: green,
            isDoOrEliminateCard: true,
            filteredIndex: ref.watch(filteredSortingIndexProvider),
            filteredTodoData: (Todo eliminateData) => eliminateData.urgency < 5 && eliminateData.importance < 5,
          ),
        ],
      ) :
          Container(),
    );
  }
}
