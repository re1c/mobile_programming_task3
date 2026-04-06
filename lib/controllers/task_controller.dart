import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:hive_ce/hive.dart';
import '../models/task.dart';
import '../services/database_service.dart';

class TaskController {
  // Simpan data di memori jika Hive atau Isar gagal inisialisasi. 
  // Ini adalah "Safety Net" agar UI tidak pernah blank.
  static final List<Task> _memoryTasks = [];
  
  // Stream untuk mengabarkan perubahan data ke UI secara real-time.
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
    // Kita ambil key dari Hive dan jadikan ID objek Task.
    return DatabaseService.tasksBox!.values
        .map((e) {
          final map = Map<String, dynamic>.from(e);
          return Task.fromMap(map);
        })
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  // Menambah data baru ke Hive untuk Web (Chrome).
  // Menggunakan Safe Auto-Increment untuk menghindari error 32-bit di Web.
  Future<void> addTask(String title, String description) async {
    final task = Task()
      ..title = title
      ..description = description
      ..createdAt = DateTime.now()
      ..isDone = false;

    if (DatabaseService.tasksBox != null) {
      // Biarkan Hive membuat key otomatis (0, 1, 2...) yang aman untuk sistem 32-bit Web.
      final int key = await DatabaseService.tasksBox!.add(task.toMap());
      
      // Update ID objek dengan key baru tersebut dan simpan ulang agar data sinkron.
      task.id = key;
      await DatabaseService.tasksBox!.put(key, task.toMap());
      
      _refreshHive();
    } else {
      // Fallback ke memori jika database tidak aktif.
      task.id = DateTime.now().millisecondsSinceEpoch;
      _memoryTasks.add(task);
      _sortMemoryTasks();
      _dataStreamController.add(List.from(_memoryTasks));
    }
  }

  // Memperbarui data task yang sudah ada.
  Future<void> updateTask(Task task) async {
    if (DatabaseService.tasksBox != null) {
      // Di Hive, mengupdate data cukup dengan melakukan put() pada key yang sama.
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

  // Menandai tugas sebagai selesai atau belum.
  Future<void> toggleDone(Task task) async {
    task.isDone = !task.isDone;
    await updateTask(task);
  }

  // Menghapus data task dari Hive atau memori.
  Future<void> deleteTask(int id) async {
    if (DatabaseService.tasksBox != null) {
      await DatabaseService.tasksBox!.delete(id);
      _refreshHive();
    } else {
      _memoryTasks.removeWhere((t) => t.id == id);
      _dataStreamController.add(List.from(_memoryTasks));
    }
  }

  // Menjaga agar list di memori selalu urut dari yang terbaru.
  void _sortMemoryTasks() {
    _memoryTasks.sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }
}
