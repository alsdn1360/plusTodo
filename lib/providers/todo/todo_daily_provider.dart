import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plus_todo/models/todo.dart';
import 'package:plus_todo/providers/todo/todo_provider.dart';

final todoDailyProvider = Provider<List<Todo>>((ref) {
  final todos = ref.watch(todoProvider);

  final now = DateTime.now();
  final startOfDay = DateTime(now.year, now.month, now.day, 0, 0, 0);
  final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

  return todos.where((todo) {
    return todo.deadline != null && todo.deadline!.isAfter(startOfDay) && todo.deadline!.isBefore(endOfDay) && !todo.isDone;
  }).toList();
});
