import 'package:flutter/material.dart';

class CourseRatingPage extends StatelessWidget {
  final String courseTitle;

  CourseRatingPage({required this.courseTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rate $courseTitle'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Semester of Instruction',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                Chip(label: Text('Winter')),
                SizedBox(width: 10),
                Chip(label: Text('Spring')),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Teaching Language',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                Chip(label: Text('Greek')),
                SizedBox(width: 10),
                Chip(label: Text('English')),
              ],
            ),
            SizedBox(height: 20),
            RatingBar(label: 'Workload'),
            RatingBar(label: 'Difficulty'),
            RatingBar(label: 'Overall Rating'),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: 'Write a comment...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Rating submitted!')),
                );
                Navigator.pop(context);
              },
              child: Text('Send Rating'),
            ),
          ],
        ),
      ),
    );
  }
}

class RatingBar extends StatefulWidget {
  final String label;

  RatingBar({required this.label});

  @override
  _RatingBarState createState() => _RatingBarState();
}

class _RatingBarState extends State<RatingBar> {
  double rating = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(fontSize: 16),
        ),
        Slider(
          value: rating,
          onChanged: (newRating) {
            setState(() {
              rating = newRating;
            });
          },
          min: 0,
          max: 10,
          divisions: 10,
          label: '$rating',
        ),
      ],
    );
  }
}
