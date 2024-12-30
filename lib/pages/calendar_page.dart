import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ntuadventure/widgets/bottomNavigationBarCustom.dart';
import '../theme/theme_helper.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget{
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _calendarpage();
}

class _calendarpage extends State<CalendarPage>{

  int _selectedIndex= 3;

  

  @override
  Widget build(BuildContext context) {
    DateTime selectedDay = DateTime.now();
    String formattedDate = DateFormat('EEE, MMM d').format(selectedDay);
    return Scaffold(
       backgroundColor: theme.colorScheme.onPrimaryContainer,
       body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top:20.0, left:20.0, right:20.0, bottom: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.0,),
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
                  color: theme.colorScheme.primaryContainer, // Navy blue background
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: EdgeInsets.all(20),
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
                    TableCalendar(
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
                        defaultTextStyle: TextStyle(color: Colors.white),
                        weekendTextStyle: TextStyle(color: lightColors.gray200),
                        outsideTextStyle: TextStyle(color: Colors.grey[500]),
                        disabledTextStyle: TextStyle(color: Colors.grey[600]),
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
                          fontSize: 14, // Tamaño ajustado para mayor visibilidad
                        ),
                        weekendStyle: TextStyle(
                          color: Colors.white70,
                          fontSize: 14, // Tamaño ajustado para mayor visibilidad
                        ),
                      ),
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
                      height: 100, // Height of the tab content
                      child: TabBarView(
                        children: [
                          // My events tab
                          ListView(
                            children: [
                              EventCard(
                                title: "Nafplio trip",
                                date: "10/11/2024",
                                imageUrl: "https://via.placeholder.com/150",
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
      bottomNavigationBar: BottomNavigationBarCustom(
        _selectedIndex, context),
    );
  }

}

class EventCard extends StatelessWidget {
  final String title;
  final String date;
  final String imageUrl;

  const EventCard({super.key, 
    required this.title,
    required this.date,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
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
                style: TextStyle(fontWeight: FontWeight.bold, 
                fontSize: 20,
                color: theme.colorScheme.onPrimary),
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