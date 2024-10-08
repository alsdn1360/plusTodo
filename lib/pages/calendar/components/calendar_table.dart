import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plus_todo/models/todo.dart';
import 'package:plus_todo/pages/todo/interaction/todo_interaction_create_page.dart';
import 'package:plus_todo/providers/calendar/calendar_week_setting.dart';
import 'package:plus_todo/providers/calendar/calendar_date_provider.dart';
import 'package:plus_todo/themes/custom_color.dart';
import 'package:plus_todo/themes/custom_decoration.dart';
import 'package:plus_todo/themes/custom_font.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarTable extends ConsumerStatefulWidget {
  final List<Todo> todoData;

  const CalendarTable({
    super.key,
    required this.todoData,
  });

  @override
  ConsumerState<CalendarTable> createState() => _CalendarTableState();
}

class _CalendarTableState extends ConsumerState<CalendarTable> {
  @override
  Widget build(BuildContext context) {
    final DateTime todoFocusedDate = ref.watch(calendarFocusedDateProvider);
    final lastSelectedDate = ref.watch(calendarLastedSelectedDateProvider);
    final startingWeekday = ref.watch(calendarWeekSettingProvider.select((value) => value['startingWeekday']));
    final saturdayHighlight = ref.watch(calendarWeekSettingProvider.select((value) => value['saturdayHighlight']));
    final sundayHighlight = ref.watch(calendarWeekSettingProvider.select((value) => value['sundayHighlight']));

    return Container(
      padding: const EdgeInsets.all(defaultPaddingS),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(defaultBorderRadiusM),
        border: Border.all(color: gray.withOpacity(0.2), width: 0.2),
      ),
      child: TableCalendar(
        locale: 'ko_KR',
        focusedDay: todoFocusedDate,
        firstDay: DateTime.utc(2000, 2, 10),
        lastDay: DateTime.utc(2099, 12, 31),
        startingDayOfWeek: startingWeekday == 1 ? StartingDayOfWeek.monday : StartingDayOfWeek.sunday,
        daysOfWeekHeight: MediaQuery.of(context).size.height / 28,
        rowHeight: MediaQuery.of(context).size.height / 14,
        availableGestures: AvailableGestures.horizontalSwipe,
        pageJumpingEnabled: true,
        pageAnimationCurve: Curves.easeOutQuad,
        pageAnimationDuration: const Duration(milliseconds: 400),
        sixWeekMonthsEnforced: true,
        eventLoader: (day) {
          return widget.todoData
              .where((todo) => todo.deadline?.year == day.year && todo.deadline?.month == day.month && todo.deadline?.day == day.day)
              .toList();
        },
        onDaySelected: (selectedDay, focusedDay) {
          if (isSameDay(selectedDay, lastSelectedDate)) {
            Navigator.of(context).push(
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
                    child: TodoInteractionCreatePage(initialSelectedDate: selectedDay),
                  );
                },
              ),
            );
          } else {
            setState(() {
              ref.read(calendarFocusedDateProvider.notifier).state = focusedDay;
              ref.read(calendarSelectedDateProvider.notifier).state = selectedDay;
              ref.read(calendarLastedSelectedDateProvider.notifier).state = selectedDay;
            });
          }
        },
        selectedDayPredicate: (DateTime day) {
          DateTime selectedDay = ref.watch(calendarSelectedDateProvider);
          DateTime now = DateTime.now();
          DateTime today = DateTime(now.year, now.month, now.day);

          return isSameDay(selectedDay, day) && !isSameDay(day, today);
        },
        headerStyle: HeaderStyle(
          titleCentered: true,
          formatButtonVisible: false,
          titleTextStyle: CustomTextStyle.title3,
          headerPadding: EdgeInsets.zero,
          leftChevronIcon: const Icon(Icons.chevron_left_rounded, color: gray, size: 24),
          rightChevronIcon: const Icon(Icons.chevron_right_rounded, color: gray, size: 24),
        ),
        calendarBuilders: CalendarBuilders(
          dowBuilder: (context, day) {
            switch (day.weekday) {
              case 1:
                return Center(child: Text('월', style: CustomTextStyle.body3));
              case 2:
                return Center(child: Text('화', style: CustomTextStyle.body3));
              case 3:
                return Center(child: Text('수', style: CustomTextStyle.body3));
              case 4:
                return Center(child: Text('목', style: CustomTextStyle.body3));
              case 5:
                return Center(child: Text('금', style: CustomTextStyle.body3));
              case 6:
                return Center(child: Text('토', style: CustomTextStyle.body3.copyWith(color: saturdayHighlight ? blue : gray)));
              case 7:
                return Center(child: Text('일', style: CustomTextStyle.body3.copyWith(color: sundayHighlight ? red : gray)));
            }
            return null;
          },
          defaultBuilder: (context, day, focusedDay) {
            return Padding(
              padding: const EdgeInsets.only(top: defaultPaddingL / 2),
              child: Align(
                alignment: Alignment.topCenter,
                child: Text(
                  day.day.toString(),
                  style: CustomTextStyle.body3.copyWith(
                    color: day.weekday == 6 && saturdayHighlight
                        ? blue
                        : day.weekday == 7 && sundayHighlight
                            ? red
                            : day.weekday == 6 || day.weekday == 7
                                ? gray
                                : black,
                  ),
                ),
              ),
            );
          },
          outsideBuilder: (context, day, focusedDay) {
            return Padding(
              padding: const EdgeInsets.only(top: defaultPaddingL / 2),
              child: Align(
                alignment: Alignment.topCenter,
                child: Text(
                  day.day.toString(),
                  style: CustomTextStyle.body3.copyWith(color: gray),
                ),
              ),
            );
          },
          todayBuilder: (context, day, focusedDay) {
            return Stack(
              children: [
                Container(
                  margin: const EdgeInsets.all(defaultPaddingS / 4),
                  decoration: BoxDecoration(
                    color: black.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(defaultBorderRadiusM / 2),
                    border: Border.all(
                      color: gray,
                      width: 1,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: defaultPaddingL / 2),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      day.day.toString(),
                      style: CustomTextStyle.body3.copyWith(
                        color: day.weekday == 6 && saturdayHighlight
                            ? blue
                            : day.weekday == 7 && sundayHighlight
                                ? red
                                : day.weekday == 6 || day.weekday == 7
                                    ? gray
                                    : black,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
          selectedBuilder: (context, day, focusedDay) {
            return Stack(
              children: [
                Container(
                  margin: const EdgeInsets.all(defaultPaddingS / 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(defaultBorderRadiusM / 2),
                    border: Border.all(
                      color: gray,
                      width: 1,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: defaultPaddingL / 2),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      day.day.toString(),
                      style: CustomTextStyle.body3.copyWith(
                        color: day.weekday == 6 && saturdayHighlight
                            ? blue
                            : day.weekday == 7 && sundayHighlight
                                ? red
                                : day.weekday == 6 || day.weekday == 7
                                    ? gray
                                    : black,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
          markerBuilder: (context, day, events) {
            if (events.length >= 4) {
              return Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: 22,
                  height: 6,
                  margin: const EdgeInsets.only(bottom: defaultPaddingL / 2),
                  decoration: BoxDecoration(
                    color: black,
                    borderRadius: BorderRadius.circular(defaultBorderRadiusM),
                  ),
                ),
              );
            } else {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  events.length,
                  (index) => Container(
                    width: 6,
                    height: 6,
                    margin: const EdgeInsets.only(
                      left: defaultPaddingS / 16,
                      right: defaultPaddingS / 16,
                      bottom: defaultPaddingL / 2,
                    ),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: black,
                    ),
                  ),
                ),
              );
            }
          },
        ),
        calendarStyle: CalendarStyle(
          rowDecoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: black.withOpacity(0.1), width: 1),
            ),
          ),
        ),
      ),
    );
  }
}
