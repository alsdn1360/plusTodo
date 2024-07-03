import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:plus_todo/data/todo_data.dart';
import 'package:plus_todo/pages/todo/detail/todo_detail_completed_page.dart';
import 'package:plus_todo/provider/todo/todo_completed_provider.dart';
import 'package:plus_todo/themes/custom_color.dart';
import 'package:plus_todo/themes/custom_decoration.dart';
import 'package:plus_todo/themes/custom_font.dart';
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
        color: darkWhite,
        borderRadius: BorderRadius.circular(defaultBorderRadiusM),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '완료된 할 일',
                style: CustomTextStyle.title2,
              ),
              InkWell(
                onTap: () => _clearCompletedTodo(ref, context),
                child: Text(
                  '모두 삭제',
                  style: completedTodoData.isEmpty
                      ? CustomTextStyle.caption2.copyWith(color: gray)
                      : CustomTextStyle.caption2,
                ),
              ),
            ],
          ),
          const Gap(defaultGapS / 4),
          const CustomDivider(color: gray),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (context, index) => const Gap(defaultGapS),
            itemCount: completedTodoData.length,
            itemBuilder: (context, index) {
              final completedTodoList = completedTodoData[index];
              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Checkbox(
                    value: completedTodoList.isDone,
                    onChanged: (bool? value) => _onCheck(ref, index, context),
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
                      onTap: () => _pushDetailPage(context, completedTodoList, index),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            completedTodoList.title,
                            style: CustomTextStyle.body2.copyWith(decoration: TextDecoration.lineThrough),
                            softWrap: true,
                          ),
                          Text(
                            '긴급도: ${completedTodoList.urgency.toInt()}  중요도: ${completedTodoList.importance.toInt()}',
                            style: CustomTextStyle.caption2.copyWith(decoration: TextDecoration.lineThrough),
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

  Future<void> _clearCompletedTodo(WidgetRef ref, BuildContext context) async {
    ref.read(todoCompletedProvider.notifier).clearCompletedTodo();
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

  Future<void> _onCheck(WidgetRef ref, int index, BuildContext context) async {
    ref.read(todoCompletedProvider.notifier).undoCompletedTodo(index, ref);
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

  Future _pushDetailPage(BuildContext context, TodoData completedTodoList, int index) {
    return Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => TodoDetailCompletedPage(
          todoData: completedTodoList,
          index: index,
        ),
      ),
    );
  }
}
