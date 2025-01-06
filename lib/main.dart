
import 'package:flutter/material.dart';
import 'package:ntuadventure/pages/calendar_page.dart';
import 'package:ntuadventure/pages/home_page.dart';
import 'package:ntuadventure/pages/login_page.dart';
import 'package:ntuadventure/pages/map_page.dart';
import 'package:ntuadventure/pages/course_page.dart';
import 'package:ntuadventure/theme/theme_helper.dart';
import 'package:ntuadventure/db_helper.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensures Flutter bindings are initialized
  final dbHelper = DatabaseHelper();

  await dbHelper.resetDatabase(); // Reset database
  await printDatabaseContents();
  runApp(CourseApp());
}

class CourseApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NTUAdventure',
      theme: ThemeHelper().themedata(),
      home: HomePage(), // Set the default home page
      debugShowCheckedModeBanner: false, // Disable the debug banner
    );
  }
}

Future<void> printDatabaseContents() async {
  final dbHelper = DatabaseHelper();
  final db = await dbHelper.database;

  // List of tables to query
  final tables = ['users', 'courses', 'ratings', 'events', 'trip_signups'];

  print('\n======= DATABASE CONTENT =======');
  for (String table in tables) {
    print('\nTable: $table');
    final rows = await dbHelper.getAll(table);
    if (rows.isEmpty) {
      print('No data found.');
    } else {
      for (var row in rows) {
        print(row);
      }
    }
  }
  print('======= END OF DATABASE =======\n');
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Database Printer',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Database Printer'),
        ),
        body: Center(
          child: Text('Check your terminal for the database content!'),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

