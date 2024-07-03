import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:plus_todo/data/todo_data.dart';
import 'package:plus_todo/provider/todo/provider_uncompleted_todo.dart';
import 'package:plus_todo/themes/custom_color.dart';
import 'package:plus_todo/themes/custom_decoration.dart';
import 'package:plus_todo/themes/custom_font.dart';
import 'package:plus_todo/widgets/custom_slider.dart';

class TodoUncompletedDetailPage extends ConsumerWidget {
  final TodoData todoData;
  final int originalIndex;

  const TodoUncompletedDetailPage({
    super.key,
    required this.todoData,
    required this.originalIndex,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            bottom: defaultPaddingM,
            left: defaultPaddingM,
            right: defaultPaddingM,
          ),
          child: Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {},
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(defaultPaddingS),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(defaultBorderRadiusM),
                        color: darkWhite,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            todoData.title,
                            style: CustomTextStyle.body1,
                            softWrap: true,
                          ),
                          if (todoData.content.isNotEmpty)
                            Column(
                              children: [
                                const Gap(defaultGapM),
                                Text(
                                  todoData.content,
                                  style: CustomTextStyle.body2,
                                  softWrap: true,
                                ),
                              ],
                            )
                        ],
                      ),
                    ),
                  ),
                  const Gap(defaultGapL),
                  InkWell(
                    onTap: () {},
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(
                        top: defaultPaddingS,
                        bottom: defaultPaddingM / 4,
                        left: defaultPaddingS,
                        right: defaultPaddingS,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(defaultBorderRadiusM),
                        color: darkWhite,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (todoData.urgency >= 5 && todoData.importance >= 5)
                            Text(
                              'Do',
                              style: CustomTextStyle.title2.copyWith(color: red),
                            )
                          else if (todoData.urgency >= 5 && todoData.importance < 5)
                            Text(
                              'Delegate',
                              style: CustomTextStyle.title2.copyWith(color: blue),
                            )
                          else if (todoData.urgency < 5 && todoData.importance >= 5)
                            Text(
                              'Schedule',
                              style: CustomTextStyle.title2.copyWith(color: orange),
                            )
                          else
                            Text(
                              'Eliminate',
                              style: CustomTextStyle.title2,
                            ),
                          const Gap(defaultGapL),
                          Text(
                            '긴급도: ${todoData.urgency.toInt()}',
                            style: CustomTextStyle.body2,
                          ),
                          const Gap(defaultGapS / 2),
                          CustomSlider(
                            value: todoData.urgency,
                            isEnabled: false,
                          ),
                          const Gap(defaultGapL),
                          Text(
                            '중요도: ${todoData.importance.toInt()}',
                            style: CustomTextStyle.body2,
                          ),
                          const Gap(defaultGapS / 2),
                          CustomSlider(
                            value: todoData.importance,
                            isEnabled: false,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: SizedBox(
            height: 56,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => _completeTodo(originalIndex, context, ref),
                    child: SizedBox(
                      width: double.infinity,
                      child: Center(
                        child: Column(
                          children: [
                            const Icon(Icons.check_outlined, color: black),
                            const Gap(defaultGapS / 4),
                            Text('할 일 완료', style: CustomTextStyle.caption2),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {},
                    child: SizedBox(
                      width: double.infinity,
                      child: Center(
                        child: Column(
                          children: [
                            const Icon(Icons.edit_outlined, color: black),
                            const Gap(defaultGapS / 4),
                            Text('편집', style: CustomTextStyle.caption2),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () => _deleteUncompletedTodo(originalIndex, context, ref),
                    child: SizedBox(
                      width: double.infinity,
                      child: Center(
                        child: Column(
                          children: [
                            const Icon(Icons.delete_outlined, color: black),
                            const Gap(defaultGapS / 4),
                            Text('삭제', style: CustomTextStyle.caption2),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _completeTodo(int index, BuildContext context, WidgetRef ref) {
    ref.read(uncompletedTodoListProvider.notifier).completeTodo(originalIndex, ref);
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
    Navigator.pop(context);
  }

  void _deleteUncompletedTodo(int index, BuildContext context, WidgetRef ref) {
    ref.read(uncompletedTodoListProvider.notifier).deleteUncompletedTodoAt(index);
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 1),
        content: Center(
          child: Text(
            '할 일을 삭제했어요.',
            style: CustomTextStyle.body3.copyWith(color: white),
          ),
        ),
      ),
    );
    Navigator.pop(context);
  }
}
