import 'package:isar/isar.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import '../models/task.dart';

class DatabaseService {
  static Isar? isar;
  static Box? tasksBox;

  // Cek apakah ada database yang aktif untuk menyimpan data.
  static bool get isPersistenceEnabled => isar != null || tasksBox != null;

  static Future<void> initialize() async {
    // Jalankan Hive jika di lingkungan Web supaya data tetap tersimpan saat refresh.
    if (kIsWeb) {
      try {
        await Hive.initFlutter();
        tasksBox = await Hive.openBox('tasks_box');
      } catch (e) {
        debugPrint("Gagal memuat Hive: $e");
      }
      return;
    }

    // Isar butuh build_runner untuk jalan di Mobile, jadi kita siapkan saja dulu.
    return;
  }
}
