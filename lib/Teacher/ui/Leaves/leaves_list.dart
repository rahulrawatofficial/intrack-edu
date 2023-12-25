import 'package:flutter/material.dart';
import 'package:intrack/Student/ui/Attendance/calender_view.dart';
import 'package:intrack/Student/ui/Attendance/attendance_overview.dart';
import 'package:intrack/Teacher/ui/Leaves/approved_leaves.dart';
import 'package:intrack/Teacher/ui/Leaves/pending_leaves.dart';
import 'package:intrack/Teacher/ui/Leaves/rejected_leaves.dart';

class LeavesList extends StatefulWidget {
  final String userToken;
  final String classId;
  final String sectionId;
  LeavesList({
    Key key,
    this.userToken,
    this.classId,
    this.sectionId,
  }) : super(key: key);
  _LeavesListState createState() => _LeavesListState();
}

class _LeavesListState extends State<LeavesList> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: new Scaffold(
        appBar: new AppBar(
          // leading: new IconButton(
          //   icon: new Icon(Icons.arrow_back),
          //   onPressed: () {
          //     print('go to dashboard');
          //   },
          // ),
          title: new Text('Student Leaves'),
          bottom: TabBar(
            // unselectedLabelColor: Colors.grey,
            labelColor: Colors.white,
            indicatorColor: Colors.white,
            tabs: <Widget>[
              Tab(
                text: 'Pending',
              ),
              Tab(
                text: 'Approved',
              ),
              Tab(
                text: 'Rejected',
              ),
            ],
          ),
        ),
        body: new TabBarView(
          children: <Widget>[
            PendingLeaves(
              classId: widget.classId,
              sectionId: widget.sectionId,
              userToken: widget.userToken,
            ),
            ApprovedLeaves(
              classId: widget.classId,
              sectionId: widget.sectionId,
              userToken: widget.userToken,
            ),
            RejectedLeaves(
              classId: widget.classId,
              sectionId: widget.sectionId,
              userToken: widget.userToken,
            ),
            // CalenderView();
          ],
        ),
      ),
    );
  }
}
