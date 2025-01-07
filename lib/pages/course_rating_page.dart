import 'package:flutter/material.dart';
import '../db_helper.dart';
import 'package:ntuadventure/theme/theme_helper.dart';
class CourseRatingPage extends StatefulWidget {
  final String courseTitle;
  final int courseId;

  CourseRatingPage({required this.courseTitle, required this.courseId});

  @override
  _CourseRatingPageState createState() => _CourseRatingPageState();
}

class _CourseRatingPageState extends State<CourseRatingPage> {
  double workloadRating = 5.0;
  double difficultyRating = 5.0;
  double overallRating = 5.0;
  final TextEditingController commentController = TextEditingController();

  Future<void> _submitRating() async {
    final dbHelper = DatabaseHelper();
    final db = await dbHelper.database;

    await db.insert('ratings', {
      'workload': workloadRating.toInt(),
      'difficulty': difficultyRating.toInt(),
      'overall_rating': overallRating.toInt(),
      'comment': commentController.text,
      'course_id': widget.courseId,
    });

    // Notify the user and navigate back
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Rating submitted successfully!')),
    );
    Navigator.pop(context);
  }

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary, // Match the color with BottomNavigationBar
        title: Text(
          widget.courseTitle,
          style: TextStyle(color: theme.colorScheme.onPrimary),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.colorScheme.onPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0, // Optional: Remove shadow to match the flat design of the BottomNavigationBar
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Rating Sections
            RatingSection(
              label: 'Workload',
              description: 'Rate the workload of the course',
              value: workloadRating,
              onChanged: (value) {
                setState(() {
                  workloadRating = value;
                });
              },
            ),
            RatingSection(
              label: 'Difficulty',
              description: 'Rate the difficulty of the course',
              value: difficultyRating,
              onChanged: (value) {
                setState(() {
                  difficultyRating = value;
                });
              },
            ),
            RatingSection(
              label: 'Overall Rating',
              description: 'Rate your overall experience',
              value: overallRating,
              onChanged: (value) {
                setState(() {
                  overallRating = value;
                });
              },
            ),
            SizedBox(height: 20),

            // Write a Comment
            TextField(
              controller: commentController,
              decoration: InputDecoration(
                hintText: 'Write a comment...',
                hintStyle: TextStyle(color: Colors.black),
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Color(0xFFCBD0E2).withOpacity(0.4), // Light blue
              ),
              maxLines: 3,
            ),
            SizedBox(height: 30),

            // Submit Button
            Center(
              child: ElevatedButton(
                onPressed: _submitRating,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  backgroundColor: Color(0xFF223565), // Dark blue
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Submit Rating',
                  style: TextStyle(
                    fontSize: 18, // Bigger font
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RatingSection extends StatelessWidget {
  final String label;
  final String description;
  final double value;
  final ValueChanged<double> onChanged;

  RatingSection({
    required this.label,
    required this.description,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 5),
        Text(
          description,
          style: TextStyle(fontSize: 14, color: Colors.black),
        ),
        Slider(
          value: value,
          onChanged: onChanged,
          min: 0,
          max: 10,
          divisions: 10,
          label: '${value.toInt()}',
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
