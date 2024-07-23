import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:plus_todo/functions/general_date_picker.dart';
import 'package:plus_todo/functions/general_snack_bar.dart';
import 'package:plus_todo/functions/general_time_picker.dart';
import 'package:plus_todo/models/day_of_week.dart';
import 'package:plus_todo/models/todo.dart';
import 'package:plus_todo/pages/todo/interaction/components/todo_interaction_bottom_button.dart';
import 'package:plus_todo/functions/general_format_time.dart';
import 'package:plus_todo/pages/todo/interaction/components/todo_interaction_simple_date_button.dart';
import 'package:plus_todo/pages/todo/interaction/components/todo_interaction_simple_notification_time_butoon.dart';
import 'package:plus_todo/pages/todo/interaction/components/todo_interaction_simple_time_button.dart';
import 'package:plus_todo/pages/todo/interaction/components/todo_interaction_urgency_importance_card.dart';
import 'package:plus_todo/providers/todo/todo_provider.dart';
import 'package:plus_todo/themes/custom_color.dart';
import 'package:plus_todo/themes/custom_decoration.dart';
import 'package:plus_todo/themes/custom_font.dart';
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

  DateTime? _newSelectedDate;
  TimeOfDay? _newSelectedTime;
  double? _newUrgencyValue;
  double? _newImportanceValue;
  int? _newNotificationTime;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.todoData.title);
    _contentController = TextEditingController(text: widget.todoData.content);
    _newUrgencyValue = widget.todoData.urgency;
    _newImportanceValue = widget.todoData.importance;
    _newSelectedDate = widget.todoData.deadline;
    _newSelectedTime = widget.todoData.deadline != null ? TimeOfDay.fromDateTime(widget.todoData.deadline!) : null;
    _newNotificationTime = widget.todoData.notificationTime;
  }

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _contentController.dispose();
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
                        ),
                        const Gap(defaultGapS),
                        CustomTextField(
                          textStyle: CustomTextStyle.body2,
                          textController: _contentController,
                          hintText: widget.todoData.content.isEmpty ? '내용' : null,
                        ),
                      ],
                    ),
                  ),
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
                        InkWell(
                          onTap: () => GeneralDatePicker.showDatePicker(
                            context: context,
                            initialDate: _newSelectedDate,
                            onDateSelected: (DateTime? selectedDate) {
                              setState(
                                () {
                                  _newSelectedDate = selectedDate;
                                  widget.todoData.deadline = DateTime(
                                      _newSelectedDate!.year, _newSelectedDate!.month, _newSelectedDate!.day, _newSelectedTime!.hour, _newSelectedTime!.minute);
                                },
                              );
                            },
                          ),
                          child: SizedBox(
                            width: double.infinity,
                            child: Text(
                              '${_newSelectedDate!.year}년 ${_newSelectedDate!.month}월 ${_newSelectedDate!.day}일(${dayOfWeekToKorean(DayOfWeek.values[_newSelectedDate!.weekday - 1])})',
                              style: CustomTextStyle.body1,
                            ),
                          ),
                        ),
                        const Gap(defaultGapS),
                        TodoInteractionSimpleDateButton(
                          onDateSelected: (selectedDate) {
                            setState(() => _newSelectedDate = selectedDate);
                          },
                        ),
                      ],
                    ),
                  ),
                  const Gap(defaultGapM),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(defaultPaddingS),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(defaultBorderRadiusM),
                      color: white,
                    ),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () => GeneralTimePicker.showTimePicker(
                            context: context,
                            initialTime: _newSelectedTime,
                            onTimeSelected: (TimeOfDay? selectedTime) {
                              setState(
                                () {
                                  _newSelectedTime = selectedTime;
                                  widget.todoData.deadline = DateTime(_newSelectedDate!.year, _newSelectedDate!.month, _newSelectedDate!.day,
                                      _newSelectedTime!.hour, _newSelectedTime!.minute);
                                },
                              );
                            },
                          ),
                          child: SizedBox(
                            width: double.infinity,
                            child: Text(
                              GeneralFormatTime.formatInteractionTime(_newSelectedTime!),
                              style: CustomTextStyle.body1,
                            ),
                          ),
                        ),
                        const Gap(defaultGapS),
                        TodoInteractionSimpleTimeButton(
                          onTimeSelected: (selectedTime) {
                            setState(() => _newSelectedTime = selectedTime);
                          },
                        ),
                      ],
                    ),
                  ),
                  const Gap(defaultGapM),
                  Container(
                    padding: const EdgeInsets.all(defaultPaddingS),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: white,
                      borderRadius: BorderRadius.circular(defaultBorderRadiusM),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: Text(
                            GeneralFormatTime.formatNotificationTime(_newNotificationTime!),
                            style: CustomTextStyle.body1,
                          ),
                        ),
                        const Gap(defaultGapS),
                        TodoInteractionSimpleNotificationButton(
                          onNotificationTimeSelected: (selectedNotificationTime) {
                            setState(() => _newNotificationTime = selectedNotificationTime);
                          },
                        ),
                      ],
                    ),
                  ),
                  const Gap(defaultGapM),
                  TodoInteractionUrgencyImportanceCard(
                    urgency: _newUrgencyValue!,
                    importance: _newImportanceValue!,
                    onUrgencyChanged: (double newValue) => setState(() => _newUrgencyValue = newValue),
                    onImportanceChanged: (double newValue) => setState(() => _newImportanceValue = newValue),
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

  void _editTodo(BuildContext context, WidgetRef ref, int id) {
    if (_titleController.text.isEmpty) {
      GeneralSnackBar.showSnackBar(context, '할 일을 입력해 주세요.');
    } else {
      widget.todoData.title = _titleController.text;
      widget.todoData.content = _contentController.text;
      widget.todoData.urgency = _newUrgencyValue!;
      widget.todoData.importance = _newImportanceValue!;
      widget.todoData.deadline =
          DateTime(_newSelectedDate!.year, _newSelectedDate!.month, _newSelectedDate!.day, _newSelectedTime!.hour, _newSelectedTime!.minute);
      widget.todoData.notificationTime = _newNotificationTime!;
      ref.read(todoProvider.notifier).updateTodo(id, widget.todoData);
      GeneralSnackBar.showSnackBar(context, '수정을 완료했어요.');
      Navigator.pop(context, widget.todoData);
    }
  }
}
