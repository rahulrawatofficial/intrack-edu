import 'package:flutter/material.dart';
import 'package:intrack/Teacher/ui/UploadAttendance/attendance_list.dart';
import 'package:intrack/Teacher/ui/UploadAttendance/previous_attendance.dart';

class UploadAttendanceMain extends StatefulWidget {
  final String userToken;
  final String sectionId;
  final classData;

  final classId;

  UploadAttendanceMain({
    Key key,
    this.userToken,
    this.sectionId,
    this.classData,
    this.classId,
  }) : super(key: key);
  _UploadAttendanceMainState createState() => _UploadAttendanceMainState();
}

class _UploadAttendanceMainState extends State<UploadAttendanceMain> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: new Scaffold(
        resizeToAvoidBottomPadding: false,
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
                text: 'Upload',
              ),
              Tab(
                text: 'Previous',
              ),
            ],
          ),
        ),
        body: new TabBarView(
          children: <Widget>[
            AttendanceList(
              // classData: widget.classData,
              userToken: widget.userToken,
              classId: widget.classId,
              sectionId: widget.sectionId,
            ),
            PreviousAttendance(
              classData: widget.classData,
              userToken: widget.userToken,
              sectionId: widget.sectionId,
            ),
            // CalenderView();
          ],
        ),
      ),
    );
  }
}
