import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plus_todo/models/todo.dart';
import 'package:plus_todo/providers/todo/todo_provider.dart';

final todoCompletedProvider = Provider<List<Todo>>((ref) {
  final todos = ref.watch(todoProvider);
  return todos.where((todo) => todo.isDone).toList()..sort((a, b) => a.deadline!.compareTo(b.deadline!));
});
