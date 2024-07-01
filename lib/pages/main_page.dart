import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plus_todo/pages/home/home_page.dart';
import 'package:plus_todo/pages/todo/todo_list_page.dart';
import 'package:plus_todo/provider/provider_navigation.dart';
import 'package:plus_todo/themes/custom_color.dart';

class MainPage extends ConsumerWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(selectedIndexProvider);
    return Scaffold(
      body: IndexedStack(
        index: selectedIndex,
        children: const [
          HomePage(),
          TodoListPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        elevation: 0,
        backgroundColor: white,
        selectedItemColor: black,
        unselectedItemColor: gray,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (index) {
          ref.read(selectedIndexProvider.notifier).state = index;
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
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
