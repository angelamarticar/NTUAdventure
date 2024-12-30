import 'package:flutter/material.dart';
import 'package:ntuadventure/theme/app_decoration.dart';
import '../widgets/bottomNavigationBarCustom.dart';
import 'package:intl/intl.dart';
import '../theme/theme_helper.dart';
import '../theme/app_decoration.dart';


// ignore: must_be_immutable
class HomePage extends StatelessWidget {
  int _selectedIndex=2;

  HomePage({super.key});

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
              // Sección superior con avatar y fecha
              CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/images/Group1.png'),
              ),
              SizedBox(height: 20), // Spacing between sections
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
                      child: Text("Today's schedule",
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        )
                      ),
                    ),
                    // Replace with your schedule data
                    Column(
                      spacing: 5,
                      children: [
                        ScheduleCard(
                          title: "Data Structures",
                          time: "9:00 - 11:00",
                        ),
                         ScheduleCard(
                          title: "Circuit Analysis",
                          time: "11:30 - 12:30",
                        ),
                        ScheduleCard(
                          title: "Thermodynamics",
                          time: "12:45 - 14:00",
                        ),
                      ],
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
                    // Replace with your schedule data
                    Column(
                      spacing: 5,
                      children: [
                        ScheduleCard(
                          title: "Data Structures",
                          time: "9:00 - 11:00",
                        ),
                         ScheduleCard(
                          title: "Circuit Analysis",
                          time: "11:30 - 12:30",
                        ),
                        ScheduleCard(
                          title: "Thermodynamics",
                          time: "12:45 - 14:00",
                        ),
                      ],
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
  final String time;

  const ScheduleCard({
    Key? key,
    required this.title,
    required this.time,
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
                      time,
                      style: TextThemes.textTheme(theme.colorScheme).bodySmall!.copyWith(
                        fontSize: 15.0
                      ),
        ),
      ),
    );
  }
}
