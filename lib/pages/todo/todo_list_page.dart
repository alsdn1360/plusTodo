import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:plus_todo/pages/todo/components/todo_completed_card.dart';
import 'package:plus_todo/pages/todo/components/todo_delegate_card.dart';
import 'package:plus_todo/pages/todo/components/todo_do_card.dart';
import 'package:plus_todo/pages/todo/components/todo_eliminate_card.dart';
import 'package:plus_todo/pages/todo/components/todo_schedule_card.dart';
import 'package:plus_todo/themes/custom_decoration.dart';

class TodoListPage extends StatelessWidget {
  const TodoListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('할 일 목록'),
      ),
      body: const SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: defaultPaddingM),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TodoDoCard(),
                Gap(defaultGapL),
                TodoDelegateCard(),
                Gap(defaultGapL),
                TodoScheduleCard(),
                Gap(defaultGapL),
                TodoEliminateCard(),
                Gap(defaultGapL),
                TodoCompletedCard(),
                Gap(defaultGapL),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
