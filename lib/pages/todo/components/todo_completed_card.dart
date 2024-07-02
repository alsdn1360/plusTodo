import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:plus_todo/provider/todo/provider_complete_todo.dart';
import 'package:plus_todo/themes/custom_color.dart';
import 'package:plus_todo/themes/custom_decoration.dart';
import 'package:plus_todo/themes/custom_font.dart';
import 'package:plus_todo/widgets/custom_divider.dart';

class TodoCompletedCard extends ConsumerWidget {
  const TodoCompletedCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final completedTodoData = ref.watch(completedTodoListProvider);

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
          Text(
            '완료된 할 일',
            style: CustomTextStyle.title2,
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
                    onChanged: (bool? value) =>
                        ref.read(completedTodoListProvider.notifier).undoCompletedTodo(index, ref),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: const VisualDensity(
                      horizontal: VisualDensity.minimumDensity,
                      vertical: VisualDensity.minimumDensity,
                    ),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(defaultBorderRadiusM)),
                    activeColor: darkGray,
                    checkColor: white,
                  ),
                  const Gap(defaultGapS),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        completedTodoList.title,
                        style: CustomTextStyle.body2.copyWith(
                          color: darkGray,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      Text(
                        '긴급도: ${completedTodoList.urgency.toInt()}  중요도: ${completedTodoList.importance.toInt()}',
                        style: CustomTextStyle.caption2.copyWith(
                          color: darkGray,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
          if (completedTodoData.isEmpty)
            Text(
              '항목이 없습니다.',
              style: CustomTextStyle.body3.copyWith(color: darkGray),
            ),
        ],
      ),
    );
  }
}
