import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

part 'todo.g.dart';

@collection
class Todo {
  Id id = Isar.autoIncrement; // Isar는 자동 증가 ID를 제공합니다.

  late String title;
  late String content;
  late double urgency;
  late double importance;
  late bool isDone;

  Todo({
    required this.title,
    required this.content,
    required this.urgency,
    required this.importance,
    required this.isDone,
  });
}

Future<Isar> initIsar() async {
  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
    [TodoSchema], // 생성된 모델의 스키마를 여기서 지정합니다.
    directory: dir.path,
  );
  return isar;
}