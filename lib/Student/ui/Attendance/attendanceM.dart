import 'package:flutter/material.dart';
import 'package:intrack/Student/ui/Attendance/calender_view.dart';
import 'package:intrack/Student/ui/Attendance/attendance_overview.dart';

class Attendance extends StatefulWidget {
  final String userToken;
  final String studentId;
  Attendance({
    Key key,
    this.userToken,
    this.studentId,
  }) : super(key: key);
  _AttendanceState createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
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
          title: new Text('Attendance'),
          bottom: TabBar(
            // unselectedLabelColor: Colors.grey,
            labelColor: Colors.white,
            indicatorColor: Colors.white,
            tabs: <Widget>[
              Tab(
                text: 'OverView',
              ),
              Tab(
                text: 'Calender View',
              ),
            ],
          ),
        ),
        body: new TabBarView(
          children: <Widget>[
            ListView(
              children: <Widget>[
                OverView(
                  userToken: widget.userToken,
                  studentId: widget.studentId,
                ),
              ],
            ),
            ListView(
              children: <Widget>[
                CalenderView(
                  userToken: widget.userToken,
                  studentId: widget.studentId,
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
