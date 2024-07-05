import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plus_todo/pages/home/home_page.dart';
import 'package:plus_todo/pages/todo/interaction/todo_interaction_create_page.dart';
import 'package:plus_todo/pages/todo/todo_page.dart';
import 'package:plus_todo/providers/navigatation/navigation_provider.dart';
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
          Container(),
          const TodoPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        backgroundColor: background,
        selectedItemColor: black,
        unselectedItemColor: gray,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (index) {
          if (index == 1) {
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
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box_rounded),
            label: 'Add Todo',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.view_list_rounded),
            label: 'Todo List',
          ),
        ],
      ),
    );
  }
}
