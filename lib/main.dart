import 'package:flutter/material.dart';
import 'package:ntuadventure/pages/calendar_page.dart';
import 'package:ntuadventure/pages/home_page.dart';
import 'package:ntuadventure/pages/login_page.dart';
import 'package:ntuadventure/pages/map_page.dart';
import 'package:ntuadventure/pages/course_page.dart';
import 'package:ntuadventure/theme/theme_helper.dart';

void main() {
  runApp(CourseApp());
}

class CourseApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ntuAdventure',
      theme: ThemeHelper().themedata(),
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
