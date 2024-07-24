import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:plus_todo/functions/general_snack_bar.dart';
import 'package:plus_todo/models/todo.dart';
import 'package:plus_todo/pages/todo/detail/components/todo_detail_deadline_date_card.dart';
import 'package:plus_todo/pages/todo/detail/components/todo_detail_deadline_time_card.dart';
import 'package:plus_todo/pages/todo/detail/components/todo_detail_notification_time_card.dart';
import 'package:plus_todo/pages/todo/detail/components/todo_detail_urgency_importance_card.dart';
import 'package:plus_todo/pages/todo/detail/components/todo_detail_bottom_button.dart';
import 'package:plus_todo/providers/todo/todo_provider.dart';
import 'package:plus_todo/themes/custom_color.dart';
import 'package:plus_todo/themes/custom_decoration.dart';
import 'package:plus_todo/themes/custom_font.dart';
import 'package:plus_todo/widgets/custom_dialog.dart';

class TodoDetailCompletedPage extends ConsumerWidget {
  final Todo todoData;

  const TodoDetailCompletedPage({
    super.key,
    required this.todoData,
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
                TodoDetailUrgencyImportanceCard(todoData: todoData),
                const Gap(defaultGapM),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(defaultPaddingS),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(defaultBorderRadiusM),
                    color: white,
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
                            const Gap(defaultGapS),
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
                const Gap(defaultGapM),
                TodoDetailDeadlineDateCard(todoData: todoData),
                const Gap(defaultGapM),
                TodoDetailDeadlineTimeCard(todoData: todoData),
                const Gap(defaultGapM),
                TodoDetailNotificationTimeCard(todoData: todoData),

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
              children: [
                TodoDetailBottomButton(
                  onTap: () => _undoCompletedTodo(context, ref, todoData.id),
                  icon: Icons.refresh_outlined,
                  content: '되돌리기',
                ),
                TodoDetailBottomButton(
                  onTap: () => showDialog(
                    context: context,
                    builder: (context) => CustomDialog(
                      title: '완료된 일을 삭제할까요?',
                      onTap: () => _deleteCompletedTodo(context, ref, todoData.id),
                    ),
                  ),
                  icon: Icons.delete_forever_outlined,
                  content: '삭제',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _undoCompletedTodo(BuildContext context, WidgetRef ref, int id) {
    ref.read(todoProvider.notifier).toggleTodo(id);
    GeneralSnackBar.showSnackBar(context, '완료된 일을 다시 되돌렸어요.');
    Navigator.pop(context);
  }

  void _deleteCompletedTodo(BuildContext context, WidgetRef ref, int id) {
    ref.read(todoProvider.notifier).deleteTodo(id);
    GeneralSnackBar.showSnackBar(context, '완료된 일을 삭제했어요.');
    Navigator.pop(context);
  }
}
