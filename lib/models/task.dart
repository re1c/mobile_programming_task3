import 'package:isar/isar.dart';

// part 'task.g.dart';

@collection
class Task {
  Id id = Isar.autoIncrement;

  late String title;
  
  late String description;

  late DateTime createdAt;

  bool isDone = false;

  // Ubah Task ke Map supaya bisa disimpan di Hive Web.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'isDone': isDone,
    };
  }

  // Ambil data Map dari Hive dan jadikan objek Task lagi.
  static Task fromMap(Map<String, dynamic> map) {
    return Task()
      ..id = map['id'] ?? 0
      ..title = map['title'] ?? ''
      ..description = map['description'] ?? ''
      ..createdAt = DateTime.parse(map['createdAt'])
      ..isDone = map['isDone'] ?? false;
  }
}
