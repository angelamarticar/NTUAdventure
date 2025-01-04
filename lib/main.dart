import 'package:flutter/material.dart';
import 'package:ntuadventure/pages/calendar_page.dart';
import 'package:ntuadventure/pages/home_page.dart';
import 'package:ntuadventure/pages/login_page.dart';
import 'package:ntuadventure/pages/map_page.dart';
import 'package:ntuadventure/pages/course_page.dart';
import 'package:ntuadventure/theme/theme_helper.dart';
import 'package:ntuadventure/db_helper.dart'; // Import your DatabaseHelper class

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensures Flutter bindings are initialized
  await initializeDatabase(); // Initialize the database
  runApp(CourseApp());
}

Future<void> initializeDatabase() async {
  final dbHelper = DatabaseHelper();
  await dbHelper.database; // This ensures the database is created
  await dbHelper.insertDummyData(); // Populate the database with dummy data
}

class CourseApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ntuAdventure',
      theme: ThemeHelper().themedata(),
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
