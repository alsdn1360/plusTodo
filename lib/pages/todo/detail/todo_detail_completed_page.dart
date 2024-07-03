import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:plus_todo/data/todo_data.dart';
import 'package:plus_todo/pages/todo/detail/components/todo_detail_bottom_button.dart';
import 'package:plus_todo/provider/todo/todo_completed_provider.dart';
import 'package:plus_todo/themes/custom_color.dart';
import 'package:plus_todo/themes/custom_decoration.dart';
import 'package:plus_todo/themes/custom_font.dart';
import 'package:plus_todo/widgets/custom_dialog.dart';
import 'package:plus_todo/widgets/custom_slider.dart';

class TodoDetailCompletedPage extends ConsumerWidget {
  final TodoData todoData;
  final int index;

  const TodoDetailCompletedPage({
    super.key,
    required this.todoData,
    required this.index,
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
                          textAlign: TextAlign.justify,
                        ),
                        if (todoData.content.isNotEmpty)
                          Column(
                            children: [
                              const Gap(defaultGapM),
                              Text(
                                todoData.content,
                                style: CustomTextStyle.body2,
                                softWrap: true,
                                textAlign: TextAlign.justify,
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
                        const Gap(defaultGapM),
                        Text(
                          '긴급도: ${todoData.urgency.toInt()}',
                          style: CustomTextStyle.body2,
                        ),
                        const Gap(defaultGapS / 2),
                        CustomSlider(
                          value: todoData.urgency,
                          isEnabled: false,
                        ),
                        const Gap(defaultGapM),
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
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: SizedBox(
            height: 56,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TodoDetailBottomButton(
                  onTap: () => _undoCompletedTodo(index, context, ref),
                  icon: Icons.refresh_outlined,
                  content: '되돌리기',
                ),
                TodoDetailBottomButton(
                  onTap: () => showDialog(
                    context: context,
                    builder: (context) => CustomDialog(
                      title: '완료된 일을 삭제할까요?',
                      onTap: () => _deleteCompletedTodo(index, context, ref),
                    ),
                  ),
                  icon: Icons.delete_outlined,
                  content: '삭제',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _undoCompletedTodo(int index, BuildContext context, WidgetRef ref) {
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
    Navigator.pop(context);
  }

  void _deleteCompletedTodo(int index, BuildContext context, WidgetRef ref) {
    ref.read(todoCompletedProvider.notifier).deleteCompletedTodoAt(index);
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 1),
        content: Center(
          child: Text(
            '완료된 일을 삭제했어요.',
            style: CustomTextStyle.body3.copyWith(color: white),
          ),
        ),
      ),
    );
    Navigator.pop(context);
  }
}
