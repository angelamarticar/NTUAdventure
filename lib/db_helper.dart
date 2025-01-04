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
    try {
      String dbPath = await getDatabasesPath();
      String path = join(dbPath, 'app_database.db');
      return await openDatabase(
        path,
        version: 1,
        onCreate: _onCreate,
        onConfigure: _onConfigure,
      );
    } catch (e) {
      throw Exception("Error initializing database: $e");
    }
  }

  Future<void> _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  FutureOr<void> _onCreate(Database db, int version) async {
    try {
      // Create Users Table
      await db.execute('''
        CREATE TABLE users(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          email TEXT NOT NULL UNIQUE,
          password TEXT NOT NULL,
          user_type TEXT CHECK(user_type IN ('student', 'professor')) NOT NULL
        )
      ''');

      // Create Courses Table
      await db.execute('''
        CREATE TABLE courses(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          description TEXT,
          school TEXT
        )
      ''');

      // Create Ratings Table
      await db.execute('''
        CREATE TABLE ratings(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          workload INTEGER,
          difficulty INTEGER,
          overall_rating INTEGER,
          language TEXT,
          semester TEXT,
          comment TEXT,
          course_id INTEGER,
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

      // Create Trip Signups Table
      await db.execute('''
        CREATE TABLE trip_signups(
          trip_id INTEGER NOT NULL,
          user_id INTEGER NOT NULL,
          signup_date TEXT NOT NULL,
          PRIMARY KEY (trip_id, user_id),
          FOREIGN KEY (trip_id) REFERENCES events (id) ON DELETE CASCADE,
          FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
        )
      ''');
    } catch (e) {
      throw Exception("Error creating tables: $e");
    }
  }

  Future<void> insertDummyData() async {
    final db = await database;

    // Dummy Courses Data
    List<Map<String, dynamic>> courses = [
      {
        'name': 'Warp Drive Mechanics',
        'description': 'Learn the fundamentals of faster-than-light travel.',
        'school': 'Engineering',
      },
      {
        'name': 'Klingon Linguistics',
        'description': 'Study the language and culture of the Klingon Empire.',
        'school': 'Linguistics',
      },
      {
        'name': 'Starship Command',
        'description': 'Master the skills required to lead a starship crew.',
        'school': 'Leadership',
      },
    ];

    // Insert Courses
    for (var course in courses) {
      await db.insert('courses', course);
    }

    // Dummy Ratings Data
    List<Map<String, dynamic>> ratings = [
      {
        'workload': 4,
        'difficulty': 5,
        'overall_rating': 5,
        'language': 'English',
        'semester': 'summer',
        'comment': 'Intense but highly rewarding.',
        'course_id': 1,
      },
      {
        'workload': 3,
        'difficulty': 4,
        'overall_rating': 4,
        'language': 'English',
        'semester': 'winter',
        'comment': 'Fascinating insights into Klingon culture.',
        'course_id': 2,
      },
      {
        'workload': 5,
        'difficulty': 5,
        'overall_rating': 5,
        'language': 'English',
        'semester': 'summer',
        'comment': 'A must for aspiring captains.',
        'course_id': 3,
      },
    ];

    // Insert Ratings
    for (var rating in ratings) {
      await db.insert('ratings', rating);
    }

    // Dummy Events Data
    List<Map<String, dynamic>> events = [
      {
        'title': 'Federation Science Symposium',
        'date': '2025-02-01',
        'description': 'Explore the latest scientific discoveries in the galaxy.',
        'price': 50.0,
        'location': 'Starbase 1',
      },
      {
        'title': 'Klingon Cultural Festival',
        'date': '2025-03-15',
        'description': 'Celebrate the rich traditions of the Klingon Empire.',
        'price': 20.0,
        'location': 'QonoS',
      },
    ];

    // Insert Events
    for (var event in events) {
      await db.insert('events', event);
    }

    // Dummy Users Data
    List<Map<String, dynamic>> users = [
      {
        'name': 'James T. Kirk',
        'email': 'kirk@starfleet.com',
        'password': 'enterprise',
        'user_type': 'professor',
      },
      {
        'name': 'Spock',
        'email': 'spock@starfleet.com',
        'password': 'logic123',
        'user_type': 'professor',
      },
      {
        'name': 'Nyota Uhura',
        'email': 'uhura@starfleet.com',
        'password': 'linguist',
        'user_type': 'student',
      },
    ];

    // Insert Users
    for (var user in users) {
      await db.insert('users', user);
    }

    // Dummy Trip Signups Data
    List<Map<String, dynamic>> tripSignups = [
      {'trip_id': 1, 'user_id': 3, 'signup_date': '2025-01-15'},
      {'trip_id': 2, 'user_id': 3, 'signup_date': '2025-01-20'},
    ];

    // Insert Trip Signups
    for (var signup in tripSignups) {
      await db.insert('trip_signups', signup);
    }
  }

  Future<int> insert(String table, Map<String, dynamic> data) async {
    try {
      final db = await database;
      return await db.insert(table, data);
    } catch (e) {
      throw Exception("Error inserting into $table: $e");
    }
  }

  Future<int> update(String table, int id, Map<String, dynamic> data) async {
    try {
      final db = await database;
      return await db.update(table, data, where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      throw Exception("Error updating $table: $e");
    }
  }

  Future<int> delete(String table, int id) async {
    try {
      final db = await database;
      return await db.delete(table, where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      throw Exception("Error deleting from $table: $e");
    }
  }

  Future<List<Map<String, dynamic>>> getAll(String table) async {
    try {
      final db = await database;
      return await db.query(table);
    } catch (e) {
      throw Exception("Error fetching all from $table: $e");
    }
  }

  Future<Map<String, dynamic>?> getById(String table, int id) async {
    try {
      final db = await database;
      final results = await db.query(table, where: 'id = ?', whereArgs: [id]);
      return results.isNotEmpty ? results.first : null;
    } catch (e) {
      throw Exception("Error fetching by id from $table: $e");
    }
  }

  Future<List<Map<String, dynamic>>> getTripSignups(int tripId) async {
    try {
      final db = await database;
      return await db.query('trip_signups', where: 'trip_id = ?', whereArgs: [tripId]);
    } catch (e) {
      throw Exception("Error fetching signups for trip $tripId: $e");
    }
  }

  Future<void> deleteDatabaseFile() async {
    try {
      String dbPath = await getDatabasesPath();
      String path = join(dbPath, 'app_database.db');
      await deleteDatabase(path);
    } catch (e) {
      throw Exception("Error deleting database file: $e");
    }
  }
}
