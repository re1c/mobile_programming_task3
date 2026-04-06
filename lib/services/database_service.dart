import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';
import '../models/task.dart';

class DatabaseService {
  static late Isar isar;

  /// Initializes the Isar database instance.
  /// Handles both Mobile (using path_provider) and Web (using IndexedDB).
  static Future<void> initialize() async {
    if (Isar.instanceNames.isEmpty) {
      String? directory;
      
      if (!kIsWeb) {
        final dir = await getApplicationDocumentsDirectory();
        directory = dir.path;
      }

      // Open Isar with the Task collection
      isar = await Isar.open(
        [TaskSchema],
        directory: directory ?? '', // Directory is ignored on Web
        inspector: true,
      );
    } else {
      isar = Isar.getInstance()!;
    }
  }
}
