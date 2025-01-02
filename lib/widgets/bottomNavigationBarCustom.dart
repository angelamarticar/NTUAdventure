import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ntuadventure/pages/course_page.dart';
import 'package:ntuadventure/pages/map_page.dart';
import '../pages/calendar_page.dart';
import '../pages/home_page.dart';
import '../theme/theme_helper.dart';


Widget BottomNavigationBarCustom(int selectedIndex, BuildContext context) {

  return Container(
    color: theme.colorScheme.primary,
    padding: EdgeInsets.only(top:5.0),
    child: BottomNavigationBar(
        iconSize: 36.0,
        backgroundColor: theme.colorScheme.primary,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: theme.colorScheme.onPrimaryContainer, // Color del ítem seleccionado
        unselectedItemColor: lightColors.gray700, // Color de los ítems no seleccionados
        currentIndex: selectedIndex, // El índice seleccionado
        onTap: (index)async{
          HapticFeedback.lightImpact();
           if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()), // Home Page
            );
          } else if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CalendarPage()), // Calendar Page
            );
          }else if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MapPage()), // Map Page
            );
          }else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CoursePage()), //Course PAge
            );
          }
        }, // El callback para actualizar el índice seleccionado
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.location_on), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: ""),
        ],
      ),
  );
}