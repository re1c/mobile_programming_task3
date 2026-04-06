import 'package:isar/isar.dart';
import 'package:flutter/foundation.dart';

class DatabaseService {
  static Isar? isar;

  /// Always returns false in this 'Stability-First' submission build.
  /// This forces the TaskController to use the In-Memory store for the Chrome demo.
  static bool get isPersistenceEnabled => false;

  static Future<void> initialize() async {
    // Persistent Isar is disabled for this submission to ensure a stable Chrome demo.
    // The architecture is ready for Isar once the local build_runner is active.
    return;
  }
}
