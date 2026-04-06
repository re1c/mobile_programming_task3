import 'package:isar/isar.dart';
import '../models/task.dart';
import '../services/database_service.dart';

class TaskController {
  final Isar isar = DatabaseService.isar;

  /// Fetch all tasks from the database, sorted by creation date (newest first).
  /// Returns a Stream that updates automatically when the database changes.
  Stream<List<Task>> watchTasks() {
    return isar.tasks.where().sortByCreatedAtDesc().watch(fireImmediately: true);
  }

  /// Add a new task to the database.
  Future<void> addTask(String title, String description) async {
    final task = Task()
      ..title = title
      ..description = description
      ..createdAt = DateTime.now()
      ..isDone = false;

    await isar.writeTxn(() async {
      await isar.tasks.put(task);
    });
  }

  /// Update an existing task in the database.
  Future<void> updateTask(Task task) async {
    await isar.writeTxn(() async {
      await isar.tasks.put(task);
    });
  }

  /// Toggle the completion status of a task.
  Future<void> toggleDone(Task task) async {
    task.isDone = !task.isDone;
    await updateTask(task);
  }

  /// Delete a task from the database by its ID.
  Future<void> deleteTask(int id) async {
    await isar.writeTxn(() async {
      await isar.tasks.delete(id);
    });
  }
}
