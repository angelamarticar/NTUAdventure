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
    final db = await dbHelper.database;

    // Fetch course details along with professor name
    final courseQuery = '''
      SELECT c.*, u.name as professor_name
      FROM courses c
      LEFT JOIN users u ON c.professor_id = u.id
      WHERE c.id = ?
    ''';
    final course = await db.rawQuery(courseQuery, [widget.courseId]);

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
    final String placeholderImage = 'assets/images/NTUAlib.jpg';

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
                  // Course Image
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        courseDetails!['image_path'] ?? placeholderImage,
                        errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                          return Image.asset(
                            placeholderImage, // Path to your placeholder image
                            fit: BoxFit.cover,
                          );
                        },
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Divider(color: Colors.blue[900], thickness: 2, height: 32),

                  // Description
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Description:',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      SizedBox(height: 8),
                      Text(
                        courseDetails!['description'] ?? 'No description available.',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ],
                  ),
                  Divider(color: Colors.blue[900], thickness: 2, height: 32),

                  // Course Info
                  Text(
                    'School: ${courseDetails!['school'] ?? 'Unknown School'}',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey[800]),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Professor: ${courseDetails!['professor_name'] ?? 'TBA'}',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey[800]),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Language: ${courseDetails!['language'] ?? 'Not specified'}',
                    style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Semester: ${courseDetails!['semester'] ?? 'Not specified'}',
                    style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                  ),
                  Divider(color: Colors.blue[900], thickness: 2, height: 32),

                  // Ratings
                  Text(
                    'Course Ratings:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
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

                  // Comments
                  Text(
                    'Student Comments:',
                    style: TextStyle(fontSize: 17, color: Colors.grey),
                  ),
                  SizedBox(height: 10),
                  if (courseDetails!['comments'] != null && (courseDetails!['comments'] as List).isNotEmpty)
                    ...courseDetails!['comments']!.map<Widget>((comment) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          '"${comment['comment'] ?? 'No comment provided'}"',
                          style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic, color: Colors.blueAccent),
                        ),
                      );
                    }).toList()
                  else
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        'No comments yet.',
                        style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic, color: Colors.grey),
                      ),
                    ),
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
          style: TextStyle(fontSize: 17, color: Colors.grey),
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
