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
import 'package:plus_todo/pages/todo/interaction/todo_interaction_edit_page.dart';
import 'package:plus_todo/providers/todo/todo_provider.dart';
import 'package:plus_todo/themes/custom_color.dart';
import 'package:plus_todo/themes/custom_decoration.dart';
import 'package:plus_todo/themes/custom_font.dart';
import 'package:plus_todo/widgets/custom_dialog.dart';

class TodoDetailUncompletedPage extends ConsumerStatefulWidget {
  final Todo todoData;

  const TodoDetailUncompletedPage({
    super.key,
    required this.todoData,
  });

  @override
  ConsumerState<TodoDetailUncompletedPage> createState() => _TodoDetailUncompletedPageState();
}

class _TodoDetailUncompletedPageState extends ConsumerState<TodoDetailUncompletedPage> {
  late Todo _todoData;

  @override
  void initState() {
    super.initState();
    _todoData = widget.todoData;
  }

  @override
  Widget build(BuildContext context) {
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
                  onTap: () => _pushEditPage(context, _todoData),
                  child: Container(
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
                          _todoData.title,
                          style: CustomTextStyle.body1,
                          softWrap: true,
                          textAlign: TextAlign.justify,
                        ),
                        if (_todoData.content.isNotEmpty)
                          Column(
                            children: [
                              const Gap(defaultGapM),
                              Text(
                                _todoData.content,
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
                  onTap: () => _pushEditPage(context, _todoData),
                  child: TodoDetailDeadlineDateCard(todoData: _todoData),
                ),
                const Gap(defaultGapL),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => _pushEditPage(context, _todoData),
                        child: TodoDetailDeadlineTimeCard(todoData: _todoData),
                      ),
                    ),
                    const Gap(defaultGapL),
                    Expanded(
                      child: InkWell(
                        onTap: () => _pushEditPage(context, _todoData),
                        child: TodoDetailNotificationTimeCard(todoData: _todoData),
                      ),
                    ),
                  ],
                ),
                const Gap(defaultGapL),
                InkWell(
                  onTap: () => _pushEditPage(context, _todoData),
                  child: TodoDetailUrgencyImportanceCard(todoData: _todoData),
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
              children: [
                TodoDetailBottomButton(
                  onTap: () => _completeTodo(context, widget.todoData.id),
                  icon: Icons.check_outlined,
                  content: '할 일 완료',
                ),
                TodoDetailBottomButton(
                  onTap: () => _pushEditPage(context, _todoData),
                  icon: Icons.edit_outlined,
                  content: '수정',
                ),
                TodoDetailBottomButton(
                  onTap: () => showDialog(
                    context: context,
                    builder: (context) => CustomDialog(
                      title: '할 일을 삭제할까요?',
                      onTap: () => _deleteUncompletedTodo(context, widget.todoData.id),
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

  void _completeTodo(BuildContext context, int id) {
    ref.read(todoProvider.notifier).toggleTodo(id);
    GeneralSnackBar.showSnackBar(context, '할 일을 완료했어요.');
    Navigator.pop(context);
  }

  Future<void> _pushEditPage(BuildContext context, Todo uncompletedTodoList) async {
    final updatedTodo = await Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => TodoInteractionEditPage(todoData: uncompletedTodoList),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );

    if (updatedTodo != null) {
      setState(
        () => _todoData = updatedTodo,
      );
    }
  }

  void _deleteUncompletedTodo(BuildContext context, int id) {
    ref.read(todoProvider.notifier).deleteTodo(id);
    GeneralSnackBar.showSnackBar(context, '할 일을 삭제했어요.');
    Navigator.pop(context);
  }
}
