import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:plus_todo/functions/general_format_time.dart';
import 'package:plus_todo/models/day_of_week.dart';
import 'package:plus_todo/models/todo.dart';
import 'package:plus_todo/notification/notification.dart';
import 'package:plus_todo/notification/notification_daily.dart';

final todoProvider = StateNotifierProvider<TodoNotifier, List<Todo>>((ref) {
  return TodoNotifier();
});

class TodoNotifier extends StateNotifier<List<Todo>> {
  late final Isar _isar;
  int? minutesBefore;
  int? dailyNotiHour;
  int? dailyNotiMinute;

  TodoNotifier() : super([]) {
    _initIsar();
    _scheduleDailyTodoCountNotification();
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

  Future<void> _scheduleDailyTodoCountNotification() async {
    final count = await _countTodosForToday();
    await dailyNotification(
      idx: 0,
      title: '오늘 해야 할 일을 확인하세요!',
      content: '$count개의 항목이 있어요.',
      notiHour: dailyNotiHour ?? 9,
      notiMinute: dailyNotiMinute ?? 0,
    );
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
          title: todoData.title,
          content: _deadlineFormatted(todoData.deadline!),
          minutesBefore: minutesBefore ?? 30,
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
          title: updatedTodo.title,
          content: _deadlineFormatted(updatedTodo.deadline!),
          minutesBefore: minutesBefore ?? 30,
        );
      } else {
        await cancelNotification(updatedTodo.id);
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
      await cancelNotification(id);
      state = state.where((todo) => todo.id != id).toList();
    } catch (e) {
      print('Failed to delete todo: $e');
    }
  }

  Future<void> clearCompletedTodo() async {
    try {
      await _isar.writeTxn(() async {
        final completedTodos = await _isar.todos.filter().isDoneEqualTo(true).findAll();
        for (var todo in completedTodos) {
          await cancelNotification(todo.id);
        }
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
          if (existingTodo.isDone) {
            await cancelNotification(id);
          } else if (existingTodo.deadline != null) {
            await sendNotification(
              idx: existingTodo.id,
              date: existingTodo.deadline!,
              title: existingTodo.title,
              content: _deadlineFormatted(existingTodo.deadline!),
              minutesBefore: minutesBefore ?? 30,
            );
          }
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

  Future<void> updateNotificationForAllTodos(int minute) async {
    try {
      final todos = await _isar.todos.filter().isDoneEqualTo(false).findAll();

      for (final todo in todos) {
        if (todo.deadline != null) {
          await sendNotification(
            idx: todo.id,
            date: todo.deadline!,
            title: todo.title,
            content: _deadlineFormatted(todo.deadline!),
            minutesBefore: minutesBefore ?? 30,
          );
        }
      }
    } catch (e) {
      print('Failed to schedule notifications for all todos: $e');
    }
  }

  void updateNotificationSettings(int newMinutesBefore) {
    minutesBefore = newMinutesBefore;
  }

  Future<void> updateDailyNotificationSettings(int newHour, int newMinute) async {
    final count = await _countTodosForToday();
    await dailyNotification(
      idx: 0,
      title: '오늘 해야 할 일을 확인하세요!',
      content: '$count개의 항목이 있어요.',
      notiHour: newHour,
      notiMinute: newMinute,
    );
  }

  Future<int> _countTodosForToday() async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day, 0, 0, 0);
    final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);
    final todosForToday = await _isar.todos.filter().deadlineBetween(startOfDay, endOfDay).and().isDoneEqualTo(false).findAll();
    return todosForToday.length;
  }

  String _deadlineFormatted(DateTime deadline) {
    return '${deadline.year}년 ${deadline.month}월 ${deadline.day}일(${dayOfWeekToKorean(DayOfWeek.values[deadline.weekday - 1])}) '
        '${GeneralFormatTime.formatTime(deadline)}까지';
  }
}
