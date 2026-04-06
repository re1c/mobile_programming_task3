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

  // Fungsi untuk memantau perubahan data. 
  // Jika di Web pakai Hive, kalau Isar terdeteksi (Mobile) bisa pakai Isar.
  Stream<List<Task>> watchTasks() {
    if (DatabaseService.tasksBox != null) {
      // Mengamati box Hive dan memperbarui list setiap ada perubahan.
      return DatabaseService.tasksBox!.watch().map((_) => _getTasksFromHive())
          .asBroadcastStream(onListen: (_) => _refreshHive());
    }
    
    _dataStreamController.add(List.from(_memoryTasks));
    return _dataStreamController.stream;
  }

  void _refreshHive() {
    _dataStreamController.add(_getTasksFromHive());
  }

  List<Task> _getTasksFromHive() {
    if (DatabaseService.tasksBox == null) return [];
    
    // Konversi map dari Hive kembali ke objek Task.
    return DatabaseService.tasksBox!.values
        .map((e) => Task.fromMap(Map<String, dynamic>.from(e)))
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  // Menambah data baru ke Hive untuk Web.
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

  /// Toggles the completion status of a task.
  Future<void> toggleDone(Task task) async {
    task.isDone = !task.isDone;
    await updateTask(task);
  }

  /// Deletes a task from the persistent store or memory.
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
