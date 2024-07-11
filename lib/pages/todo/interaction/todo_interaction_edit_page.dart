import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/cupertino.dart';
import 'package:gap/gap.dart';
import 'package:plus_todo/models/todo.dart';
import 'package:plus_todo/pages/todo/interaction/components/todo_interaction_bottom_button.dart';
import 'package:plus_todo/providers/todo/todo_provider.dart';
import 'package:plus_todo/themes/custom_color.dart';
import 'package:plus_todo/themes/custom_decoration.dart';
import 'package:plus_todo/themes/custom_font.dart';
import 'package:plus_todo/widgets/custom_slider.dart';
import 'package:plus_todo/widgets/custom_text_field.dart';

class TodoInteractionEditPage extends ConsumerStatefulWidget {
  final Todo todoData;

  const TodoInteractionEditPage({
    super.key,
    required this.todoData,
  });

  @override
  ConsumerState<TodoInteractionEditPage> createState() => _TodoInteractionEditPageState();
}

class _TodoInteractionEditPageState extends ConsumerState<TodoInteractionEditPage> {
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;
  final FocusNode _focusNode = FocusNode();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.todoData.title);
    _contentController = TextEditingController(text: widget.todoData.content);
    _selectedDate = widget.todoData.deadline;
    _selectedTime = widget.todoData.deadline != null ? TimeOfDay.fromDateTime(widget.todoData.deadline!) : null;
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
        title: const Text('할 일 수정'),
      ),
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
                      color: white,
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
                          textStyle: CustomTextStyle.body2,
                          textController: _contentController,
                          hintText: widget.todoData.content.isEmpty ? '내용' : null,
                        ),
                      ],
                    ),
                  ),
                  const Gap(defaultGapL),
                  InkWell(
                    onTap: () => _showDatePicker(context),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(defaultPaddingS),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(defaultBorderRadiusM),
                        color: white,
                      ),
                      child: Text(
                        '${_selectedDate!.year}년 ${_selectedDate!.month}월 ${_selectedDate!.day}일 (${_getDayOfWeek(_selectedDate!.weekday)})',
                        style: CustomTextStyle.body1,
                      ),
                    ),
                  ),
                  const Gap(defaultGapL),
                  InkWell(
                    onTap: () => _showTimePicker(context),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(defaultPaddingS),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(defaultBorderRadiusM),
                        color: white,
                      ),
                      child: Text(
                        _formatTime(_selectedTime!),
                        style: CustomTextStyle.body1,
                      ),
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
                      color: white,
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
                          style: CustomTextStyle.body1,
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
                          style: CustomTextStyle.body1,
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
      bottomNavigationBar: TodoInteractionBottomButton(
        onTap: () => _editTodo(context, ref, widget.todoData.id),
      ),
    );
  }

  void _showDatePicker(BuildContext context) {
    DateTime? tempPickedDate = _selectedDate;
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height / 3,
          width: double.infinity,
          decoration: BoxDecoration(
            color: white,
            borderRadius: BorderRadius.circular(defaultBorderRadiusM),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: defaultPaddingL),
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 5,
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date,
                    initialDateTime: _selectedDate ?? DateTime.now(),
                    onDateTimeChanged: (DateTime newDateTime) {
                      tempPickedDate = newDateTime;
                    },
                  ),
                ),
                CupertinoButton(
                  child: Text(
                    '확인',
                    style: CustomTextStyle.body1,
                  ),
                  onPressed: () {
                    setState(() {
                      _selectedDate = tempPickedDate;
                      widget.todoData.deadline = _inputDeadline(_selectedDate!, _selectedTime!);
                    });
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showTimePicker(BuildContext context) {
    TimeOfDay? tempPickedTime = _selectedTime;
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height / 3,
          width: double.infinity,
          decoration: BoxDecoration(
            color: white,
            borderRadius: BorderRadius.circular(defaultBorderRadiusM),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: defaultPaddingL),
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 5,
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.time,
                    initialDateTime: DateTime(2000, 2, 10, _selectedTime!.hour, _selectedTime!.minute),
                    minuteInterval: 5,
                    onDateTimeChanged: (DateTime newDateTime) {
                      tempPickedTime = TimeOfDay(hour: newDateTime.hour, minute: newDateTime.minute);
                    },
                  ),
                ),
                CupertinoButton(
                  child: Text(
                    '확인',
                    style: CustomTextStyle.body1,
                  ),
                  onPressed: () {
                    setState(() {
                      _selectedTime = tempPickedTime;
                      widget.todoData.deadline = _inputDeadline(_selectedDate!, _selectedTime!);
                    });
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _getDayOfWeek(int day) {
    switch (day) {
      case 1:
        return '월';
      case 2:
        return '화';
      case 3:
        return '수';
      case 4:
        return '목';
      case 5:
        return '금';
      case 6:
        return '토';
      case 7:
        return '일';
      default:
        return '';
    }
  }

  String _formatTime(TimeOfDay time) {
    final hours = time.hour % 12 == 0 ? 12 : time.hour % 12;
    final period = time.hour < 12 ? '오전' : '오후';
    final minutes = time.minute.toString().padLeft(2, '0');
    return '$period $hours:$minutes';
  }

  void _editTodo(BuildContext context, WidgetRef ref, int id) {
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
      widget.todoData.deadline = _inputDeadline(_selectedDate!, _selectedTime!);
      ref.read(todoProvider.notifier).updateTodo(id, widget.todoData);
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 1),
          content: Center(
            child: Text(
              '수정을 완료했어요.',
              style: CustomTextStyle.body3.copyWith(color: white),
            ),
          ),
        ),
      );
      Navigator.pop(context, widget.todoData);
    }
  }

  DateTime? _inputDeadline(DateTime date, TimeOfDay time) {
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }
}
