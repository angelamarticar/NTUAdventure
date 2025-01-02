import 'package:flutter/material.dart';
import '../widgets/bottomNavigationBarCustom.dart';
import 'course_rating_page.dart';
import '../theme/theme_helper.dart';

class CourseDetailsPage extends StatelessWidget {
  final Map<String, String> course;

  CourseDetailsPage({required this.course});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Course Details',
          style: TextStyle(color: Colors.white), // White text on the app bar
        ),
        backgroundColor:Color(0xFF223565), // Dark blue top bar
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

           

            // Course title and department
            Text(
              'Thermodynamics',
              style: Theme.of(context).textTheme.displaySmall,
            ),
            SizedBox(height: 8),
            Text(
              'Mechanical Engineering',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.grey[600]),
            ),
            SizedBox(height: 20),
             Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage('assets/prof_kirk.jpg'), // Replace with the actual image path
                ),
                SizedBox(width: 16),
                Text(
                  'Prof. Dr. Kirk',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 20),
            // Dummy course description
            Text(
              'This course covers the principles of thermodynamics and their application to engineering systems. '
              'Topics include the laws of thermodynamics, properties of pure substances, energy and entropy analysis, '
              'thermodynamic cycles, and phase behavior. Students will analyze power generation, refrigeration, and heat transfer systems using theoretical and practical approaches.\n\n'
              'Through problem-solving and case studies, students will gain a solid understanding of energy transformations '
              'and the design of thermodynamic systems, preparing them for advanced engineering challenges.\n\n'
              'Prerequisites: Basic knowledge of physics and calculus.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.5, color: Colors.black),
            ),
            SizedBox(height: 20),

            // Ratings section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildLargeRatingButton(context, 'Workload', '8/10'),
                _buildLargeRatingButton(context, 'Difficulty', '8/10'),
                _buildLargeRatingButton(context, 'Overall', '8/10'),
              ],
            ),
            SizedBox(height: 20),

            // Language and Semester side by side
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildMetadataButton(context, 'Language', 'English'),
                _buildMetadataButton(context, 'Semester', 'Winter'),
              ],
            ),
            SizedBox(height: 20
            ),

            // Rate Course Button
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF223565),
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20), // Increased height
                  textStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CourseRatingPage(courseTitle: 'Thermodynamics'),
                    ),
                  );
                },
                child: Text(
                  'Rate Course',
                  style: TextStyle(color: Colors.white), // White text
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBarCustom(1, context),
    );
  }

  Widget _buildLargeRatingButton(BuildContext context, String title, String rating) {
    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: Color(0xFFCBD0E2),
            borderRadius: BorderRadius.circular(50),
          ),
          child: Center(
            child: Text(
              rating,
              style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        SizedBox(height: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.grey[700]),
        ),
      ],
    );
  }

  Widget _buildMetadataButton(BuildContext context, String title, String value) {
    return Container(
      width: 100, // Same width as the rating buttons
      height: 100, // Same height as the rating buttons
      decoration: BoxDecoration(
        color: Color(0xFFCBD0E2),
        borderRadius: BorderRadius.circular(50), // Circular button
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[700]),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}