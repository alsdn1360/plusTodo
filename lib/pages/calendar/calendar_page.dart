import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:plus_todo/pages/calendar/components/calendar_selected_todo_card.dart';
import 'package:plus_todo/pages/calendar/components/calendar_table.dart';
import 'package:plus_todo/pages/calendar/components/calendar_today_button.dart';
import 'package:plus_todo/providers/todo/todo_uncompleted_provider.dart';
import 'package:plus_todo/themes/custom_decoration.dart';

class CalendarPage extends ConsumerWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todoData = ref.watch(todoUncompletedProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('할 일 캘린더'),
        actions: const [CalendarTodayButton()],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: defaultPaddingM),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CalendarTable(todoData: todoData),
                const Gap(defaultGapM),
                const CalendarSelectedTodoCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
