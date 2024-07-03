import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plus_todo/data/todo_data.dart';
import 'package:plus_todo/provider/todo/todo_completed_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

final todoUncompletedProvider = StateNotifierProvider<TodoUncompletedNotifier, List<TodoData>>((ref) {
  return TodoUncompletedNotifier([]);
});

class TodoUncompletedNotifier extends StateNotifier<List<TodoData>> {
  TodoUncompletedNotifier(super.state) {
    _loadUncompletedTodoList();
  }

  Future<void> _loadUncompletedTodoList() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final todoList = prefs.getStringList('todoList') ?? [];
      state = todoList.map((e) => TodoData.fromJson(json.decode(e))).toList();
    } catch (e) {
      print('Failed to load todos: $e');
    }
  }

  Future<void> _saveUncompletedTodo() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final todoList = state.map((e) => json.encode(e.toJson())).toList();
      await prefs.setStringList('todoList', todoList);
    } catch (e) {
      print('Failed to save todos: $e');
    }
  }

  Future<void> addUncompletedTodo(TodoData todoData) async {
    try {
      state = [...state, todoData];
      await _saveUncompletedTodo();
    } catch (e) {
      print('Failed to add todo: $e');
    }
  }

  Future<void> updateUncompletedTodo(int index, TodoData todoData) async {
    try {
      state = [
        ...state.sublist(0, index),
        todoData,
        ...state.sublist(index + 1),
      ];
      await _saveUncompletedTodo();
    } catch (e) {
      print('Failed to update todo: $e');
    }
  }

  Future<void> deleteUncompletedTodoAt(int index) async {
    try {
      state = List.from(state)..removeAt(index);
      await _saveUncompletedTodo();
    } catch (e) {
      print('Failed to remove todo: $e');
    }
  }

  Future<void> completeTodo(int index, WidgetRef ref) async {
    var completedTodo = state[index];

    try {
      await toggleDone(index);
      state = List.from(state)..removeAt(index);
      await _saveUncompletedTodo();
      ref.read(todoCompletedProvider.notifier).addCompletedTodo(completedTodo);
    } catch (e) {
      print('Failed to remove todo: $e');
    }
  }

  Future<void> toggleDone(int index) async {
    var updatedTodo = state[index];
    updatedTodo.isDone = !updatedTodo.isDone;

    try {
      state = [
        ...state.sublist(0, index),
        updatedTodo,
        ...state.sublist(index + 1),
      ];
      _saveUncompletedTodo();
    } catch (e) {
      print('Failed to toggle done: $e');
    }
  }

  void refresh() {
    _loadUncompletedTodoList();
  }
}
