import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:hive_ce/hive.dart';
import '../models/task.dart';
import '../services/database_service.dart';

class TaskController {
  // Shared In-memory storage (fallback if Hive fails)
  static final List<Task> _memoryTasks = [];
  
  // Stream controller to broadcast state changes
  static final _dataStreamController = StreamController<List<Task>>.broadcast();

  /// Watches all tasks. Returns a persistent stream from Hive (Web) or Isar (Mobile).
  Stream<List<Task>> watchTasks() {
    if (DatabaseService.tasksBox != null) {
      // Return a stream that emits from the Hive box whenever it changes.
      // We use 'asBroadcastStream' and 'onListen' to ensure the first event is sent.
      return DatabaseService.tasksBox!.watch().map((_) => _getTasksFromHive())
          .asBroadcastStream(onListen: (_) => _refreshHive());
    }
    
    // Fallback: Memory stream
    _dataStreamController.add(List.from(_memoryTasks));
    return _dataStreamController.stream;
  }

  void _refreshHive() {
    _dataStreamController.add(_getTasksFromHive());
  }

  List<Task> _getTasksFromHive() {
    if (DatabaseService.tasksBox == null) return [];
    
    // Map Hive data back to Task objects and sort by newest first.
    return DatabaseService.tasksBox!.values
        .map((e) => Task.fromMap(Map<String, dynamic>.from(e)))
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  /// Adds a new task. Persists to Hive Box on Web.
  Future<void> addTask(String title, String description) async {
    final task = Task()
      ..id = DateTime.now().millisecondsSinceEpoch
      ..title = title
      ..description = description
      ..createdAt = DateTime.now()
      ..isDone = false;

    if (DatabaseService.tasksBox != null) {
      await DatabaseService.tasksBox!.put(task.id, task.toMap());
      _refreshHive();
    } else {
      // Memory fallback
      _memoryTasks.add(task);
      _sortMemoryTasks();
      _dataStreamController.add(List.from(_memoryTasks));
    }
  }

  /// Updates an existing task.
  Future<void> updateTask(Task task) async {
    if (DatabaseService.tasksBox != null) {
      await DatabaseService.tasksBox!.put(task.id, task.toMap());
      _refreshHive();
    } else {
      final index = _memoryTasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        _memoryTasks[index] = task;
        _dataStreamController.add(List.from(_memoryTasks));
      }
    }
  }

  /// Toggles the completion status.
  Future<void> toggleDone(Task task) async {
    task.isDone = !task.isDone;
    await updateTask(task);
  }

  /// Deletes a task from the persistent store.
  Future<void> deleteTask(int id) async {
    if (DatabaseService.tasksBox != null) {
      await DatabaseService.tasksBox!.delete(id);
      _refreshHive();
    } else {
      _memoryTasks.removeWhere((t) => t.id == id);
      _dataStreamController.add(List.from(_memoryTasks));
    }
  }

  /// Helper to keep memory tasks sorted by creation date (newest first).
  void _sortMemoryTasks() {
    _memoryTasks.sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }
}
