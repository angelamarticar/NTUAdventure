import 'package:flutter/material.dart';

class CourseRatingPage extends StatefulWidget {
  final String courseTitle;

  CourseRatingPage({required this.courseTitle});

  @override
  _CourseRatingPageState createState() => _CourseRatingPageState();
}

class _CourseRatingPageState extends State<CourseRatingPage> {
  String selectedSemester = 'Winter';
  String selectedLanguage = 'Greek';

  double workloadRating = 5;
  double difficultyRating = 5;
  double overallRating = 5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFCBD0E2), // Light blue-gray color
        title: Text(
          widget.courseTitle,
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Semester of Instruction and Teaching Language
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Semester of Instruction',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedSemester = 'Winter';
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 8),
                                decoration: BoxDecoration(
                                  color: selectedSemester == 'Winter'
                                      ? Color(0xFFCBD0E2)
                                      : Colors.white,
                                  border: Border.all(
                                    color: Color(0xFF223565), // Dark blue outline
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'Winter',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: selectedSemester == 'Winter'
                                        ? Colors.black
                                        : Color(0xFF223565),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedSemester = 'Spring';
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 8),
                                decoration: BoxDecoration(
                                  color: selectedSemester == 'Spring'
                                      ? Color(0xFFCBD0E2)
                                      : Colors.white,
                                  border: Border.all(
                                    color: Color(0xFF223565), // Dark blue outline
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'Spring',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: selectedSemester == 'Spring'
                                        ? Colors.black
                                        : Color(0xFF223565),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Teaching Language',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedLanguage = 'Greek';
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 8),
                                decoration: BoxDecoration(
                                  color: selectedLanguage == 'Greek'
                                      ? Color(0xFFCBD0E2)
                                      : Colors.white,
                                  border: Border.all(
                                    color: Color(0xFF223565), // Dark blue outline
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'Greek',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: selectedLanguage == 'Greek'
                                        ? Colors.black
                                        : Color(0xFF223565),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedLanguage = 'English';
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 8),
                                decoration: BoxDecoration(
                                  color: selectedLanguage == 'English'
                                      ? Color(0xFFCBD0E2)
                                      : Colors.white,
                                  border: Border.all(
                                    color: Color(0xFF223565), // Dark blue outline
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'English',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: selectedLanguage == 'English'
                                        ? Colors.black
                                        : Color(0xFF223565),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              // Rating Sections with Descriptions
              RatingSection(
                label: 'Workload',
                description: 'Workload',
                value: workloadRating,
                onChanged: (value) {
                  setState(() {
                    workloadRating = value;
                  });
                },
              ),
              RatingSection(
                label: 'Difficulty',
                description: 'Difficulty',
                value: difficultyRating,
                onChanged: (value) {
                  setState(() {
                    difficultyRating = value;
                  });
                },
              ),
              RatingSection(
                label: 'Overall Rating',
                description: 'Overall experience',
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
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Rating submitted!')),
                    );
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    padding:
                        EdgeInsets.symmetric(horizontal: 40, vertical: 20), // Bigger button
                    backgroundColor: Color(0xFF223565), // Dark blue
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Send Rating',
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
          style: TextStyle(fontSize: 20, color: Colors.black),
        ),
        Theme(
          data: Theme.of(context).copyWith(
            sliderTheme: SliderThemeData(
              valueIndicatorTextStyle: TextStyle(
                color: Colors.white, // Change the color of the label text
              ),
            ),
          ),
          child: Slider(
            value: value,
            onChanged: onChanged,
            min: 0,
            max: 10,
            divisions: 10,
            label: '${value.toInt()}',
          ),
        )
      ],
    );
  }
}
