import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:plus_todo/functions/general_format_time.dart';
import 'package:plus_todo/functions/general_snack_bar.dart';
import 'package:plus_todo/models/todo.dart';
import 'package:plus_todo/pages/todo/components/todo_urgency_importance_card.dart';
import 'package:plus_todo/pages/todo/detail/todo_detail_uncompleted_page.dart';
import 'package:plus_todo/pages/todo/interaction/todo_interaction_create_page.dart';
import 'package:plus_todo/providers/todo/todo_daily_provider.dart';
import 'package:plus_todo/providers/todo/todo_provider.dart';
import 'package:plus_todo/themes/custom_color.dart';
import 'package:plus_todo/themes/custom_decoration.dart';
import 'package:plus_todo/themes/custom_font.dart';
import 'package:plus_todo/widgets/custom_divider.dart';

class TodoDailyCard extends ConsumerWidget {
  const TodoDailyCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dailyTodoData = ref.watch(todoDailyProvider);
    final sortedTodoData = dailyTodoData.where((todo) => todo.deadline != null).toList()..sort((a, b) => a.deadline!.compareTo(b.deadline!));

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
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('오늘 해야 할 일', style: CustomTextStyle.title2),
              InkWell(
                onTap: () => Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => TodoInteractionCreatePage(initialSelectedDate: DateTime.now()),
                  ),
                ),
                child: Text(
                  '새로운 오늘 할 일',
                  style: CustomTextStyle.caption1,
                ),
              ),
            ],
          ),
          const Gap(defaultGapS),
          const CustomDivider(),
          const Gap(defaultGapS),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (context, index) => const Gap(defaultGapS / 2),
            itemCount: sortedTodoData.length,
            itemBuilder: (context, index) {
              final dailyTodoList = sortedTodoData[index];
              final isDeadlineSoon = dailyTodoList.deadline != null && dailyTodoList.deadline!.isBefore(DateTime.now());

              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Checkbox(
                    value: dailyTodoList.isDone,
                    onChanged: (bool? value) => _onCheck(context, ref, dailyTodoList.id),
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
                      onTap: () => _pushDetailPage(context, dailyTodoList),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            dailyTodoList.title,
                            style: CustomTextStyle.body2,
                            softWrap: true,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${GeneralFormatTime.formatDate(dailyTodoList.deadline!)} '
                                '${GeneralFormatTime.formatTime(dailyTodoList.deadline!)}',
                                style: isDeadlineSoon
                                    ? CustomTextStyle.body3.copyWith(color: red, letterSpacing: 0.2)
                                    : CustomTextStyle.body3.copyWith(letterSpacing: 0.2),
                              ),
                              const Gap(defaultGapS),
                              Visibility(
                                visible: isDeadlineSoon,
                                child: Text(
                                  '미뤄진 일',
                                  style: CustomTextStyle.body3.copyWith(color: red, letterSpacing: 0.2),
                                ),
                              ),
                            ],
                          ),
                          const Gap(defaultGapS / 4),
                          Row(
                            children: [
                              TodoUrgencyImportanceCard(
                                color: urgencyImportanceColor(dailyTodoList.urgency, dailyTodoList.importance),
                                content: '긴급도: ${dailyTodoList.urgency.toInt()}',
                              ),
                              const Gap(defaultGapS),
                              TodoUrgencyImportanceCard(
                                color: urgencyImportanceColor(dailyTodoList.urgency, dailyTodoList.importance),
                                content: '중요도: ${dailyTodoList.importance.toInt()}',
                              ),
                            ],
                          ),
                          if (index != sortedTodoData.length - 1)
                            const Column(
                              children: [
                                Gap(defaultGapS),
                                CustomDivider(),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          if (sortedTodoData.isEmpty)
            Text(
              '할 일이 없어요.',
              style: CustomTextStyle.body3,
            ),
        ],
      ),
    );
  }

  Color urgencyImportanceColor(double urgency, double importance) {
    if (urgency >= 5 && importance >= 5) {
      return red;
    } else if (urgency >= 5 && importance < 5) {
      return blue;
    } else if (urgency < 5 && importance >= 5) {
      return orange;
    } else {
      return green;
    }
  }

  void _onCheck(BuildContext context, WidgetRef ref, int id) {
    ref.read(todoProvider.notifier).toggleTodo(id);
    GeneralSnackBar.showSnackBar(context, '할 일을 완료했어요.');
  }

  Future<dynamic> _pushDetailPage(BuildContext context, Todo dailyTodoData) {
    return Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => TodoDetailUncompletedPage(todoData: dailyTodoData),
      ),
    );
  }
}
