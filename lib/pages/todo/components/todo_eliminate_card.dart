import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:plus_todo/provider/todo/provider_todo.dart';
import 'package:plus_todo/themes/custom_color.dart';
import 'package:plus_todo/themes/custom_decoration.dart';
import 'package:plus_todo/themes/custom_font.dart';
import 'package:plus_todo/widgets/custom_divider.dart';

class TodoEliminateCard extends ConsumerWidget {
  const TodoEliminateCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todoData = ref.watch(todoListProvider);
    final eliminateData = todoData.where((todoData) => todoData.urgency < 5 && todoData.importance < 5).toList();

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
            'Eliminate',
            style: CustomTextStyle.title2,
          ),
          const Gap(defaultGapS / 4),
          Text(
            '긴급하지도 중요하지도 않은 일',
            style: CustomTextStyle.caption2.copyWith(color: darkGray),
          ),
          const CustomDivider(color: gray),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (context, index) => const Gap(defaultGapS),
            itemCount: eliminateData.length,
            itemBuilder: (context, index) {
              final todoList = eliminateData[index];
              final originalIndex = todoData.indexOf(todoList);
              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Checkbox(
                    value: todoList.isDone,
                    onChanged: (bool? value) => ref.read(todoListProvider.notifier).completeTodo(originalIndex, ref),
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
                        todoList.title,
                        style: CustomTextStyle.body2,
                      ),
                      Text(
                        '긴급도: ${todoList.urgency.toInt()}  중요도: ${todoList.importance.toInt()}',
                        style: CustomTextStyle.caption2,
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
          if (eliminateData.isEmpty)
            Text(
              '항목이 없습니다.',
              style: CustomTextStyle.body3.copyWith(color: darkGray),
            ),
        ],
      ),
    );
  }
}
