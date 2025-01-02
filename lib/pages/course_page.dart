import 'package:flutter/material.dart';
import '../widgets/bottomNavigationBarCustom.dart'; // Import the custom bottom navigation bar
import 'course_details_page.dart';
import '../theme/theme_helper.dart';

class CoursePage extends StatefulWidget {
  @override
  _CoursePageState createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  final TextEditingController _searchController = TextEditingController();
  final List<Map<String, String>> courses = [
    {'title': 'Circuit Analysis', 'description': 'Electrical Engineering'},
    {'title': 'Thermodynamics', 'description': 'Mechanical Engineering'},
    {'title': 'Data Structures', 'description': 'Computer Science'},
  ];

  List<Map<String, String>> filteredCourses = [];

  @override
  void initState() {
    super.initState();
    filteredCourses = courses; // Initialize with all courses
    _searchController.addListener(_filterCourses);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterCourses);
    _searchController.dispose();
    super.dispose();
  }

  void _filterCourses() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredCourses = courses
          .where((course) =>
              course['title']!.toLowerCase().contains(query) ||
              course['description']!.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Courses',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF003366), // Dark Blue
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: Icon(Icons.search, color: Color(0xFF003366)),
                hintStyle: TextStyle(color: Color(0xFF003366)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor:Color(0xFFCBD0E2), // Light Blue
              ),
            ),
          ),
          // Course List
          Expanded(
            child: ListView.builder(
              itemCount: filteredCourses.length,
              itemBuilder: (context, index) {
                return Card(
                  color: const Color(0xFF003366), // Dark Blue
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 10,
                    ),
                    title: Text(
                      filteredCourses[index]['title']!,
                      style: const TextStyle(
                        color: Colors.white, // White text
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      filteredCourses[index]['description']!,
                      style: const TextStyle(
                        color: Colors.white70, // Lighter white for subtitle
                        fontSize: 14,
                      ),
                    ),
                    trailing: SizedBox(
                      width: 50,
                      child: Image.asset(
                        'assets/images/${filteredCourses[index]['title']!.toLowerCase().replaceAll(' ', '_')}.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              CourseDetailsPage(course: filteredCourses[index]),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBarCustom(1, context), // Use the custom navigation bar
    );
  }
}


