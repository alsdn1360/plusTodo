// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plus_todo/models/todo.dart';
import 'package:plus_todo/providers/todo/todo_uncompleted_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

final todoCompletedProvider = StateNotifierProvider<TodoCompletedNotifier, List<Todo>>((ref) {
  return TodoCompletedNotifier([]);
});

class TodoCompletedNotifier extends StateNotifier<List<Todo>> {
  TodoCompletedNotifier(super.state) {
    _loadCompletedTodoList();
  }

  Future<void> _loadCompletedTodoList() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final completedTodoList = prefs.getStringList('completedTodoList') ?? [];
      state = completedTodoList.map((e) => Todo.fromJson(json.decode(e))).toList();
    } catch (e) {
      print('완료된 할 일 목록 불러오기 실패: $e');
    }
  }

  Future<void> _saveCompletedTodo() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final completedTodoList = state.map((e) => json.encode(e.toJson())).toList();
      await prefs.setStringList('completedTodoList', completedTodoList);
    } catch (e) {
      print('완료된 할 일 저장 실패: $e');
    }
  }

  Future<void> addCompletedTodo(Todo todo) async {
    try {
      state = [...state, todo];
      await _saveCompletedTodo();
    } catch (e) {
      print('완료된 할 일로 추가 실패: $e');
    }
  }

  Future<void> deleteCompletedTodoAt(int index) async {
    try {
      state = List.from(state)..removeAt(index);
      await _saveCompletedTodo();
    } catch (e) {
      print('완료된 할 일 삭제 실패: $e');
    }
  }

  Future<void> undoCompletedTodo(int index, WidgetRef ref) async {
    var undoCompleteTodo = state[index];

    try {
      await toggleDone(index);
      state = List.from(state)..removeAt(index);
      await _saveCompletedTodo();
      ref.read(todoUncompletedProvider.notifier).createUncompletedTodo(undoCompleteTodo);
    } catch (e) {
      print('완료된 할 일 되돌리기 실패: $e');
    }
  }

  Future<void> clearCompletedTodo() async {
    try {
      state = [];
      await _saveCompletedTodo();
    } catch (e) {
      print('완료된 할 일 일괄 삭제 실패: $e');
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
      print('토글 실패: $e');
    }
  }
}
