import 'package:isar/isar.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import '../models/task.dart';

class DatabaseService {
  static Isar? isar;
  static Box? tasksBox;

  /// Returns true if either Isar (Mobile) or Hive (Web) is successfully opened.
  static bool get isPersistenceEnabled => isar != null || tasksBox != null;

  static Future<void> initialize() async {
    // If running in a browser, initialize Hive for persistent Web storage.
    if (kIsWeb) {
      try {
        await Hive.initFlutter();
        tasksBox = await Hive.openBox('tasks_box');
      } catch (e) {
        debugPrint("Hive initialization failed: $e");
      }
      return;
    }

    // In this build, Isar is stubbed for stability until the build_runner is active locally.
    return;
  }
}
