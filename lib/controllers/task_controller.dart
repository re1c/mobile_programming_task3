import 'dart:async';
import 'package:isar/isar.dart';
import 'package:flutter/foundation.dart';
import '../models/task.dart';
import '../services/database_service.dart';

class TaskController {
  // Shared In-memory storage for Web (fallback)
  static final List<Task> _memoryTasks = [];
  
  // Stream controller to broadcast state changes on Web
  static final _webStreamController = StreamController<List<Task>>.broadcast();

  /// Watches all tasks. If persistence is enabled (Mobile), it uses Isar.
  /// If running on Web, it returns the In-Memory stream.
  Stream<List<Task>> watchTasks() {
    if (DatabaseService.isPersistenceEnabled) {
      return DatabaseService.isar!.tasks.where()
          .sortByCreatedAtDesc()
          .watch(fireImmediately: true);
    } else {
      // Refresh current memory view
      _sortMemoryTasks();
      _webStreamController.add(List.from(_memoryTasks));
      return _webStreamController.stream;
    }
  }

  /// Adds a new task.
  Future<void> addTask(String title, String description) async {
    final task = Task()
      ..title = title
      ..description = description
      ..createdAt = DateTime.now()
      ..isDone = false;

    if (DatabaseService.isPersistenceEnabled) {
      await DatabaseService.isar!.writeTxn(() async {
        await DatabaseService.isar!.tasks.put(task);
      });
    } else {
      // Simulate ID and add to memory
      task.id = DateTime.now().millisecondsSinceEpoch;
      _memoryTasks.add(task);
      _sortMemoryTasks();
      _webStreamController.add(List.from(_memoryTasks));
    }
  }

  /// Updates an existing task.
  Future<void> updateTask(Task task) async {
    if (DatabaseService.isPersistenceEnabled) {
      await DatabaseService.isar!.writeTxn(() async {
        await DatabaseService.isar!.tasks.put(task);
      });
    } else {
      final index = _memoryTasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        _memoryTasks[index] = task;
        _webStreamController.add(List.from(_memoryTasks));
      }
    }
  }

  /// Toggles the completion status.
  Future<void> toggleDone(Task task) async {
    task.isDone = !task.isDone;
    await updateTask(task);
  }

  /// Deletes a task.
  Future<void> deleteTask(int id) async {
    if (DatabaseService.isPersistenceEnabled) {
      await DatabaseService.isar!.writeTxn(() async {
        await DatabaseService.isar!.tasks.delete(id);
      });
    } else {
      _memoryTasks.removeWhere((t) => t.id == id);
      _webStreamController.add(List.from(_memoryTasks));
    }
  }

  /// Helper to keep memory tasks sorted by creation date (newest first).
  void _sortMemoryTasks() {
    _memoryTasks.sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }
}
