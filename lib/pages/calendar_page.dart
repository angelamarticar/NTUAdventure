import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ntuadventure/widgets/bottomNavigationBarCustom.dart';
import '../theme/theme_helper.dart';
import 'event_page.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _calendarpage();
}

class _calendarpage extends State<CalendarPage> {
  int _selectedIndex = 3;

  @override
  Widget build(BuildContext context) {
    DateTime selectedDay = DateTime.now();
    String formattedDate = DateFormat('EEE, MMM d').format(selectedDay);

    return Scaffold(
      backgroundColor: theme.colorScheme.onPrimaryContainer,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
              top: 20.0, left: 20.0, right: 20.0, bottom: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.0),
              // Search Bar
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  children: [
                    Icon(Icons.search, color: Colors.grey),
                    SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Search",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
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
                      height: 140.0,
                      child: TabBarView(
                        children: [
                          // My events tab
                          ListView(
                            padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EventDetailsPage(
                                        eventTitle: "Nafplio trip",
                                        eventDetails: "An exciting trip to Nafplio with sightseeing and cultural activities.",
                                        eventDate: "10/11/2024",
                                        meetingPoint: "Metaxourgeio Metro Station",
                                        time: "Sunday 10/11 at 9:00 AM",
                                        price: "15€", // Dummy data
                                      ),
                                    ),
                                  );
                                },
                                child: EventCard(
                                  title: "Nafplio trip",
                                  date: "10/11/2024",
                                  imageUrl: "https://via.placeholder.com/150",
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EventDetailsPage(
                                        eventTitle: "Music Festival",
                                        eventDetails: "Enjoy live music and performances.",
                                        eventDate: "12/11/2024",
                                        meetingPoint: "Central Park Stage",
                                        time: "Saturday 12/11 at 6:00 PM",
                                        price: "Free", // Dummy data
                                      ),
                                    ),
                                  );
                                },
                                child: EventCard(
                                  title: "Music Festival",
                                  date: "12/11/2024",
                                  imageUrl: "https://via.placeholder.com/150",
                                ),
                              ),
                            ],
                          ),

                          // Next events tab
                          Center(
                            child: Text("No upcoming events"),
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
