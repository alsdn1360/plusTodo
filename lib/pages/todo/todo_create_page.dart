import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:plus_todo/data/todo_data.dart';
import 'package:plus_todo/provider/provider_todo.dart';
import 'package:plus_todo/themes/custom_color.dart';
import 'package:plus_todo/themes/custom_decoration.dart';
import 'package:plus_todo/themes/custom_font.dart';
import 'package:plus_todo/widgets/custom_slider.dart';
import 'package:plus_todo/widgets/custom_text_field.dart';

class TodoCreatePage extends StatefulWidget {
  const TodoCreatePage({super.key});

  @override
  State<TodoCreatePage> createState() => _TodoCreatePageState();
}

class _TodoCreatePageState extends State<TodoCreatePage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  double _importance = 1;
  double _urgency = 1;

  @override
  void initState() {
    super.initState();
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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('새로운 할 일'),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(
              bottom: defaultPaddingM,
              left: defaultPaddingM,
              right: defaultPaddingM,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
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
                                hintText: '제목',
                                textController: _titleController,
                                focusNode: _focusNode,
                              ),
                              const Gap(defaultGapL),
                              CustomTextField(
                                hintText: '메모',
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
                              Text(
                                '긴급도: ${_urgency.toInt()}',
                                style: CustomTextStyle.body2,
                              ),
                              const Gap(defaultGapS / 2),
                              CustomSlider(
                                value: _urgency,
                                onChanged: (double newValue) {
                                  setState(() => _urgency = newValue);
                                },
                              ),
                              const Gap(defaultGapL),
                              Text(
                                '중요도: ${_importance.toInt()}',
                                style: CustomTextStyle.body2,
                              ),
                              const Gap(defaultGapS / 2),
                              CustomSlider(
                                value: _importance,
                                onChanged: (double newValue) {
                                  setState(() => _importance = newValue);
                                },
                              ),
                            ],
                          ),
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
                        onTap: () => _addTodo(ref),
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

  void _addTodo(WidgetRef ref) {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Center(
            child: Text(
              '제목을 입력해주세요.',
              style: CustomTextStyle.body3.copyWith(color: white),
            ),
          ),
        ),
      );
      return;
    } else {
      final addTodo = TodoData(
        title: _titleController.text,
        content: _contentController.text,
        urgency: _urgency,
        importance: _importance,
        isDone: false,
      );
      ref.read(todoListProvider.notifier).addTodo(addTodo);
      Navigator.pop(context);
    }
  }
}
