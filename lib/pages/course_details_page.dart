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
class RatingCard extends StatelessWidget {
  final String label;
  final double? value;

  RatingCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 5),
        Text(
          value != null ? '${value!.toStringAsFixed(1)}/10' : 'N/A',
          style: TextStyle(fontSize: 16, color: Colors.blueAccent),
        ),
      ],
    );
  }
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
    final db = await dbHelper.database;

    // Fetch course details
    final course = await db.query(
      'courses',
      where: 'id = ?',
      whereArgs: [widget.courseId],
    );

    // Fetch ratings and comments for the course
    final ratings = await db.query(
      'ratings',
      where: 'course_id = ?',
      whereArgs: [widget.courseId],
    );

    if (course.isNotEmpty && mounted) {
      double workloadAvg = 0;
      double difficultyAvg = 0;
      double overallAvg = 0;

      List<Map<String, dynamic>> comments = [];

      if (ratings.isNotEmpty) {
        workloadAvg = ratings.map((e) => e['workload'] as int).reduce((a, b) => a + b) / ratings.length;
        difficultyAvg = ratings.map((e) => e['difficulty'] as int).reduce((a, b) => a + b) / ratings.length;
        overallAvg = ratings.map((e) => e['overall_rating'] as int).reduce((a, b) => a + b) / ratings.length;
        comments = ratings.map((e) => {'comment': e['comment']}).toList();
      }

      setState(() {
        courseDetails = {
          ...course.first,
          'workloadAvg': workloadAvg,
          'difficultyAvg': difficultyAvg,
          'overallAvg': overallAvg,
          'comments': comments,
        };
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
        backgroundColor: theme.colorScheme.primary,
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
                  // Course Title and Description
                  Text(
                    courseDetails!['name'] ?? 'Unknown Course',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    courseDetails!['school'] ?? 'Unknown School',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    courseDetails!['description'] ?? 'No description available.',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  SizedBox(height: 20),

                  // Semester and Language
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Semester: ${courseDetails!['semester'] ?? 'N/A'}',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                      Text(
                        'Language: ${courseDetails!['language'] ?? 'N/A'}',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),

                  // Ratings
                  Text(
                    'Course Ratings (out of 10):',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RatingCard(label: 'Workload', value: courseDetails!['workloadAvg']),
                      RatingCard(label: 'Difficulty', value: courseDetails!['difficultyAvg']),
                      RatingCard(label: 'Overall', value: courseDetails!['overallAvg']),
                    ],
                  ),
                  SizedBox(height: 20),

                  // Comments
                  Text(
                    'Student Comments:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  ...?courseDetails!['comments']?.map((comment) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        '- ${comment['comment'] ?? 'No comment provided'}',
                        style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                      ),
                    );
                  }),
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
                            builder: (context) => CourseRatingPage(
                              courseTitle: courseDetails!['name'],
                              courseId: widget.courseId,
                            ),
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