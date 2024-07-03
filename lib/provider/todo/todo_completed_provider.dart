import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plus_todo/data/todo_data.dart';
import 'package:plus_todo/provider/todo/todo_uncompleted_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

final todoCompletedProvider = StateNotifierProvider<TodoCompletedNotifier, List<TodoData>>((ref) {
  return TodoCompletedNotifier([]);
});

class TodoCompletedNotifier extends StateNotifier<List<TodoData>> {
  TodoCompletedNotifier(super.state) {
    _loadCompletedTodoList();
  }

  Future<void> _loadCompletedTodoList() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final completedTodoList = prefs.getStringList('completedTodoList') ?? [];
      state = completedTodoList.map((e) => TodoData.fromJson(json.decode(e))).toList();
    } catch (e) {
      print('Failed to load todos: $e');
    }
  }

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

  Future<void> deleteCompletedTodoAt(int index) async {
    try {
      state = List.from(state)..removeAt(index);
      await _saveCompletedTodo();
    } catch (e) {
      print('Failed to remove todo: $e');
    }
  }

  Future<void> undoCompletedTodo(int index, WidgetRef ref) async {
    var undoCompleteTodo = state[index];

    try {
      await toggleDone(index);
      state = List.from(state)..removeAt(index);
      await _saveCompletedTodo();
      ref.read(todoUncompletedProvider.notifier).addUncompletedTodo(undoCompleteTodo);
    } catch (e) {
      print('Failed to remove todo: $e');
    }
  }

  Future<void> clearCompletedTodo() async {
    try {
      state = [];
      await _saveCompletedTodo();
    } catch (e) {
      print('Failed to remove completed todo: $e');
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
      _saveCompletedTodo();
    } catch (e) {
      print('Failed to toggle done: $e');
    }
  }
}
