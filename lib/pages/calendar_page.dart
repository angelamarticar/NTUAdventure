import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ntuadventure/widgets/bottomNavigationBarCustom.dart';
import '../theme/theme_helper.dart';
import 'event_page.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:logging/logging.dart';
import '../db_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';


final Logger logger = Logger('CalendarPageLogger');

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _calendarpage();
}

class _calendarpage extends State<CalendarPage> {
  int _selectedIndex = 3;
  List<Map<String, dynamic>> _userEvents = [];
  List<Map<String, dynamic>> _nextEvents = [];

  @override
  void initState() {
    super.initState();
    _fetchUserEvents();
  }

    Future<void> _fetchUserEvents() async {
    final db = await DatabaseHelper().database;

    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id') ?? 2;

    logger.info('Obteniendo eventos para el usuario: $userId');

    try {
      final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final resultEvents = await db.rawQuery('''
        SELECT events.title, events.date, events.description, events.price, events.location, events.image_path
        FROM trip_signups 
        JOIN events ON trip_signups.trip_id = events.id
        WHERE trip_signups.user_id = ? AND events.date > ?
        ORDER BY events.date ASC
      ''', [userId, today]);

      logger.info('Eventos futuros obtenidos: ${resultEvents.length}');

      setState(() {
        _userEvents = resultEvents;
      });
    } catch (e) {
      logger.severe('Error al obtener eventos: $e');
    }
  }

    Future<void> _fetchNextEvents() async {
    final db = await DatabaseHelper().database;

    try {
      final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final nextMonth = DateFormat('yyyy-MM-dd').format(DateTime.now().add(Duration(days: 30)));
      final resultNextEvents = await db.rawQuery('''
        SELECT events.title, events.date, events.description, events.price, events.location, events.image_path
        FROM events
        WHERE events.date > ? AND events.date <= ?
        ORDER BY events.date ASC
      ''', [today, nextMonth]);

      logger.info('Próximos eventos obtenidos: ${resultNextEvents.length}');

      setState(() {
        _nextEvents = resultNextEvents;
      });
    } catch (e) {
      logger.severe('Error al obtener próximos eventos: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime selectedDay = DateTime.now();
    String formattedDate = DateFormat('EEE, MMM d').format(selectedDay);

    return SafeArea(
      child: Scaffold(
        backgroundColor: theme.colorScheme.onPrimaryContainer,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
                top: 20.0, left: 20.0, right: 20.0, bottom: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 24.0),
                // Calendar
                Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Your event calendar",
                        style: TextStyle(
                          color: theme.colorScheme.onPrimaryContainer,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        formattedDate,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 350.0,
                        width: 500.0,
                        child: CustomTableCalendar(selectedDay: selectedDay),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                // Tabs
                DefaultTabController(
                  length: 2,
                  child: Column(
                    children: [
                      TabBar(
                        indicatorColor: Color(0xFF1A237E),
                        labelColor: Colors.black,
                        unselectedLabelColor: Colors.grey,
                        tabs: [
                          Tab(text: "My events"),
                          Tab(text: "Next events"),
                        ],
                      ),
                      Container(
                        height: 200.0,
                        child: TabBarView(
                          children: [
                            // My events tab
                            ListView(
                              children: _userEvents.map((event) {
                                return InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EventDetailsPage(
                                          eventTitle: event['title'],
                                          eventDetails: event['description'] ?? "Details not provided",
                                          eventDate: event['date'],
                                          meetingPoint: event['location'] ?? "Not specified",
                                          time: "Not specified", // Placeholder
                                          price: event['price'] != null ? "${event['price']}€" : "Free",
                                        ),
                                      ),
                                    );
                                  },
                                  child: EventCard(
                                    title: event['title'],
                                    date: event['date'],
                                    imageUrl: event['image_path'] ?? 'https://via.placeholder.com/150',   
                                  ),
                                );
                              }).toList(),
                            ),
      
                            // Next events tab
                            // Next events tab
                            ListView(
                              children: _nextEvents.isNotEmpty
                                  ? _nextEvents.map((event) {
                                      return InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => EventDetailsPage(
                                                eventTitle: event['title'],
                                                eventDetails: event['description'] ?? "Details not provided",
                                                eventDate: event['date'],
                                                meetingPoint: event['location'] ?? "Not specified",
                                                time: "Not specified", // Placeholder
                                                price: event['price'] != null ? "${event['price']}€" : "Free",
                                              ),
                                            ),
                                          );
                                        },
                                        child: EventCard(
                                          title: event['title'],
                                          date: event['date'],
                                          imageUrl: event['image_path'] ?? 'https://via.placeholder.com/150',
                                        ),
                                      );
                                    }).toList()
                                  : [
                                      SizedBox(height: 12.0,),
                                      Center(
                                        child: Text(
                                          "No upcoming events",
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ),
                                    ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationBarCustom(_selectedIndex, context),
      ),
    );
  }
}

class CustomTableCalendar extends StatelessWidget {
  const CustomTableCalendar({
    super.key,
    required this.selectedDay,
  });

  final DateTime selectedDay;

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      shouldFillViewport: true,
      firstDay: DateTime.utc(2010, 10, 16),
      lastDay: DateTime.utc(2030, 3, 14),
      focusedDay: selectedDay,
      currentDay: selectedDay,
      startingDayOfWeek: StartingDayOfWeek.monday,
      calendarStyle: CalendarStyle(
        todayDecoration: BoxDecoration(
          color: theme.colorScheme.primary,
          shape: BoxShape.circle,
        ),
        defaultTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 18.0,
        ),
        weekendTextStyle: TextStyle(
          color: lightColors.gray200,
          fontSize: 18.0,
        ),
        outsideTextStyle: TextStyle(
          color: Colors.grey[500],
          fontSize: 18.0,
        ),
        disabledTextStyle: TextStyle(
          color: Colors.grey[600],
          fontSize: 18.0,
        ),
      ),
      headerStyle: HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
        leftChevronIcon: Icon(Icons.chevron_left, color: Colors.white),
        rightChevronIcon: Icon(Icons.chevron_right, color: Colors.white),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 16),
        decoration: BoxDecoration(color: Colors.transparent),
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: TextStyle(
          color: Colors.white,
          fontSize: 14,
        ),
        weekendStyle: TextStyle(
          color: Colors.white70,
          fontSize: 14,
        ),
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  final String title;
  final String date;
  final String imageUrl;

  const EventCard({
    super.key,
    required this.title,
    required this.date,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              imageUrl,
              height: 80,
              width: 80,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: theme.colorScheme.onPrimary,
                ),
              ),
              SizedBox(height: 4),
              Text(
                date,
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
