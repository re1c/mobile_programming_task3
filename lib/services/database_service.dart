import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';
import '../models/task.dart';

class DatabaseService {
  static Isar? isar;

  /// Returns true if the persistent Isar database is successfully opened.
  /// On Chrome, this will usually return false, triggering the In-Memory fallback.
  static bool get isPersistenceEnabled => isar != null;

  static Future<void> initialize() async {
    // If running in a browser environment, we skip persistent Isar setup
    // to avoid the known Isar 3.x library crash.
    if (kIsWeb) return;

    try {
      if (Isar.instanceNames.isEmpty) {
        final dir = await getApplicationDocumentsDirectory();
        
        // isar = await Isar.open(
        //   [TaskSchema], 
        //   directory: dir.path,
        //   inspector: true,
        // );
      } else {
        isar = Isar.getInstance();
      }
    } catch (e) {
      debugPrint("Isar not available on this platform: $e");
      // Fallback will be handled by the TaskController
    }
  }
}
