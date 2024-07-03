import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:plus_todo/data/todo_data.dart';
import 'package:plus_todo/provider/todo/todo_uncompleted_provider.dart';
import 'package:plus_todo/themes/custom_color.dart';
import 'package:plus_todo/themes/custom_decoration.dart';
import 'package:plus_todo/themes/custom_font.dart';
import 'package:plus_todo/widgets/custom_slider.dart';
import 'package:plus_todo/widgets/custom_text_field.dart';

class TodoInteractionEditPage extends StatefulWidget {
  final TodoData todoData;
  final int originalIndex;

  const TodoInteractionEditPage({
    super.key,
    required this.todoData,
    required this.originalIndex,
  });

  @override
  State<TodoInteractionEditPage> createState() => _TodoInteractionEditPageState();
}

class _TodoInteractionEditPageState extends State<TodoInteractionEditPage> {
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.todoData.title);
    _contentController = TextEditingController(text: widget.todoData.content);
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _contentController.dispose();
    _focusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: defaultPaddingM),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(defaultPaddingS),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(defaultBorderRadiusM),
                      color: darkWhite,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextField(
                          textStyle: CustomTextStyle.body1,
                          textController: _titleController,
                          focusNode: _focusNode,
                        ),
                        const Gap(defaultGapM),
                        CustomTextField(
                          hintText: widget.todoData.content.isEmpty ? '내용' : null,
                          textStyle: CustomTextStyle.body2,
                          textController: _contentController,
                        ),
                      ],
                    ),
                  ),
                  const Gap(defaultGapL),
                  Container(
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
                        if (widget.todoData.urgency >= 5 && widget.todoData.importance >= 5)
                          Text(
                            'Do',
                            style: CustomTextStyle.title2.copyWith(color: red),
                          )
                        else if (widget.todoData.urgency >= 5 && widget.todoData.importance < 5)
                          Text(
                            'Delegate',
                            style: CustomTextStyle.title2.copyWith(color: blue),
                          )
                        else if (widget.todoData.urgency < 5 && widget.todoData.importance >= 5)
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
                          '긴급도: ${widget.todoData.urgency.toInt()}',
                          style: CustomTextStyle.body2,
                        ),
                        const Gap(defaultGapS / 2),
                        CustomSlider(
                          value: widget.todoData.urgency,
                          onChanged: (double newValue) {
                            setState(() => widget.todoData.urgency = newValue);
                          },
                        ),
                        const Gap(defaultGapM),
                        Text(
                          '중요도: ${widget.todoData.importance.toInt()}',
                          style: CustomTextStyle.body2,
                        ),
                        const Gap(defaultGapS / 2),
                        CustomSlider(
                          value: widget.todoData.importance,
                          onChanged: (double newValue) {
                            setState(() => widget.todoData.importance = newValue);
                          },
                        ),
                      ],
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
                    onTap: () => Navigator.pop(context),
                    child: SizedBox(
                      width: double.infinity,
                      child: Center(
                        child: Text('취소', style: CustomTextStyle.title3),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Consumer(
                    builder: (context, ref, child) {
                      return InkWell(
                        onTap: () => _editTodo(widget.originalIndex, context, ref),
                        child: SizedBox(
                          width: double.infinity,
                          child: Center(
                            child: Text('저장', style: CustomTextStyle.title3),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _editTodo(int index, BuildContext context, WidgetRef ref) async {
    try {
      if (_titleController.text.isEmpty) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 2),
            content: Center(
              child: Text(
                '할 일을 입력해 주세요.',
                style: CustomTextStyle.body3.copyWith(color: white),
              ),
            ),
          ),
        );
      } else {
        widget.todoData.title = _titleController.text;
        widget.todoData.content = _contentController.text;
        ref.read(todoUncompletedProvider.notifier).updateUncompletedTodo(index, widget.todoData);
        Navigator.pop(context, widget.todoData);
      }
    } catch (e) {
      print('Failed to update todo: $e');
    }
  }
}
