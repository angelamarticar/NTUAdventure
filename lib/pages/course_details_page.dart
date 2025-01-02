import 'package:flutter/material.dart';
import 'course_rating_page.dart';

class CourseDetailsPage extends StatelessWidget {
  final Map<String, String> course;

  CourseDetailsPage({required this.course});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(course['title']!),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              course['title']!,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              course['description']!,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        CourseRatingPage(courseTitle: course['title']!),
                  ),
                );
              },
              child: Text('Rate Course'),
            ),
          ],
        ),
      ),
    );
  }
}
