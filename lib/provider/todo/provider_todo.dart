import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plus_todo/data/todo_data.dart';
import 'package:plus_todo/provider/todo/provider_complete_todo.dart';
import 'package:shared_preferences/shared_preferences.dart';

final todoListProvider = StateNotifierProvider<TodoListNotifier, List<TodoData>>((ref) {
  return TodoListNotifier([]);
});

class TodoListNotifier extends StateNotifier<List<TodoData>> {
  TodoListNotifier(super.state) {
    _loadTodoList();
  }

  Future<void> _loadTodoList() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final todoList = prefs.getStringList('todoList') ?? [];
      state = todoList.map((e) => TodoData.fromJson(json.decode(e))).toList();
    } catch (e) {
      print('Failed to load todos: $e');
    }
  }

  Future<void> _saveTodo() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final todoList = state.map((e) => json.encode(e.toJson())).toList();
      await prefs.setStringList('todoList', todoList);
    } catch (e) {
      print('Failed to save todos: $e');
    }
  }

  Future<void> addTodo(TodoData todoData) async {
    try {
      state = [...state, todoData];
      await _saveTodo();
    } catch (e) {
      print('Failed to add todo: $e');
    }
  }

  Future<void> completeTodo(int index, WidgetRef ref) async {
    var completedTodo = state[index];

    try {
      await toggleDone(index);
      state = List.from(state)..removeAt(index);
      await _saveTodo();
      ref.read(completedTodoListProvider.notifier).addCompletedTodo(completedTodo);
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
      _saveTodo();
    } catch (e) {
      print('Failed to toggle done: $e');
    }
  }
}
