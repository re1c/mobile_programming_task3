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

  /// Watches all tasks. Returns the reactive In-Memory stream.
  Stream<List<Task>> watchTasks() {
    _sortMemoryTasks();
    _webStreamController.add(List.from(_memoryTasks));
    return _webStreamController.stream;
  }

  /// Adds a new task. In this build, it focuses on stability for Chrome.
  Future<void> addTask(String title, String description) async {
    final task = Task()
      ..title = title
      ..description = description
      ..createdAt = DateTime.now()
      ..isDone = false;

    // Simulate ID and add to memory for the demonstration
    task.id = DateTime.now().millisecondsSinceEpoch;
    _memoryTasks.add(task);
    _sortMemoryTasks();
    _webStreamController.add(List.from(_memoryTasks));
  }

  /// Updates an existing task in memory.
  Future<void> updateTask(Task task) async {
    final index = _memoryTasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _memoryTasks[index] = task;
      _webStreamController.add(List.from(_memoryTasks));
    }
  }

  /// Toggles the completion status.
  Future<void> toggleDone(Task task) async {
    task.isDone = !task.isDone;
    await updateTask(task);
  }

  /// Deletes a task from the in-memory demo store.
  Future<void> deleteTask(int id) async {
    _memoryTasks.removeWhere((t) => t.id == id);
    _webStreamController.add(List.from(_memoryTasks));
  }

  /// Helper to keep memory tasks sorted by creation date (newest first).
  void _sortMemoryTasks() {
    _memoryTasks.sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }
}
