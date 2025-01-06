import 'package:flutter/material.dart';
import '../db_helper.dart';
import 'course_details_page.dart';
import '../widgets/bottomNavigationBarCustom.dart';
import 'package:ntuadventure/theme/theme_helper.dart';

class CoursePage extends StatefulWidget {
  @override
  _CoursePageState createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _courses = [];
  List<Map<String, dynamic>> _filteredCourses = [];

  @override
  void initState() {
    super.initState();
    _fetchCourses();
    _searchController.addListener(_filterCourses);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterCourses);
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchCourses() async {
    final dbHelper = DatabaseHelper();
    final courses = await dbHelper.getAll('courses');
    setState(() {
      _courses = courses;
      _filteredCourses = courses; // Initially show all courses
    });
  }

  void _filterCourses() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredCourses = _courses
          .where((course) =>
              course['name'].toLowerCase().contains(query) ||
              course['school'].toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Courses',
          style: TextStyle(color: theme.colorScheme.onPrimaryContainer),
        ),
        backgroundColor: theme.colorScheme.primary, // Light blue
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
                fillColor: Color(0xFFCBD0E2), // Light Blue
              ),
            ),
          ),
          // Course List
          Expanded(
            child: _filteredCourses.isEmpty
                ? Center(
                    child: Text(
                      'No courses found.',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 18,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: _filteredCourses.length,
                    itemBuilder: (context, index) {
                      final course = _filteredCourses[index];
                      return Card(
                        color: const Color(0xFF003366), // Dark Blue
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 10,
                          ),
                          title: Text(
                            course['name'],
                            style: const TextStyle(
                              color: Colors.white, // White text
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Text(
                            course['school'],
                            style: const TextStyle(
                              color: Colors.white70, // Lighter white for subtitle
                              fontSize: 14,
                            ),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CourseDetailsPage(
                                  courseId: index + 1, // Replace with actual course ID from the database
                                ),
                              ),
                            );
                          }

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
