import 'package:flutter/material.dart';
import '../db_helper.dart';
import '../widgets/bottomNavigationBarCustom.dart';
import 'course_rating_page.dart';
import '../theme/theme_helper.dart';

class CourseDetailsPage extends StatefulWidget {
  final int courseId;

  CourseDetailsPage({required this.courseId});

  @override
  State<CourseDetailsPage> createState() => _CourseDetailsPageState();
}

class _CourseDetailsPageState extends State<CourseDetailsPage> {
  Map<String, dynamic>? courseDetails;

  @override
  void initState() {
    super.initState();
    _fetchCourseDetails();
  }

  Future<void> _fetchCourseDetails() async {
    final dbHelper = DatabaseHelper();
    final result = await dbHelper.getAll('courses');
    final course = result.firstWhere(
      (element) => element['id'] == widget.courseId,
      orElse: () => {}, // Return an empty map instead of null
    );

    if (mounted) {
      setState(() {
        courseDetails = course.isNotEmpty ? course : null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          courseDetails?['name'] ?? 'Course Details',
          style: TextStyle(color: theme.colorScheme.onPrimaryContainer),
        ),
        backgroundColor: theme.colorScheme.primary, // Light blue
      ),
      body: courseDetails == null
          ? Center(
              child: Text(
                'Course not found.',
                style: TextStyle(color: Colors.grey, fontSize: 18),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Course Title
                  Text(
                    courseDetails!['name'] ?? 'Unknown Course',
                    style: TextThemes.textTheme(theme.colorScheme).titleMedium,
                  ),
                  SizedBox(height: 8),
                  // School Name
                  Text(
                    courseDetails!['school'] ?? 'Unknown School',
                    style: TextThemes.textTheme(theme.colorScheme).titleSmall,
                  ),
                  SizedBox(height: 20),
                  // Professor Placeholder
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: AssetImage('assets/images/professor.png'), // Replace with your image
                      ),
                      SizedBox(width: 16),
                      Text(
                        'Prof. John Doe', // Update dynamically if professor data is available
                        style: TextThemes.textTheme(theme.colorScheme)
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  // Course Description
                  Text(
                    courseDetails!['description'] ?? 'No description available.',
                    style: TextThemes.textTheme(theme.colorScheme).bodyMedium,
                  ),
                  SizedBox(height: 20),
                  // Rate Course Button
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primaryContainer,
                        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CourseRatingPage(courseTitle: courseDetails!['name']),
                          ),
                        );
                      },
                      child: Text(
                        'Rate Course',
                        style: TextStyle(color: theme.colorScheme.onPrimaryContainer),
                      ),
                    ),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: BottomNavigationBarCustom(1, context),
    );
  }
}
