import 'package:flutter/material.dart';
import 'package:intrack/Student/ui/Attendance/calender_view.dart';
import 'package:intrack/Student/ui/Attendance/attendance_overview.dart';
import 'package:intrack/Student/ui/Courses/course_attendance.dart';
import 'package:intrack/Student/ui/Courses/courses_detail.dart';

class CoursesTab extends StatefulWidget {
  final String userToken;
  final String studentId;
  final String classId;
  final String studentName;
  CoursesTab({
    Key key,
    this.userToken,
    this.studentId,
    this.classId,
    this.studentName,
  }) : super(key: key);
  _CoursesTabState createState() => _CoursesTabState();
}

class _CoursesTabState extends State<CoursesTab> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: new Scaffold(
        appBar: new AppBar(
          // leading: new IconButton(
          //   icon: new Icon(Icons.arrow_back),
          //   onPressed: () {
          //     print('go to dashboard');
          //   },
          // ),
          title: new Text('Courses'),
          bottom: TabBar(
            // unselectedLabelColor: Colors.grey,
            labelColor: Colors.white,
            indicatorColor: Colors.white,
            tabs: <Widget>[
              Tab(
                text: 'My Courses',
              ),
              Tab(
                text: 'Attendance',
              ),
            ],
          ),
        ),
        body: new TabBarView(
          children: <Widget>[
            CourseDetail(
              userToken: widget.userToken,
              studentId: widget.studentId,
              classId: widget.classId,
              studentName: widget.studentName,
            ),
            ListView(
              children: <Widget>[
                CourseAttendance(
                  userToken: widget.userToken,
                  studentId: widget.studentId,
                  classId: widget.classId,
                ),
              ],
            )
            // CalenderView();
          ],
        ),
      ),
    );
  }
}
