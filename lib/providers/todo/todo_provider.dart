import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:plus_todo/models/todo.dart';
import 'package:plus_todo/notification/notification.dart';

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
      print('Failed to load todos: $e');
    }
  }

  Future<void> createTodo(Todo todoData) async {
    try {
      state = [...state, todoData];
      await _isar.writeTxn(() async {
        await _isar.todos.put(todoData);
      });
      if (todoData.deadline != null && !todoData.isDone) {
        await sendNotification(
          idx: todoData.id,
          date: todoData.deadline!,
          title: '마감 시간이 1시간 남았어요!',
          content: todoData.title,
        );
      }
    } catch (e) {
      print('Failed to add todo: $e');
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
      if (updatedTodo.deadline != null && !updatedTodo.isDone) {
        await sendNotification(
          idx: updatedTodo.id,
          date: updatedTodo.deadline!,
          title: '마감 시간이 1시간 남았어요!',
          content: updatedTodo.title,
        );
      }
    } catch (e) {
      print('Failed to update todo: $e');
    }
  }

  Future<void> deleteTodo(int id) async {
    try {
      await _isar.writeTxn(() async {
        await _isar.todos.delete(id);
      });
      state = state.where((todo) => todo.id != id).toList();
    } catch (e) {
      print('Failed to delete todo: $e');
    }
  }

  Future<void> clearCompletedTodo() async {
    try {
      await _isar.writeTxn(() async {
        await _isar.todos.filter().isDoneEqualTo(true).deleteAll();
      });
      state = state.where((todo) => !todo.isDone).toList();
    } catch (e) {
      print('Failed to clear completed todos: $e');
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
      print('Failed to toggle todo: $e');
    }
  }
}
