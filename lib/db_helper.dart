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
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await _executeCreateTables(db);
    await _insertDummyData(db);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Drop all tables and recreate
    await _dropAllTables(db);
    await _onCreate(db, newVersion);
  }

  Future<void> _dropAllTables(Database db) async {
    final tables = ['users', 'courses', 'ratings', 'events', 'user_courses', 'trip_signups'];
    for (String table in tables) {
      await db.execute('DROP TABLE IF EXISTS $table');
    }
  }

  Future<void> resetDatabase() async {
  final db = await database;
  await _dropAllTables(db);  // Drop all tables
  await _executeCreateTables(db);  // Recreate tables
  await _insertDummyData(db);  // Repopulate with dummy data
}


  Future<void> _executeCreateTables(Database db) async {
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL,
        user_type TEXT CHECK(user_type IN ('erasmusStudent', 'professor', 'esnOrganiser')) NOT NULL,
        profile_picture_path TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE courses(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT,
        school TEXT,
        language TEXT,
        semester TEXT,
        image_path TEXT,
        professor_id INTEGER,
        FOREIGN KEY (professor_id) REFERENCES users (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE ratings(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        workload INTEGER,
        difficulty INTEGER,
        overall_rating INTEGER,
        comment TEXT,
        course_id INTEGER,
        FOREIGN KEY (course_id) REFERENCES courses (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE events(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        date TEXT NOT NULL,
        description TEXT,
        price DOUBLE,
        location TEXT,
        image_path TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE trip_signups(
        trip_id INTEGER,
        user_id INTEGER,
        signup_date TEXT NOT NULL,
        PRIMARY KEY (trip_id, user_id),
        FOREIGN KEY (trip_id) REFERENCES events (id) ON DELETE CASCADE,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');

      await db.execute('''
      CREATE TABLE user_courses(
        user_id INTEGER,
        course_id INTEGER,
        signup_date TEXT NOT NULL,
        PRIMARY KEY (user_id, course_id),
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
        FOREIGN KEY (course_id) REFERENCES courses (id) ON DELETE CASCADE
      )
    ''');

    await db.execute(
          '''CREATE TABLE IF NOT EXISTS 
          photos(
          id INTEGER PRIMARY KEY, 
          placeName TEXT NOT NULL,
          path TEXT)'''
    );
  }

  Future<int> insert(String table, Map<String, dynamic> values) async {
    final db = await database;
    return await db.insert(table, values);
  }

  Future<List<Map<String, dynamic>>> getAll(String table) async {
    final db = await database;
    return await db.query(table);
  }

  Future<Map<String, dynamic>?> getById(String table, int id) async {
    final db = await database;
    final result = await db.query(table, where: 'id = ?', whereArgs: [id]);
    return result.isNotEmpty ? result.first : null;
  }

  Future<int> update(String table, Map<String, dynamic> values) async {
    final db = await database;
    return await db.update(table, values, where: 'id = ?', whereArgs: [values['id']]);
  }

  Future<int> delete(String table, int id) async {
    final db = await database;
    return await db.delete(table, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteComposite(String table, Map<String, dynamic> keys) async {
    final db = await database;
    final whereClause = keys.keys.map((key) => '$key = ?').join(' AND ');
    final whereArgs = keys.values.toList();
    return await db.delete(table, where: whereClause, whereArgs: whereArgs);
  }

  Future<void> _insertDummyData(Database db) async {
    // Add Star Trek-themed users
    await db.insert('users', {'name': 'Jean-Luc Picard', 'email': 'picard@starfleet.com', 'password': 'enterpriseD', 'user_type': 'professor'});
    await db.insert('users', {'name': 'Spock', 'email': 'spock@vulcan.com', 'password': 'logicRules', 'user_type': 'professor'});
    await db.insert('users', {'name': 'James T. Kirk', 'email': 'kirk@starfleet.com', 'password': 'tosLegend', 'user_type': 'professor'});
    await db.insert('users', {'name': 'Data', 'email': 'data@starfleet.com', 'password': 'positronic', 'user_type': 'erasmusStudent'});
    await db.insert('users', {'name': 'Seven of Nine', 'email': 'seven@borg.com', 'password': 'annika', 'user_type': 'erasmusStudent'});
    await db.insert('users', {'name': 'Kathryn Janeway', 'email': 'janeway@voyager.com', 'password': 'deltaQuadrant', 'user_type': 'professor'});

    // Add Star Trek-themed courses
    await db.insert('courses', {'name': 'Warp Core Engineering', 'description': 'Learn to manage starship warp cores.', 'school': 'Engineering', 'language': 'English', 'semester': 'Winter'});
    await db.insert('courses', {'name': 'Temporal Mechanics', 'description': 'The study of time travel and temporal anomalies.', 'school': 'Physics', 'language': 'Vulcan', 'semester': 'Spring'});
    await db.insert('courses', {'name': 'Federation Diplomacy', 'description': 'Understand interplanetary relations and diplomacy.', 'school': 'Political Science', 'language': 'English', 'semester': 'Summer'});
    await db.insert('courses', {'name': 'Borg Technology', 'description': 'Analysis of Borg nanoprobes and adaptation systems.', 'school': 'Cybernetics', 'language': 'English', 'semester': 'Fall'});
    await db.insert('courses', {'name': 'Starship Navigation', 'description': 'Advanced techniques in starship piloting.', 'school': 'Astronomy', 'language': 'English', 'semester': 'Winter'});
    await db.insert('courses', {'name': 'Holodeck Programming', 'description': 'Learn to create and maintain holodeck programs.', 'school': 'Computer Science', 'language': 'English', 'semester': 'Spring'});

    // Add dummy user-course relationships
    await db.insert('user_courses', {'user_id': 1, 'course_id': 1, 'signup_date': '2025-01-01'});
    await db.insert('user_courses', {'user_id': 2, 'course_id': 2, 'signup_date': '2025-02-01'});
    await db.insert('user_courses', {'user_id': 2, 'course_id': 3, 'signup_date': '2025-03-01'});
    await db.insert('user_courses', {'user_id': 2, 'course_id': 4, 'signup_date': '2025-04-01'});
    await db.insert('user_courses', {'user_id': 3, 'course_id': 3, 'signup_date': '2025-03-01'});
    await db.insert('user_courses', {'user_id': 4, 'course_id': 4, 'signup_date': '2025-04-01'});
    await db.insert('user_courses', {'user_id': 5, 'course_id': 5, 'signup_date': '2025-05-01'});
    await db.insert('user_courses', {'user_id': 6, 'course_id': 6, 'signup_date': '2025-06-01'});

    // Add Star Trek-themed ratings
    await db.insert('ratings', {'workload': 8, 'difficulty': 7, 'overall_rating': 9, 'comment': 'Warp cores are fascinating!', 'course_id': 1});
    await db.insert('ratings', {'workload': 6, 'difficulty': 9, 'overall_rating': 8, 'comment': 'Temporal mechanics are complex but intriguing.', 'course_id': 2});
    await db.insert('ratings', {'workload': 7, 'difficulty': 5, 'overall_rating': 10, 'comment': 'Diplomacy with Klingons was fun!', 'course_id': 3});
    await db.insert('ratings', {'workload': 9, 'difficulty': 10, 'overall_rating': 7, 'comment': 'Borg tech is incredibly advanced!', 'course_id': 4});
    await db.insert('ratings', {'workload': 5, 'difficulty': 5, 'overall_rating': 8, 'comment': 'Starship piloting is exhilarating.', 'course_id': 5});
    await db.insert('ratings', {'workload': 4, 'difficulty': 6, 'overall_rating': 9, 'comment': 'Holodeck programming was creative!', 'course_id': 6});

    // Add Star Trek-themed events
    await db.insert('events', {'title': 'Klingon Batleth Tournament', 'date': '2025-06-01', 'description': 'Compete in a Bat’leth combat tournament.', 'price': 30.0, 'location': 'Qo’noS', 'image_path': 'https://m.media-amazon.com/images/S/pv-target-images/42425d39b520914252319a1d94c3902c6a9ab269351365e9afde23e51a904110.jpg'});
    await db.insert('events', {'title': 'Federation Science Symposium', 'date': '2025-07-15', 'description': 'Explore the latest Federation science.', 'price': 50.0, 'location': 'Starbase 1', 'image_path': 'https://cdn5.idcgames.com/storage/image/1496/game_home_bg_section_2/default.jpg'});
    await db.insert('events', {'title': 'Delta Quadrant Exploration', 'date': '2025-08-10', 'description': 'A guided tour of the Delta Quadrant.', 'price': 100.0, 'location': 'Voyager', 'image_path': 'https://cdn.britannica.com/82/162182-050-BB21D3E1/Leonard-Nimoy-Star-Trek-William-Shatner.jpg'});
    await db.insert('events', {'title': 'Holodeck Creative Workshop', 'date': '2025-09-05', 'description': 'Create your own holodeck adventures.', 'price': 20.0, 'location': 'Enterprise-D', 'image_path': 'https://www.zdnet.com/a/img/resize/36a96460833c9b22dc81189aad0f44eb8f0c77fa/2024/11/22/5e46b6fb-4074-40e5-aba5-402483207025/spock6gettyimages-464967684.jpg?auto=webp&width=1280'});
    await db.insert('events', {'title': 'Vulcan Logic Retreat', 'date': '2025-10-12', 'description': 'Immerse yourself in Vulcan philosophy.', 'price': 15.0, 'location': 'Vulcan', 'image_path': 'https://img2.rtve.es/i/?w=1600&i=1479126615672.jpg'});
    await db.insert('events', {'title': 'Starfleet Graduation Ceremony', 'date': '2025-11-20', 'description': 'Celebrate the newest Starfleet cadets.', 'price': 0.0, 'location': 'Starfleet Academy', 'image_path': 'https://captainsblog1701.files.wordpress.com/2011/07/the_next_generation_main_cast_season_11.jpg?w=640'});


    // Add Star Trek-themed trip signups
    await db.insert('trip_signups', {'trip_id': 1, 'user_id': 1, 'signup_date': '2025-05-20'});
    await db.insert('trip_signups', {'trip_id': 2, 'user_id': 3, 'signup_date': '2025-07-01'});
    await db.insert('trip_signups', {'trip_id': 3, 'user_id': 5, 'signup_date': '2025-08-05'});
    await db.insert('trip_signups', {'trip_id': 4, 'user_id': 6, 'signup_date': '2025-09-01'});
    await db.insert('trip_signups', {'trip_id': 5, 'user_id': 2, 'signup_date': '2025-10-01'});
    await db.insert('trip_signups', {'trip_id': 6, 'user_id': 4, 'signup_date': '2025-11-10'});
  }
}
