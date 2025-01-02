import 'package:flutter/material.dart';
import 'course_details_page.dart';

class CoursePage extends StatelessWidget {
  final List<Map<String, String>> courses = [
    {'title': 'Circuit Analysis', 'description': 'Electrical Engineering'},
    {'title': 'Thermodynamics', 'description': 'Mechanical Engineering'},
    {'title': 'Data Structures', 'description': 'Computer Science'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Courses'),
      ),
      body: ListView.builder(
        itemCount: courses.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.book, color: Colors.blue),
            title: Text(courses[index]['title']!),
            subtitle: Text(courses[index]['description']!),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      CourseDetailsPage(course: courses[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
