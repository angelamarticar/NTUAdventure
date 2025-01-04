import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String dbPath = await getDatabasesPath();
    String path = join(dbPath, 'app_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  // Enable foreign key support
  Future<void> _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  FutureOr<void> _onCreate(Database db, int version) async {
  // Create Courses Table
  await db.execute('''
    CREATE TABLE courses(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      description TEXT,
      school TEXT,
      FOREIGN KEY (prof_id) REFERENCES user (id) ON DELETE SET NULL

    )
  ''');

  // Create Ratings Table with Foreign Key
  await db.execute('''
    CREATE TABLE ratings(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      workload INTEGER,
      difficulty INTEGER,
      overall_rating INTEGER,
      language TEXT,
      semester TEXT,
      comment TEXT,
      FOREIGN KEY (course_id) REFERENCES courses (id) ON DELETE CASCADE
    )
  ''');

  // Create Events Table
  await db.execute('''
    CREATE TABLE events(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT NOT NULL,
      date TEXT NOT NULL,
      description TEXT,
      price DOUBLE,
      location TEXT
    )
  ''');
    await db.execute('''
    CREATE TABLE users(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      email TEXT NOT NULL UNIQUE,
      password TEXT NOT NULL,
      user_type TEXT CHECK(user_type IN ('student', 'professor')) NOT NULL
    )
  ''');
  }

  // Insert into Courses Table
  Future<int> insertCourse(Map<String, dynamic> course) async {
    final db = await database;
    return await db.insert('courses', course);
  }

  // Insert into Ratings Table
  Future<int> insertRating(Map<String, dynamic> rating) async {
    final db = await database;
    return await db.insert('ratings', rating);
  }

  // Insert into Events Table
  Future<int> insertEvent(Map<String, dynamic> event) async {
    final db = await database;
    return await db.insert('events', event);
  }

  // Fetch All Courses
  Future<List<Map<String, dynamic>>> getCourses() async {
    final db = await database;
    return await db.query('courses');
  }

  // Fetch All Ratings for a Course
  Future<List<Map<String, dynamic>>> getRatings(int courseId) async {
    final db = await database;
    return await db.query('ratings', where: 'course_id = ?', whereArgs: [courseId]);
  }

  // Fetch All Events
  Future<List<Map<String, dynamic>>> getEvents() async {
    final db = await database;
    return await db.query('events');
  }
}
