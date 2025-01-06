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
  /*
  Future<void> insertDummyData() async {
    final db = await database;
    Batch batch = db.batch();

    // Add dummy users
    List<Map<String, dynamic>> users = [
      {
        'name': 'Ada Lovelace',
        'email': 'ada@computerscience.com',
        'password': 'analyticalengine',
        'user_type': 'professor',
      },
      {
        'name': 'Alan Turing',
        'email': 'turing@computerscience.com',
        'password': 'enigma123',
        'user_type': 'professor',
      },
      {
        'name': 'Grace Hopper',
        'email': 'hopper@computerscience.com',
        'password': 'cobolrocks',
        'user_type': 'student',
      },
      {
        'name': 'Katherine Johnson',
        'email': 'johnson@nasa.com',
        'password': 'mathematician',
        'user_type': 'student',
      },
    ];

    for (var user in users) {
      batch.insert('users', user);
    }

    // Add dummy courses
    List<Map<String, dynamic>> courses = [
      {
        'name': 'Introduction to Quantum Computing',
        'description': 'Learn the basics of quantum mechanics and computing.',
        'school': 'Physics and Computer Science',
      },
      {
        'name': 'Artificial Intelligence Ethics',
        'description': 'Explore the ethical implications of AI development.',
        'school': 'Philosophy',
      },
      {
        'name': 'History of Space Exploration',
        'description': 'An overview of humanity’s journey to the stars.',
        'school': 'Astronomy',
      },
      {
        'name': 'Advanced Data Structures',
        'description': 'Study and implement complex data structures.',
        'school': 'Computer Science',
      },
      {
        'name': 'Astrobiology',
        'description': 'Explore the possibilities of life beyond Earth.',
        'school': 'Biology and Astronomy',
      },
    ];

    for (var course in courses) {
      batch.insert('courses', course);
    }

    // Add dummy ratings
    List<Map<String, dynamic>> ratings = [
      {
        'workload': 6,
        'difficulty': 7,
        'overall_rating': 8,
        'language': 'English',
        'semester': 'Winter',
        'comment': 'Challenging but worth it!',
        'course_id': 1,
      },
      {
        'workload': 5,
        'difficulty': 5,
        'overall_rating': 9,
        'language': 'English',
        'semester': 'Summer',
        'comment': 'Engaging and thought-provoking.',
        'course_id': 2,
      },
      {
        'workload': 7,
        'difficulty': 8,
        'overall_rating': 7,
        'language': 'English',
        'semester': 'Winter',
        'comment': 'Fascinating content with tough assignments.',
        'course_id': 3,
      },
      {
        'workload': 4,
        'difficulty': 6,
        'overall_rating': 8,
        'language': 'Greek',
        'semester': 'Summer',
        'comment': 'Clear explanations and hands-on examples.',
        'course_id': 4,
      },
      {
        'workload': 8,
        'difficulty': 9,
        'overall_rating': 9,
        'language': 'Greek',
        'semester': 'Winter',
        'comment': 'A very advanced and rewarding course!',
        'course_id': 5,
      },
    ];

    for (var rating in ratings) {
      batch.insert('ratings', rating);
    }

    // Add dummy events
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
      {
        'title': 'Starship Piloting Workshop',
        'date': '2025-04-10',
        'description': 'Hone your starship piloting skills with experts.',
        'price': 100.0,
        'location': 'Starfleet Academy',
      },
    ];

    for (var event in events) {
      batch.insert('events', event);
    }

    // Execute the batch
    await batch.commit(noResult: true);
}*/


  Future<List<Map<String, dynamic>>> getAll(String table) async {
    try {
      final db = await database;
      return await db.query(table);
    } catch (e) {
      throw Exception("Error fetching all from $table: $e");
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
