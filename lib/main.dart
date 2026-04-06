import 'package:flutter/material.dart';
import 'services/database_service.dart';
import 'views/home_view.dart';

void main() async {
  // Ensure Flutter framework is fully initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize the Isar database service
  // This will handle library loading for Web and path setup for Mobile
  await DatabaseService.initialize();

  // Run the application
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Task Master CRUD',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          primary: Colors.teal,
        ),
        useMaterial3: true,
        fontFamily: 'Roboto', // Premium modern feel
      ),
      home: const HomeView(),
    );
  }
}
