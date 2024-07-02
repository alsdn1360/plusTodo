import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plus_todo/data/todo_data.dart';
import 'package:plus_todo/provider/todo/provider_todo.dart';
import 'package:shared_preferences/shared_preferences.dart';

final completedTodoListProvider = StateNotifierProvider<CompletedTodoListNotifier, List<TodoData>>((ref) {
  return CompletedTodoListNotifier();
});

class CompletedTodoListNotifier extends StateNotifier<List<TodoData>> {
  CompletedTodoListNotifier() : super([]);

  Future<void> _saveCompletedTodo() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final completedTodoList = state.map((e) => json.encode(e.toJson())).toList();
      await prefs.setStringList('completedTodoList', completedTodoList);
    } catch (e) {
      print('Failed to save todos: $e');
    }
  }

  Future<void> addCompletedTodo(TodoData todo) async {
    try {
      state = [...state, todo];
      await _saveCompletedTodo();
    } catch (e) {
      print('Failed to add completed todo: $e');
    }
  }

  Future<void> undoCompletedTodo(int index, WidgetRef ref) async {
    var undoCompleteTodo = state[index];
    try {
      state = List.from(state)..removeAt(index);
      await _saveCompletedTodo();
      ref.read(todoListProvider.notifier).addTodo(undoCompleteTodo);
    } catch (e) {
      print('Failed to remove todo: $e');
    }
  }


  void removeCompletedTodo(int index) {
    state = List.from(state)..removeAt(index);
  }
}
