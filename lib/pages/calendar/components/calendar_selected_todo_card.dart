import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:plus_todo/functions/general_format_time.dart';
import 'package:plus_todo/functions/general_snack_bar.dart';
import 'package:plus_todo/models/day_of_week.dart';
import 'package:plus_todo/models/todo.dart';
import 'package:plus_todo/pages/todo/components/todo_urgency_importance_card.dart';
import 'package:plus_todo/pages/todo/detail/todo_detail_completed_page.dart';
import 'package:plus_todo/pages/todo/detail/todo_detail_uncompleted_page.dart';
import 'package:plus_todo/pages/todo/interaction/todo_interaction_create_page.dart';
import 'package:plus_todo/providers/calendar/calendar_week_setting.dart';
import 'package:plus_todo/providers/todo/todo_provider.dart';
import 'package:plus_todo/providers/calendar/calendar_date_provider.dart';
import 'package:plus_todo/themes/custom_color.dart';
import 'package:plus_todo/themes/custom_decoration.dart';
import 'package:plus_todo/themes/custom_font.dart';
import 'package:plus_todo/widgets/custom_divider.dart';

class CalendarSelectedTodoCard extends ConsumerWidget {
  const CalendarSelectedTodoCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(calendarSelectedDateProvider);
    final todoData = ref.watch(todoProvider);
    final saturdayHighlight = ref.watch(calendarWeekSettingProvider.select((value) => value['saturdayHighlight']));
    final sundayHighlight = ref.watch(calendarWeekSettingProvider.select((value) => value['sundayHighlight']));

    final selectedDateTodoData = todoData
        .where((todo) => todo.deadline?.year == selectedDate.year && todo.deadline?.month == selectedDate.month && todo.deadline?.day == selectedDate.day)
        .toList()
      ..sort((a, b) => a.deadline!.compareTo(b.deadline!));

    return Container(
      padding: const EdgeInsets.all(defaultPaddingS),
      width: double.infinity,
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(defaultBorderRadiusM),
        border: Border.all(color: gray.withOpacity(0.2), width: 0.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${selectedDate.day}일',
                style: CustomTextStyle.title3.copyWith(
                  color: selectedDate.weekday == DateTime.saturday && saturdayHighlight
                      ? blue
                      : selectedDate.weekday == DateTime.sunday && sundayHighlight
                          ? red
                          : black,
                ),
              ),
              const Gap(defaultGapM / 2),
              Text(
                dayOfWeekToKoreanForCalendar(DayOfWeek.values[selectedDate.weekday - 1]),
                style: CustomTextStyle.body1.copyWith(
                  color: selectedDate.weekday == DateTime.saturday && saturdayHighlight
                      ? blue
                      : selectedDate.weekday == DateTime.sunday && sundayHighlight
                          ? red
                          : black,
                ),
              ),
              const Spacer(),
              InkWell(
                onTap: () => Navigator.of(context).push(
                  PageRouteBuilder(
                    pageBuilder: (
                        BuildContext context,
                        Animation<double> animation,
                        Animation<double> secondaryAnimation,
                        ) {
                      var curve = CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeOutQuad,
                        reverseCurve: Curves.easeOutQuad,
                      );
                      return SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 1),
                          end: Offset.zero,
                        ).animate(curve),
                        child: TodoInteractionCreatePage(initialSelectedDate: selectedDate),
                      );
                    },
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Icon(Icons.add_circle_outline_rounded, color: black, size: 14),
                    const Gap(defaultGapS / 4),
                    Text(
                      '새로운 할 일',
                      style: CustomTextStyle.caption1,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Gap(defaultGapS),
          const CustomDivider(),
          const Gap(defaultGapS),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (context, index) => const Gap(defaultGapS / 2),
            itemCount: selectedDateTodoData.length,
            itemBuilder: (context, index) {
              final selectedDateTodoList = selectedDateTodoData[index];
              final isDeadlineSoon = selectedDateTodoList.deadline != null && selectedDateTodoList.deadline!.isBefore(DateTime.now());

              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Checkbox(
                    value: selectedDateTodoList.isDone,
                    onChanged: (bool? value) => _onCheck(context, ref, selectedDateTodoList.id),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: const VisualDensity(
                      horizontal: VisualDensity.minimumDensity,
                      vertical: VisualDensity.minimumDensity,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(defaultBorderRadiusM),
                    ),
                    activeColor: black,
                    checkColor: white,
                  ),
                  const Gap(defaultGapM),
                  Expanded(
                    child: InkWell(
                      onTap: () => _pushDetailPage(context, selectedDateTodoList),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            selectedDateTodoList.title,
                            style: CustomTextStyle.body2.copyWith(
                              color: selectedDateTodoList.isDone ? gray : black,
                              decoration: selectedDateTodoList.isDone ? TextDecoration.lineThrough : TextDecoration.none,
                            ),
                            softWrap: true,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                GeneralFormatTime.formatDate(selectedDateTodoList.deadline!),
                                style: selectedDateTodoList.isDone
                                    ? CustomTextStyle.body3.copyWith(color: gray, decoration: TextDecoration.lineThrough)
                                    : isDeadlineSoon
                                        ? CustomTextStyle.body3.copyWith(color: red)
                                        : CustomTextStyle.body3,
                              ),
                              const Gap(defaultGapS),
                              Visibility(
                                visible: isDeadlineSoon && !selectedDateTodoList.isDone,
                                child: Text(
                                  '미뤄진 일',
                                  style: CustomTextStyle.body3.copyWith(color: red),
                                ),
                              ),
                            ],
                          ),
                          const Gap(defaultGapS / 4),
                          Row(
                            children: [
                              TodoUrgencyImportanceCard(
                                color: urgencyImportanceColor(selectedDateTodoList.isDone, selectedDateTodoList.urgency, selectedDateTodoList.importance),
                                content: '긴급도: ${selectedDateTodoList.urgency.toInt()}',
                                isCompleted: selectedDateTodoList.isDone,
                              ),
                              const Gap(defaultGapS),
                              TodoUrgencyImportanceCard(
                                color: urgencyImportanceColor(selectedDateTodoList.isDone, selectedDateTodoList.urgency, selectedDateTodoList.importance),
                                content: '중요도: ${selectedDateTodoList.importance.toInt()}',
                                isCompleted: selectedDateTodoList.isDone,
                              ),
                            ],
                          ),
                          if (index != selectedDateTodoData.length - 1)
                            const Column(
                              children: [
                                Gap(defaultGapS),
                                CustomDivider(),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          if (selectedDateTodoData.isEmpty)
            Text(
              '할 일이 없어요.',
              style: CustomTextStyle.body3,
            ),
        ],
      ),
    );
  }

  Color urgencyImportanceColor(bool isDone, double urgency, double importance) {
    if (isDone) {
      return gray;
    } else {
      if (urgency >= 5 && importance >= 5) {
        return red;
      } else if (urgency >= 5 && importance < 5) {
        return blue;
      } else if (urgency < 5 && importance >= 5) {
        return orange;
      } else {
        return green;
      }
    }
  }

  void _onCheck(BuildContext context, WidgetRef ref, int id) {
    ref.read(todoProvider.notifier).toggleTodo(id);
    GeneralSnackBar.showSnackBar(context, '할 일을 완료했어요.');
  }

  Future<dynamic> _pushDetailPage(BuildContext context, Todo dailyTodoData) {
    return Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => (dailyTodoData.isDone) ? TodoDetailCompletedPage(todoData: dailyTodoData) : TodoDetailUncompletedPage(todoData: dailyTodoData),
      ),
    );
  }
}
