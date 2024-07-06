import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:plus_todo/models/todo.dart';
import 'package:plus_todo/pages/todo/detail/components/todo_detail_bottom_button.dart';
import 'package:plus_todo/pages/todo/interaction/todo_interaction_edit_page.dart';
import 'package:plus_todo/providers/todo/todo_provider.dart';
import 'package:plus_todo/themes/custom_color.dart';
import 'package:plus_todo/themes/custom_decoration.dart';
import 'package:plus_todo/themes/custom_font.dart';
import 'package:plus_todo/widgets/custom_dialog.dart';
import 'package:plus_todo/widgets/custom_slider.dart';

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
                      color: white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_todoData.urgency >= 5 && _todoData.importance >= 5)
                          Text(
                            'Do',
                            style: CustomTextStyle.title2.copyWith(color: red),
                          )
                        else if (_todoData.urgency >= 5 && _todoData.importance < 5)
                          Text(
                            'Delegate',
                            style: CustomTextStyle.title2.copyWith(color: blue),
                          )
                        else if (_todoData.urgency < 5 && _todoData.importance >= 5)
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
                          '긴급도: ${_todoData.urgency.toInt()}',
                          style: CustomTextStyle.body2,
                        ),
                        const Gap(defaultGapS / 2),
                        CustomSlider(
                          value: _todoData.urgency,
                          isEnabled: false,
                        ),
                        const Gap(defaultGapM),
                        Text(
                          '중요도: ${_todoData.importance.toInt()}',
                          style: CustomTextStyle.body2,
                        ),
                        const Gap(defaultGapS / 2),
                        CustomSlider(
                          value: _todoData.importance,
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
                  onTap: () => _completeTodo(context, widget.todoData.id),
                  icon: Icons.check_outlined,
                  content: '할 일 완료',
                ),
                TodoDetailBottomButton(
                  onTap: () => _pushEditPage(context, _todoData),
                  icon: Icons.edit_outlined,
                  content: '편집',
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

  Future<void> _pushEditPage(BuildContext context, Todo uncompletedTodoList) async {
    final updatedTodo = await Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => TodoInteractionEditPage(
          todoData: uncompletedTodoList,
        ),
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
