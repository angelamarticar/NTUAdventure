import 'package:flutter/material.dart';
import 'package:ntuadventure/pages/course_page.dart'; // Import the CoursePage
import 'package:ntuadventure/db_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDatabase(); // Initialize the database
  runApp(CourseApp());
}

Future<void> initializeDatabase() async {
  final dbHelper = DatabaseHelper();
  await dbHelper.database; // Ensure the database is created
  //await dbHelper.insertDummyData(); // Populate the database with dummy data
}

class CourseApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Course Explorer',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: CoursePage(), // Set the home page to CoursePage
      debugShowCheckedModeBanner: false,
    );
  }
}
