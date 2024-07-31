import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plus_todo/pages/calendar/calendar_page.dart';
import 'package:plus_todo/pages/home/home_page.dart';
import 'package:plus_todo/pages/setting/setting_page.dart';
import 'package:plus_todo/pages/todo/interaction/todo_interaction_create_page.dart';
import 'package:plus_todo/pages/todo/todo_page.dart';
import 'package:plus_todo/providers/navigation/navigation_provider.dart';
import 'package:plus_todo/themes/custom_color.dart';

class MainPage extends ConsumerWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(selectedIndexProvider);
    return Scaffold(
      body: IndexedStack(
        index: selectedIndex,
        children: [
          const HomePage(),
          const CalendarPage(),
          Container(),
          const TodoPage(),
          const SettingPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        backgroundColor: background,
        selectedItemColor: black,
        unselectedItemColor: black.withOpacity(0.3),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (index) {
          if (index == 2) {
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
                    child: const TodoInteractionCreatePage(),
                  );
                },
              ),
            );
          } else {
            ref.read(selectedIndexProvider.notifier).state = index;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_rounded),
            label: '할 일 캘린더',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box_rounded),
            label: '새로운 할 일',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.view_list_rounded),
            label: '할 일 목록',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_rounded),
            label: '설정',
          ),
        ],
      ),
    );
  }
}
