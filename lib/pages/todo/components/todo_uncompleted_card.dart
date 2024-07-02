import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:plus_todo/data/todo_data.dart';
import 'package:plus_todo/provider/filter/provider_filtered_index.dart';
import 'package:plus_todo/provider/todo/provider_todo.dart';
import 'package:plus_todo/themes/custom_color.dart';
import 'package:plus_todo/themes/custom_decoration.dart';
import 'package:plus_todo/themes/custom_font.dart';
import 'package:plus_todo/widgets/custom_divider.dart';

class TodoUncompletedCard extends ConsumerWidget {
  final String title;
  final String subtitle;
  final Color color;
  final bool isDoCard;
  final int filteredIndex;
  final bool Function(TodoData) filteredTodoData;

  const TodoUncompletedCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.color,
    this.isDoCard = false,
    required this.filteredIndex,
    required this.filteredTodoData,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todoData = ref.watch(todoListProvider);
    final filteredData = todoData.where(filteredTodoData).toList();

    if (filteredIndex == 1) {
      filteredData.sort(
        (a, b) {
          int compareUrgency = b.urgency.compareTo(a.urgency);
          if (compareUrgency != 0) {
            return compareUrgency;
          }
          return b.importance.compareTo(a.importance);
        },
      );
    } else if (filteredIndex == 2) {
      filteredData.sort(
        (a, b) {
          int compareImportance = b.importance.compareTo(a.importance);
          if (compareImportance != 0) {
            return compareImportance;
          }
          return b.urgency.compareTo(a.urgency);
        },
      );
    } else if (filteredIndex == 3) {}

    return Container(
      padding: const EdgeInsets.all(defaultPaddingS),
      width: double.infinity,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(defaultBorderRadiusM),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: CustomTextStyle.title2.copyWith(color: color),
                  ),
                  const Gap(defaultGapS / 4),
                  Text(
                    subtitle,
                    style: CustomTextStyle.caption2,
                  ),
                ],
              ),
              if (filteredIndex == 1 && isDoCard)
                InkWell(
                  onTap: () => ref.read(filteredIndexProvider.notifier).state = 2,
                  child: Text(
                    '긴급도 우선 정렬',
                    style: CustomTextStyle.caption2,
                  ),
                )
              else if (filteredIndex == 2 && isDoCard)
                InkWell(
                  onTap: () => ref.read(filteredIndexProvider.notifier).state = 1,
                  child: Text(
                    '중요도 우선 정렬',
                    style: CustomTextStyle.caption2,
                  ),
                ),
            ],
          ),
          const CustomDivider(color: gray),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (context, index) => const Gap(defaultGapS),
            itemCount: filteredData.length,
            itemBuilder: (context, index) {
              final todoList = filteredData[index];
              final originalIndex = todoData.indexOf(todoList);
              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Checkbox(
                    value: todoList.isDone,
                    onChanged: (bool? value) {
                      Future.delayed(
                        const Duration(milliseconds: 100),
                        () {
                          ref.read(todoListProvider.notifier).completeTodo(originalIndex, ref);
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              duration: const Duration(seconds: 1),
                              content: Center(
                                child: Text(
                                  '할 일을 완료했어요.',
                                  style: CustomTextStyle.body3.copyWith(color: white),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: const VisualDensity(
                      horizontal: VisualDensity.minimumDensity,
                      vertical: VisualDensity.minimumDensity,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(defaultBorderRadiusM),
                    ),
                    activeColor: black,
                    checkColor: white,
                  ),
                  const Gap(defaultGapM),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          todoList.title,
                          style: CustomTextStyle.body2,
                          softWrap: true,
                        ),
                        Text(
                          '긴급도: ${todoList.urgency.toInt()}  중요도: ${todoList.importance.toInt()}',
                          style: CustomTextStyle.caption2,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
          if (filteredData.isEmpty)
            Text(
              '할 일이 없어요.',
              style: CustomTextStyle.body3,
            ),
        ],
      ),
    );
  }
}
