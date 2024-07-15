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
  final FocusNode _focusNode = FocusNode();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  double? _newUrgencyValue;
  double? _newImportanceValue;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.todoData.title);
    _contentController = TextEditingController(text: widget.todoData.content);
    _newUrgencyValue = widget.todoData.urgency;
    _newImportanceValue = widget.todoData.importance;
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
                    onTap: () => GeneralDatePicker.showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      onDateSelected: (DateTime? selectedDate) {
                        setState(() {
                          _selectedDate = selectedDate;
                          widget.todoData.deadline = DateTime(_selectedDate!.year, _selectedDate!.month, _selectedDate!.day, _selectedTime!.hour, _selectedTime!.minute);
                        });
                      },
                    ),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(defaultPaddingS),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(defaultBorderRadiusM),
                        color: white,
                      ),
                      child: Text(
                        '${_selectedDate!.year}년 ${_selectedDate!.month}월 ${_selectedDate!.day}일(${dayOfWeekToKorean(DayOfWeek.values[_selectedDate!.weekday - 1])})',
                        style: CustomTextStyle.body1,
                      ),
                    ),
                  ),
                  const Gap(defaultGapL),
                  InkWell(
                    onTap: () => GeneralTimePicker.showTimePicker(
                        context: context,
                        initialTime: _selectedTime,
                        onTimeSelected: (TimeOfDay? selectedTime) {
                          setState(() {
                            _selectedTime = selectedTime;
                            widget.todoData.deadline = DateTime(_selectedDate!.year, _selectedDate!.month, _selectedDate!.day, _selectedTime!.hour, _selectedTime!.minute);
                          });
                        }),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(defaultPaddingS),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(defaultBorderRadiusM),
                        color: white,
                      ),
                      child: Text(
                        GeneralFormatTime.formatInteractionTime(_selectedTime!),
                        style: CustomTextStyle.body1,
                      ),
                    ),
                  ),
                  const Gap(defaultGapL),
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
      widget.todoData.deadline = DateTime(_selectedDate!.year, _selectedDate!.month, _selectedDate!.day, _selectedTime!.hour, _selectedTime!.minute);
      ref.read(todoProvider.notifier).updateTodo(id, widget.todoData);
      GeneralSnackBar.showSnackBar(context, '수정을 완료했어요.');
      Navigator.pop(context, widget.todoData);
    }
  }
}
