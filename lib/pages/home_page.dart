import 'package:flutter/material.dart';
import 'package:ntuadventure/theme/app_decoration.dart';
import '../widgets/bottomNavigationBarCustom.dart';
import '../theme/theme_helper.dart';
import '../db_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logging/logging.dart';
import 'package:intl/intl.dart';

final Logger logger = Logger('HomePageLogger');

// ignore: must_be_immutable
class HomePage extends StatefulWidget {


  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex=2;

  List<Map<String, dynamic>> _userCourses = [];
    List<Map<String, dynamic>> _userEvents = [];

   @override
  void initState() {
    super.initState();
    _fetchUserCoursesAndEvents();
  }


  Future<void> _fetchUserCoursesAndEvents() async {
    final db = await DatabaseHelper().database;
    

    // Get user_id from SharedPreferences or default to 2
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id') ?? 2;
    
    logger.info('retrieving courses and events from user: $userId');

    // Query to get courses for the user
    final resultCourses = await db.rawQuery('''
      SELECT courses.name, courses.description 
      FROM user_courses 
      JOIN courses ON user_courses.course_id = courses.id 
      WHERE user_courses.user_id = ?
    ''', [userId]);

    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    final resultEvents = await db.rawQuery('''
      SELECT events.title, events.date
      FROM trip_signups 
      JOIN events ON trip_signups.trip_id = events.id
      WHERE trip_signups.user_id = ? AND events.date > ?
      ORDER BY events.date ASC
    ''', [userId, today]);

  logger.info('Eventos obtenidos: ${resultEvents.length}');

    setState(() {
      _userCourses = resultCourses;
      _userEvents = resultEvents;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBarCustom(
        _selectedIndex, context),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10.0),
        child: Container(
          width: double.maxFinite,
          padding: EdgeInsets.only(
            left: 12.0,
            top:20.0,
            right: 12.0
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/images/Group1.png'),
              ),
              SizedBox(height: 20), 
              Container(
                padding: EdgeInsets.symmetric(vertical:15.0, horizontal: 35.0),
                decoration: AppDecoration.secondaryBox.copyWith(
                  borderRadius: BorderRadius.circular(12.0)
                ),
              // Today's schedule section
                child: Column(
                  spacing: 10.0,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text("Your courses",
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        )
                      ),
                    ),
                    
                    Column(
                      spacing: 5,
                      children: _userCourses.map((course) {
                        return ScheduleCard(
                          title: course['name'],
                          description: course['description'] ?? 'No description available',
                        );
                      }).toList()
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text("Upcoming events",
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        )
                      ),
                    ),
                    Column(
                      spacing: 5,
                      children: _userEvents.map((event) {
                        return ScheduleCard(
                          title: event['title'],
                          description: event['date'] ?? 'No date available',
                        );
                      }).toList()
                    ),
                  ],
                )
                )
            ],
          ),
        ),
      ),
    );
  }
}


// Widget para los horarios y eventos
class ScheduleCard extends StatelessWidget {
  final String title;
  final String description;

  const ScheduleCard({
    Key? key,
    required this.title,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(12.0),
      child: ListTile(
        title: Text(
                      title,
                      style: TextThemes.textTheme(theme.colorScheme).titleSmall!.copyWith(
                        fontSize: 20.0,
                        color: theme.colorScheme.errorContainer
                      ),
        ),
        subtitle: Text(
                      description,
                      style: TextThemes.textTheme(theme.colorScheme).bodySmall!.copyWith(
                        fontSize: 12.0
                      ),
        ),
      ),
    );
  }
}
