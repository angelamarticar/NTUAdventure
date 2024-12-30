import 'package:flutter/material.dart';
import '../widgets/bottomNavigationBarCustom.dart';
import 'package:intl/intl.dart';
import 'package:ntuadventure/widgets/bottomNavigationBarCustom.dart';
import '../theme/theme_helper.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    int _selectedIndex= 2;
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      bottomNavigationBar: BottomNavigationBarCustom(
          _selectedIndex, context),
      body: Column(
        children: [
          Center(
            child: Text('Welcome to the Home Page!',
            style: TextStyle(fontSize: 50.0),),
          ),
        ],
      ),
    );
  }
}
