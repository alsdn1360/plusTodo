import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:plus_todo/models/todo.dart';
import 'package:plus_todo/pages/todo/components/todo_urgency_importance_card.dart';
import 'package:plus_todo/pages/todo/detail/todo_detail_completed_page.dart';
import 'package:plus_todo/providers/todo/todo_completed_provider.dart';
import 'package:plus_todo/providers/todo/todo_provider.dart';
import 'package:plus_todo/themes/custom_color.dart';
import 'package:plus_todo/themes/custom_decoration.dart';
import 'package:plus_todo/themes/custom_font.dart';
import 'package:plus_todo/widgets/custom_dialog.dart';
import 'package:plus_todo/widgets/custom_divider.dart';

class TodoCompletedCard extends ConsumerWidget {
  const TodoCompletedCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final completedTodoData = ref.watch(todoCompletedProvider);

    return Container(
      padding: const EdgeInsets.all(defaultPaddingS),
      width: double.infinity,
      decoration: BoxDecoration(
        color: gray.withOpacity(0.1),
        borderRadius: BorderRadius.circular(defaultBorderRadiusM),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '완료된 할 일',
                style: CustomTextStyle.title2,
              ),
              const Spacer(),
              Text(
                '${completedTodoData.length}개,',
                style: (completedTodoData.isEmpty) ? CustomTextStyle.caption2.copyWith(color: gray) : CustomTextStyle.caption2,
              ),
              const Gap(defaultGapS),
              InkWell(
                onTap: () => (completedTodoData.isEmpty)
                    ? null
                    : showDialog(
                        context: context,
                        builder: (context) => CustomDialog(
                          title: '완료된 일을 모두 삭제할까요?',
                          onTap: () => _clearCompletedTodo(ref, context),
                        ),
                      ),
                child: Text(
                  '모두 삭제',
                  style: (completedTodoData.isEmpty) ? CustomTextStyle.caption2.copyWith(color: gray) : CustomTextStyle.caption2,
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
            itemCount: completedTodoData.length,
            itemBuilder: (context, index) {
              final completedTodoList = completedTodoData[index];
              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Checkbox(
                    value: completedTodoList.isDone,
                    onChanged: (bool? value) => _onCheck(context, ref, completedTodoList.id),
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
                      onTap: () => _pushDetailPage(context, completedTodoList),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            completedTodoList.title,
                            style: CustomTextStyle.body2.copyWith(decoration: TextDecoration.lineThrough),
                            softWrap: true,
                          ),
                          Text(
                            '${completedTodoList.deadline!.year}년 ${completedTodoList.deadline!.month}월 ${completedTodoList.deadline!.day}일 (${_getDayOfWeek(completedTodoList.deadline!.weekday)}) '
                            '${_formatTime(completedTodoList.deadline!)}',
                            style: CustomTextStyle.body3.copyWith(decoration: TextDecoration.lineThrough),
                          ),
                          const Gap(defaultGapS / 4),
                          Row(
                            children: [
                              TodoUrgencyImportanceCard(
                                color: gray.withOpacity(0.6),
                                content: '긴급도: ${completedTodoList.urgency.toInt()}',
                                isCompleted: true,
                              ),
                              const Gap(defaultGapS / 2),
                              TodoUrgencyImportanceCard(
                                color: gray.withOpacity(0.6),
                                content: '중요도: ${completedTodoList.importance.toInt()}',
                                isCompleted: true,
                              ),
                            ],
                          ),
                          if (index != completedTodoData.length - 1)
                            const Column(
                              children: [
                                Gap(defaultGapM / 2),
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
          if (completedTodoData.isEmpty)
            Text(
              '완료된 일이 없어요.',
              style: CustomTextStyle.body3,
            ),
        ],
      ),
    );
  }

  String _getDayOfWeek(int day) {
    switch (day) {
      case 1:
        return '월';
      case 2:
        return '화';
      case 3:
        return '수';
      case 4:
        return '목';
      case 5:
        return '금';
      case 6:
        return '토';
      case 7:
        return '일';
      default:
        return '';
    }
  }

  String _formatTime(DateTime time) {
    final hours = time.hour % 12 == 0 ? 12 : time.hour % 12;
    final period = time.hour < 12 ? '오전' : '오후';
    final minutes = time.minute.toString().padLeft(2, '0');
    return '$period $hours:$minutes';
  }

  void _clearCompletedTodo(WidgetRef ref, BuildContext context) {
    ref.read(todoProvider.notifier).clearCompletedTodo();
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 1),
        content: Center(
          child: Text(
            '완료된 일을 모두 삭제했어요.',
            style: CustomTextStyle.body3.copyWith(color: white),
          ),
        ),
      ),
    );
  }

  void _onCheck(BuildContext context, WidgetRef ref, int id) {
    ref.read(todoProvider.notifier).toggleTodo(id);
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 1),
        content: Center(
          child: Text(
            '완료된 일을 다시 되돌렸어요.',
            style: CustomTextStyle.body3.copyWith(color: white),
          ),
        ),
      ),
    );
  }

  Future<dynamic> _pushDetailPage(BuildContext context, Todo completedTodoList) {
    return Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => TodoDetailCompletedPage(todoData: completedTodoList),
      ),
    );
  }
}
