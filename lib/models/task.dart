import 'package:isar/isar.dart';

part 'task.g.dart';

@collection
class Task {
  Id id = Isar.autoIncrement;

  late String title;
  
  late String description;

  late DateTime createdAt;

  bool isDone = false;
}
