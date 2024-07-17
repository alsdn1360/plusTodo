import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

part 'todo.g.dart';

@collection
class Todo {
  Id id = Isar.autoIncrement;

  late String title;
  late String content;
  late double urgency;
  late double importance;
  late bool isDone;
  late DateTime? deadline;
  late int notificationTime = 0;

  Todo({
    required this.title,
    required this.content,
    required this.urgency,
    required this.importance,
    required this.isDone,
    required this.deadline,
    required this.notificationTime,
  });
}

Future<Isar> initIsar() async {
  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
    [TodoSchema],
    directory: dir.path,
  );
  return isar;
}