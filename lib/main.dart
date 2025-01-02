import 'package:flutter/material.dart';
import 'package:ntuadventure/pages/calendar_page.dart';
import 'package:ntuadventure/pages/home_page.dart';
import 'package:ntuadventure/pages/login_page.dart';
import 'package:ntuadventure/pages/map_page.dart';
import 'package:ntuadventure/theme/theme_helper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ntuadventure',
      theme: theme,
      home: MapPage(),
    );
  }
}
