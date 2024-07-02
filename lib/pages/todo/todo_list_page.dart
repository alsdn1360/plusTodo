import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:plus_todo/data/todo_data.dart';
import 'package:plus_todo/pages/todo/components/todo_completed_card.dart';
import 'package:plus_todo/pages/todo/components/todo_uncompleted_card.dart';
import 'package:plus_todo/themes/custom_color.dart';
import 'package:plus_todo/themes/custom_decoration.dart';

class TodoListPage extends StatelessWidget {
  const TodoListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('할 일 목록'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: defaultPaddingM),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TodoUncompletedCard(
                  title: 'Do',
                  subtitle: '긴급하고 중요한 일',
                  color: red,
                  filter: (TodoData doData) => doData.urgency >= 5 && doData.importance >= 5,
                ),
                const Gap(defaultGapL),
                TodoUncompletedCard(
                  title: 'Delegate',
                  subtitle: '긴급하지만 중요하진 않은 일',
                  color: blue,
                  filter: (TodoData delegateData) => delegateData.urgency >= 5 && delegateData.importance < 5,
                ),
                const Gap(defaultGapL),
                TodoUncompletedCard(
                  title: 'Schedule',
                  subtitle: '긴급하진 않지만 중요한 일',
                  color: orange,
                  filter: (TodoData scheduleData) => scheduleData.urgency < 5 && scheduleData.importance >= 5,
                ),
                const Gap(defaultGapL),
                TodoUncompletedCard(
                  title: 'Eliminate',
                  subtitle: '긴급하지도 중요하지도 않은 일',
                  color: green,
                  filter: (TodoData eliminateData) => eliminateData.urgency < 5 && eliminateData.importance < 5,
                ),
                const Gap(defaultGapL),
                const TodoCompletedCard(),
                const Gap(defaultGapL),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
