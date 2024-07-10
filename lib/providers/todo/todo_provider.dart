// ignore_for_file: avoid_print

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:plus_todo/models/todo.dart';
import 'dart:async';

final todoProvider = StateNotifierProvider<TodoNotifier, List<Todo>>((ref) {
  return TodoNotifier();
});

class TodoNotifier extends StateNotifier<List<Todo>> {
  late final Isar _isar;

  TodoNotifier() : super([]) {
    _initIsar();
  }

  Future<void> _initIsar() async {
    _isar = await initIsar();
    _loadTodo();
  }

  Future<void> _loadTodo() async {
    try {
      final todoList = await _isar.todos.where().findAll();
      state = todoList;
    } catch (e) {
      print('할 일 목록 불러오기 실패: $e');
    }
  }

  Future<void> createTodo(Todo todoData) async {
    try {
      state = [...state, todoData];
      await _isar.writeTxn(() async {
        await _isar.todos.put(todoData);
      });
    } catch (e) {
      print('할 일로 추가 실패: $e');
    }
  }

  Future<void> updateTodo(int id, Todo updatedTodo) async {
    try {
      await _isar.writeTxn(() async {
        final updatingTodo = await _isar.todos.get(id);
        if (updatingTodo != null) {
          updatingTodo
            ..title = updatedTodo.title
            ..content = updatedTodo.content
            ..urgency = updatedTodo.urgency
            ..importance = updatedTodo.importance
            ..isDone = updatedTodo.isDone
            ..deadline = updatedTodo.deadline;
          await _isar.todos.put(updatingTodo);
        }
      });
      state = state.map((todo) => todo.id == id ? updatedTodo : todo).toList();
    } catch (e) {
      print('할 일 수정 실패: $e');
    }
  }

  Future<void> deleteTodo(int id) async {
    try {
      await _isar.writeTxn(() async {
        await _isar.todos.delete(id);
      });
      state = state.where((todo) => todo.id != id).toList();
    } catch (e) {
      print('할 일 삭제 실패: $e');
    }
  }

  Future<void> clearCompletedTodo() async {
    try {
      await _isar.writeTxn(() async {
        await _isar.todos.filter().isDoneEqualTo(true).deleteAll();
      });
      state = state.where((todo) => !todo.isDone).toList();
    } catch (e) {
      print('완료된 할 일 일괄 삭제 실패: $e');
    }
  }

  Future<void> toggleTodo(int id) async {
    try {
      await _isar.writeTxn(() async {
        final existingTodo = await _isar.todos.get(id);
        if (existingTodo != null) {
          existingTodo.isDone = !existingTodo.isDone;
          await _isar.todos.put(existingTodo);
        }
      });
      state = state.map((todo) {
        if (todo.id == id) {
          todo.isDone = !todo.isDone;
        }
        return todo;
      }).toList();
    } catch (e) {
      print('토글 실패: $e');
    }
  }
}
