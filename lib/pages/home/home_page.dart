import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:plus_todo/models/todo.dart';
import 'package:plus_todo/pages/home/components/home_matrix.dart';
import 'package:plus_todo/pages/home/components/home_summary.dart';
import 'package:plus_todo/pages/todo/components/todo_uncompleted_card.dart';
import 'package:plus_todo/providers/filtered/filtered_home_card_provider.dart';
import 'package:plus_todo/providers/filtered/filtered_sorting_index_provider.dart';
import 'package:plus_todo/providers/todo/todo_uncompleted_provider.dart';
import 'package:plus_todo/themes/custom_color.dart';
import 'package:plus_todo/themes/custom_decoration.dart';
import 'package:plus_todo/themes/custom_font.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todoData = ref.watch(todoUncompletedProvider);
    final filteredHomeCardIndex = ref.watch(filteredHomeCardIndexProvider);

    return Scaffold(
      appBar: AppBar(
        title: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: '+',
                style: CustomTextStyle.header1.copyWith(
                  fontFamily: 'Prentendard',
                  fontFeatures: [const FontFeature.superscripts()],
                ),
              ),
              TextSpan(
                text: 'Todo',
                style: CustomTextStyle.header1,
              ),
            ],
          ),
        ),
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
            onSelected: (value) => ref.read(filteredHomeCardIndexProvider.notifier).toggleFilteredHomeCardIndex(value),
            itemBuilder: (context) => <PopupMenuEntry>[
              PopupMenuItem(
                value: 0,
                child: Text(
                  'Do 목록 보기',
                  style: CustomTextStyle.body3,
                ),
              ),
              PopupMenuItem(
                value: 1,
                child: Text(
                  'Delegate 목록 보기',
                  style: CustomTextStyle.body3,
                ),
              ),
              PopupMenuItem(
                value: 2,
                child: Text(
                  'Schedule 목록 보기',
                  style: CustomTextStyle.body3,
                ),
              ),
              PopupMenuItem(
                value: 3,
                child: Text(
                  'Eliminate 목록 보기',
                  style: CustomTextStyle.body3,
                ),
              ),
              PopupMenuItem(
                value: 4,
                child: Text(
                  '목록 숨기기',
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
                HomeMatrix(todoData: todoData),
                const Gap(defaultGapL),
                const HomeSummary(),
                const Gap(defaultGapL),
                GestureDetector(
                  onHorizontalDragEnd: (details) {
                    if (details.primaryVelocity! < 0) {
                      ref.read(filteredHomeCardIndexProvider.notifier).toggleFilteredHomeCardIndex((filteredHomeCardIndex % 4) + 1);
                    } else if (details.primaryVelocity! > 0) {
                      ref.read(filteredHomeCardIndexProvider.notifier).toggleFilteredHomeCardIndex((filteredHomeCardIndex % 4) - 1);
                    }
                  },
                  child: IndexedStack(
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
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
