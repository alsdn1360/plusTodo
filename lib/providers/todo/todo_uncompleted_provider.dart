// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plus_todo/models/todo.dart';
import 'package:plus_todo/providers/todo/todo_completed_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

final todoUncompletedProvider = StateNotifierProvider<TodoUncompletedNotifier, List<Todo>>((ref) {
  return TodoUncompletedNotifier([]);
});

class TodoUncompletedNotifier extends StateNotifier<List<Todo>> {
  TodoUncompletedNotifier(super.state) {
    _loadUncompletedTodoList();
  }

  Future<void> _loadUncompletedTodoList() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final todoList = prefs.getStringList('uncompletedTodoList') ?? [];
      state = todoList.map((e) => Todo.fromJson(json.decode(e))).toList();
    } catch (e) {
      print('할 일 목록 불러오기 실패: $e');
    }
  }

  Future<void> _saveUncompletedTodo() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final todoList = state.map((e) => json.encode(e.toJson())).toList();
      await prefs.setStringList('uncompletedTodoList', todoList);
    } catch (e) {
      print('할 일 저장 실패: $e');
    }
  }

  Future<void> createUncompletedTodo(Todo todoData) async {
    try {
      state = [...state, todoData];
      await _saveUncompletedTodo();
    } catch (e) {
      print('할 일로 추가 실패: $e');
    }
  }

  Future<void> updateUncompletedTodo(int index, Todo todoData) async {
    try {
      state = [
        ...state.sublist(0, index),
        todoData,
        ...state.sublist(index + 1),
      ];
      await _saveUncompletedTodo();
    } catch (e) {
      print('할 일 수정 실패: $e');
    }
  }

  Future<void> deleteUncompletedTodoAt(int index) async {
    try {
      state = List.from(state)..removeAt(index);
      await _saveUncompletedTodo();
    } catch (e) {
      print('할 일 삭제 실패: $e');
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
      print('할 일 완료 실패: $e');
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
      print('토글 실패: $e');
    }
  }
}
