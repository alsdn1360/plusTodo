import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:plus_todo/functions/general_adjust_initial_time.dart';
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

class TodoInteractionCreatePage extends ConsumerStatefulWidget {
  final DateTime? initialSelectedDate;

  const TodoInteractionCreatePage({
    super.key,
    this.initialSelectedDate,
  });

  @override
  ConsumerState<TodoInteractionCreatePage> createState() => _TodoInteractionCreatePageState();
}

class _TodoInteractionCreatePageState extends ConsumerState<TodoInteractionCreatePage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  double _importance = 1;
  double _urgency = 1;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  int? _selectedNotificationTime;

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
    _selectedDate = widget.initialSelectedDate ?? _selectedDate;
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
            padding: const EdgeInsets.symmetric(horizontal: defaultPaddingM),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TodoInteractionUrgencyImportanceCard(
                    urgency: _urgency,
                    importance: _importance,
                    onUrgencyChanged: (newValue) => setState(() => _urgency = newValue),
                    onImportanceChanged: (newValue) => setState(() => _importance = newValue),
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
                        CustomTextField(
                          hintText: '할 일',
                          textStyle: CustomTextStyle.body1,
                          textController: _titleController,
                          focusNode: _focusNode,
                        ),
                        const Gap(defaultGapS),
                        CustomTextField(
                          hintText: '메모',
                          textStyle: CustomTextStyle.body2,
                          textController: _contentController,
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
                            initialDate: _selectedDate,
                            onDateSelected: (DateTime? selectedDate) {
                              if (selectedDate == null) {
                                setState(() => _selectedDate = DateTime.now());
                              } else {
                                setState(() => _selectedDate = selectedDate);
                              }
                            },
                          ),
                          child: SizedBox(
                            width: double.infinity,
                            child: Text(
                              (_selectedDate == null)
                                  ? '날짜'
                                  : '${_selectedDate!.year}년 ${_selectedDate!.month}월 ${_selectedDate!.day}일(${dayOfWeekToKorean(DayOfWeek.values[_selectedDate!.weekday - 1])})',
                              style: CustomTextStyle.body1.copyWith(
                                color: (_selectedDate == null) ? gray : black,
                              ),
                            ),
                          ),
                        ),
                        const Gap(defaultGapS),
                        TodoInteractionSimpleDateButton(
                          onDateSelected: (selectedDate) {
                            setState(() => _selectedDate = selectedDate);
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () => GeneralTimePicker.showTimePicker(
                            context: context,
                            initialTime: GeneralAdjustedInitialTime.adjustedInitialTime(_selectedTime),
                            onTimeSelected: (TimeOfDay? selectedTime) {
                              if (selectedTime == null) {
                                setState(
                                  () => _selectedTime = GeneralAdjustedInitialTime.adjustedInitialTime(_selectedTime),
                                );
                              } else {
                                setState(() => _selectedTime = selectedTime);
                              }
                            },
                          ),
                          child: SizedBox(
                            width: double.infinity,
                            child: Text(
                              GeneralFormatTime.formatInteractionTime(_selectedTime),
                              style: CustomTextStyle.body1.copyWith(
                                color: (_selectedTime == null) ? gray : black,
                              ),
                            ),
                          ),
                        ),
                        const Gap(defaultGapS),
                        TodoInteractionSimpleTimeButton(
                          onTimeSelected: (selectedTime) {
                            setState(() => _selectedTime = selectedTime);
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
                            (_selectedNotificationTime == null) ? '알림 시간' : GeneralFormatTime.formatNotificationTime(_selectedNotificationTime!),
                            style: CustomTextStyle.body1.copyWith(
                              color: (_selectedNotificationTime == null) ? gray : black,
                            ),
                          ),
                        ),
                        const Gap(defaultGapS),
                        TodoInteractionSimpleNotificationButton(
                          onNotificationTimeSelected: (selectedNotificationTime) {
                            setState(() => _selectedNotificationTime = selectedNotificationTime);
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
      bottomNavigationBar: TodoInteractionBottomButton(onTap: () => _createTodo(ref)),
    );
  }

  void _createTodo(WidgetRef ref) {
    if (_titleController.text.isEmpty) {
      GeneralSnackBar.showSnackBar(context, '할 일을 입력해 주세요.');
    } else if (_selectedDate == null) {
      GeneralSnackBar.showSnackBar(context, '날짜를 선택해 주세요.');
    } else if (_selectedTime == null) {
      GeneralSnackBar.showSnackBar(context, '시간을 선택해 주세요.');
    } else if (_selectedNotificationTime == null) {
      GeneralSnackBar.showSnackBar(context, '알림 시간을 선택해 주세요.');
    } else {
      final addTodo = Todo(
        title: _titleController.text,
        content: _contentController.text,
        urgency: _urgency,
        importance: _importance,
        isDone: false,
        deadline: DateTime(_selectedDate!.year, _selectedDate!.month, _selectedDate!.day, _selectedTime!.hour, _selectedTime!.minute),
        notificationTime: _selectedNotificationTime!,
      );
      ref.read(todoProvider.notifier).createTodo(addTodo);
      Navigator.pop(context);
      GeneralSnackBar.showSnackBar(context, '할 일이 추가되었어요.');
    }
  }
}
