import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/cupertino.dart';
import 'package:gap/gap.dart';
import 'package:plus_todo/models/todo.dart';
import 'package:plus_todo/pages/todo/interaction/components/todo_interaction_bottom_button.dart';
import 'package:plus_todo/pages/todo/interaction/components/todo_interaction_simple_date_button.dart';
import 'package:plus_todo/pages/todo/interaction/components/todo_interaction_simple_time_button.dart';
import 'package:plus_todo/providers/todo/todo_provider.dart';
import 'package:plus_todo/themes/custom_color.dart';
import 'package:plus_todo/themes/custom_decoration.dart';
import 'package:plus_todo/themes/custom_font.dart';
import 'package:plus_todo/widgets/custom_slider.dart';
import 'package:plus_todo/widgets/custom_text_field.dart';

class TodoInteractionCreatePage extends ConsumerStatefulWidget {
  const TodoInteractionCreatePage({super.key});

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
                          hintText: '할 일',
                          textStyle: CustomTextStyle.body1,
                          textController: _titleController,
                          focusNode: _focusNode,
                        ),
                        const Gap(defaultGapM),
                        CustomTextField(
                          hintText: '메모',
                          textStyle: CustomTextStyle.body2,
                          textController: _contentController,
                        ),
                      ],
                    ),
                  ),
                  const Gap(defaultGapL),
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
                          onTap: () => _showDatePicker(context),
                          child: SizedBox(
                            width: double.infinity,
                            child: Text(
                              _formatDate(_selectedDate),
                              style: CustomTextStyle.body1.copyWith(
                                color: _getDateTextColor(_selectedDate),
                              ),
                            ),
                          ),
                        ),
                        const Gap(defaultGapM),
                        TodoInteractionSimpleDateButton(
                          onDateSelected: (selectedDate) {
                            setState(() => _selectedDate = selectedDate);
                          },
                        )
                      ],
                    ),
                  ),
                  const Gap(defaultGapL),
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
                          onTap: () => _showTimePicker(context),
                          child: SizedBox(
                            width: double.infinity,
                            child: Text(
                              _formatTime(_selectedTime),
                              style: CustomTextStyle.body1.copyWith(
                                color: _getTimeTextColor(_selectedTime),
                              ),
                            ),
                          ),
                        ),
                        const Gap(defaultGapM),
                        TodoInteractionSimpleTimeButton(
                          onTimeSelected: (selectedTime) {
                            setState(() => _selectedTime = selectedTime);
                          },
                        )
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
                      color: white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_urgency >= 5 && _importance >= 5)
                          Text(
                            'Do',
                            style: CustomTextStyle.title2.copyWith(color: red),
                          )
                        else if (_urgency >= 5 && _importance < 5)
                          Text(
                            'Delegate',
                            style: CustomTextStyle.title2.copyWith(color: blue),
                          )
                        else if (_urgency < 5 && _importance >= 5)
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
                          '긴급도: ${_urgency.toInt()}',
                          style: CustomTextStyle.body1,
                        ),
                        const Gap(defaultGapS / 2),
                        CustomSlider(
                          value: _urgency,
                          onChanged: (double newValue) {
                            setState(() => _urgency = newValue);
                          },
                        ),
                        const Gap(defaultGapM),
                        Text(
                          '중요도: ${_importance.toInt()}',
                          style: CustomTextStyle.body1,
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
        ),
      ),
      bottomNavigationBar: TodoInteractionBottomButton(onTap: () => _createTodo(ref)),
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
            padding: const EdgeInsets.all(defaultPaddingS),
            child: Column(
              children: [
                SizedBox(
                  height: 200,
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
                    if (tempPickedDate == null) {
                      setState(() => _selectedDate = DateTime.now());
                    } else {
                      setState(() => _selectedDate = tempPickedDate);
                    }
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
            padding: const EdgeInsets.all(defaultPaddingS),
            child: Column(
              children: [
                SizedBox(
                  height: 200,
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.time,
                    initialDateTime: _getAdjustedInitialDateTime(),
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
                    if (tempPickedTime == null) {
                      setState(() => _selectedTime = TimeOfDay.fromDateTime(_getAdjustedInitialDateTime()));
                    } else {
                      setState(() => _selectedTime = tempPickedTime);
                    }
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

  String _formatDate(DateTime? date) {
    if (date == null) {
      return '날짜';
    } else {
      return '${date.year}년 ${date.month}월 ${date.day}일 (${_getDayOfWeek(date.weekday)})';
    }
  }

  String _formatTime(TimeOfDay? time) {
    if (time == null) {
      return '시간';
    } else {
      final hours = time.hour % 12 == 0 ? 12 : time.hour % 12;
      final period = time.hour < 12 ? '오전' : '오후';
      final minutes = time.minute.toString().padLeft(2, '0');
      return '$period $hours:$minutes';
    }
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

  DateTime _getAdjustedInitialDateTime() {
    final now = DateTime.now();
    final initialDateTime = DateTime(
      _selectedDate?.year ?? now.year,
      _selectedDate?.month ?? now.month,
      _selectedDate?.day ?? now.day,
      _selectedTime?.hour ?? now.hour,
      _selectedTime?.minute ?? now.minute,
    );

    int minuteInterval = 5;
    int adjustedMinute = (initialDateTime.minute + minuteInterval - 1) ~/ minuteInterval * minuteInterval;

    if (adjustedMinute >= 60) {
      adjustedMinute -= 60;
      return DateTime(
        initialDateTime.year,
        initialDateTime.month,
        initialDateTime.day,
        initialDateTime.hour + 1,
        adjustedMinute,
      );
    }

    return DateTime(
      initialDateTime.year,
      initialDateTime.month,
      initialDateTime.day,
      initialDateTime.hour,
      adjustedMinute,
    );
  }

  Color _getDateTextColor(DateTime? date) {
    return date == null ? Colors.grey : Colors.black;
  }

  Color _getTimeTextColor(TimeOfDay? time) {
    return time == null ? Colors.grey : Colors.black;
  }

  void _createTodo(WidgetRef ref) {
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
    } else if (_selectedDate == null) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 2),
          content: Center(
            child: Text(
              '날짜를 선택해 주세요.',
              style: CustomTextStyle.body3.copyWith(color: white),
            ),
          ),
        ),
      );
    } else if (_selectedTime == null) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 2),
          content: Center(
            child: Text(
              '시간을 선택해 주세요.',
              style: CustomTextStyle.body3.copyWith(color: white),
            ),
          ),
        ),
      );
    } else {
      final addTodo = Todo(
        title: _titleController.text,
        content: _contentController.text,
        urgency: _urgency,
        importance: _importance,
        isDone: false,
        deadline: _inputDeadline(_selectedDate!, _selectedTime!),
      );
      ref.read(todoProvider.notifier).createTodo(addTodo);
      Navigator.pop(context);
    }
  }

  DateTime? _inputDeadline(DateTime date, TimeOfDay time) {
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }
}
