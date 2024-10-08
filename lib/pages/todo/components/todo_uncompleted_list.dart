import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:plus_todo/functions/general_snack_bar.dart';
import 'package:plus_todo/models/todo.dart';
import 'package:plus_todo/pages/todo/components/todo_urgency_importance_card.dart';
import 'package:plus_todo/pages/todo/detail/todo_detail_uncompleted_page.dart';
import 'package:plus_todo/functions/general_format_time.dart';
import 'package:plus_todo/providers/todo/todo_provider.dart';
import 'package:plus_todo/providers/todo/todo_uncompleted_provider.dart';
import 'package:plus_todo/themes/custom_color.dart';
import 'package:plus_todo/themes/custom_decoration.dart';
import 'package:plus_todo/themes/custom_font.dart';

class TodoUncompletedList extends ConsumerWidget {
  final int filteredIndex;

  const TodoUncompletedList({
    super.key,
    required this.filteredIndex,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uncompletedTodoData = ref.watch(todoUncompletedProvider).toList();

    if (filteredIndex == 1) {
      uncompletedTodoData.sort(
        (a, b) {
          int compareUrgency = b.urgency.compareTo(a.urgency);
          if (compareUrgency != 0) {
            return compareUrgency;
          }
          return b.importance.compareTo(a.importance);
        },
      );
    } else if (filteredIndex == 2) {
      uncompletedTodoData.sort(
        (a, b) {
          int compareImportance = b.importance.compareTo(a.importance);
          if (compareImportance != 0) {
            return compareImportance;
          }
          return b.urgency.compareTo(a.urgency);
        },
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '해야 할 일',
          style: CustomTextStyle.title2,
        ),
        const Gap(defaultGapM),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          separatorBuilder: (context, index) => const Gap(defaultGapM),
          itemCount: uncompletedTodoData.length,
          itemBuilder: (context, index) {
            final uncompletedTodoList = uncompletedTodoData[index];
            final isDeadlineSoon = uncompletedTodoList.deadline != null && uncompletedTodoList.deadline!.isBefore(DateTime.now());

            return Container(
              padding: const EdgeInsets.all(defaultPaddingS),
              width: double.infinity,
              decoration: BoxDecoration(
                color: urgencyImportanceColor(uncompletedTodoList.urgency, uncompletedTodoList.importance, 0.1),
                borderRadius: BorderRadius.circular(defaultBorderRadiusM),
                border: Border.all(color: urgencyImportanceColor(uncompletedTodoList.urgency, uncompletedTodoList.importance, 0.2), width: 0.2),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Checkbox(
                    value: uncompletedTodoList.isDone,
                    onChanged: (bool? value) => _onCheck(context, ref, uncompletedTodoList.id),
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
                    child: InkWell(
                      onTap: () => _pushDetailPage(context, uncompletedTodoList),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            uncompletedTodoList.title,
                            style: CustomTextStyle.body2,
                            softWrap: true,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(GeneralFormatTime.formatDate(uncompletedTodoList.deadline!),
                                  style: isDeadlineSoon ? CustomTextStyle.body3.copyWith(color: red) : CustomTextStyle.body3),
                              const Gap(defaultGapS),
                              Visibility(
                                visible: isDeadlineSoon,
                                child: Text(
                                  '미뤄진 일',
                                  style: CustomTextStyle.body3.copyWith(color: red),
                                ),
                              ),
                            ],
                          ),
                          const Gap(defaultGapS / 4),
                          Row(
                            children: [
                              TodoUrgencyImportanceCard(
                                color: urgencyImportanceColor(uncompletedTodoList.urgency, uncompletedTodoList.importance, 1),
                                content: '긴급도: ${uncompletedTodoList.urgency.toInt()}',
                              ),
                              const Gap(defaultGapS),
                              TodoUrgencyImportanceCard(
                                color: urgencyImportanceColor(uncompletedTodoList.urgency, uncompletedTodoList.importance, 1),
                                content: '중요도: ${uncompletedTodoList.importance.toInt()}',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        Visibility(
          visible: uncompletedTodoData.isEmpty,
          child: Text(
            '할 일이 없어요.',
            style: CustomTextStyle.body3,
          ),
        ),
      ],
    );
  }

  Color urgencyImportanceColor(double urgency, double importance, double opacity) {
    if (urgency >= 5 && importance >= 5) {
      return red.withOpacity(opacity);
    } else if (urgency >= 5 && importance < 5) {
      return blue.withOpacity(opacity);
    } else if (urgency < 5 && importance >= 5) {
      return orange.withOpacity(opacity);
    } else {
      return green.withOpacity(opacity);
    }
  }

  void _onCheck(BuildContext context, WidgetRef ref, int id) {
    ref.read(todoProvider.notifier).toggleTodo(id);
    GeneralSnackBar.showSnackBar(context, '할 일을 완료했어요.');
  }

  Future<dynamic> _pushDetailPage(BuildContext context, Todo uncompletedTodoList) {
    return Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => TodoDetailUncompletedPage(todoData: uncompletedTodoList),
      ),
    );
  }
}
