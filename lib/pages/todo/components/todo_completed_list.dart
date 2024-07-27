import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:plus_todo/functions/general_format_time.dart';
import 'package:plus_todo/functions/general_snack_bar.dart';
import 'package:plus_todo/models/todo.dart';
import 'package:plus_todo/pages/todo/components/todo_urgency_importance_card.dart';
import 'package:plus_todo/pages/todo/detail/todo_detail_completed_page.dart';
import 'package:plus_todo/providers/todo/todo_completed_provider.dart';
import 'package:plus_todo/providers/todo/todo_provider.dart';
import 'package:plus_todo/themes/custom_color.dart';
import 'package:plus_todo/themes/custom_decoration.dart';
import 'package:plus_todo/themes/custom_font.dart';
import 'package:plus_todo/widgets/custom_dialog.dart';

class TodoCompletedList extends ConsumerWidget {
  const TodoCompletedList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final completedTodoData = ref.watch(todoCompletedProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Gap(defaultGapM),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Text(
                '완료된 할 일',
                style: CustomTextStyle.title2,
              ),
            ),
            Text(
              '${completedTodoData.length}개,',
              style: (completedTodoData.isEmpty) ? CustomTextStyle.caption1.copyWith(color: gray) : CustomTextStyle.caption1,
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(Icons.delete_forever_outlined, color: (completedTodoData.isEmpty) ? gray : black, size: 14),
                  const Gap(defaultGapS / 4),
                  Text(
                    '모두 삭제',
                    style: (completedTodoData.isEmpty) ? CustomTextStyle.caption1.copyWith(color: gray) : CustomTextStyle.caption1,
                  ),
                ],
              ),
            ),
          ],
        ),
        const Gap(defaultGapM),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          separatorBuilder: (context, index) => const Gap(defaultGapM),
          itemCount: completedTodoData.length,
          itemBuilder: (context, index) {
            final completedTodoList = completedTodoData[index];

            return Container(
              padding: const EdgeInsets.all(defaultPaddingS),
              width: double.infinity,
              decoration: BoxDecoration(
                color: gray.withOpacity(0.1),
                borderRadius: BorderRadius.circular(defaultBorderRadiusM),
              ),
              child: Row(
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
                            style: CustomTextStyle.body2.copyWith(color: gray, decoration: TextDecoration.lineThrough),
                            softWrap: true,
                          ),
                          Text(
                            GeneralFormatTime.formatDate(completedTodoList.deadline!),
                            style: CustomTextStyle.body3.copyWith(color: gray, decoration: TextDecoration.lineThrough),
                          ),
                          const Gap(defaultGapS / 4),
                          Row(
                            children: [
                              TodoUrgencyImportanceCard(
                                color: gray,
                                content: '긴급도: ${completedTodoList.urgency.toInt()}',
                                isCompleted: true,
                              ),
                              const Gap(defaultGapS),
                              TodoUrgencyImportanceCard(
                                color: gray,
                                content: '중요도: ${completedTodoList.importance.toInt()}',
                                isCompleted: true,
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
          visible: completedTodoData.isEmpty,
          child: Text(
            '완료된 일이 없어요.',
            style: CustomTextStyle.body3,
          ),
        ),
      ],
    );
  }

  void _clearCompletedTodo(WidgetRef ref, BuildContext context) {
    ref.read(todoProvider.notifier).clearCompletedTodo();
    GeneralSnackBar.showSnackBar(context, '완료된 일을 모두 삭제했어요.');
  }

  void _onCheck(BuildContext context, WidgetRef ref, int id) {
    ref.read(todoProvider.notifier).toggleTodo(id);
    GeneralSnackBar.showSnackBar(context, '완료된 일을 다시 되돌렸어요.');
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
