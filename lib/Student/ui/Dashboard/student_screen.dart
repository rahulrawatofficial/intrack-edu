import 'package:flutter/material.dart';
import 'package:intrack/DeepLinking/bloc.dart';
import 'package:intrack/Student/ui/Dashboard/student_dashboard.dart';
import 'package:intrack/VideoCalling/old.dart';
import 'package:provider/provider.dart';

class StudentScreen extends StatefulWidget {
  final String userToken;
  final String userId;
  final String parentId;
  final String classId;
  final String sectionId;
  final String studentPic;

  const StudentScreen({
    Key key,
    this.userToken,
    this.userId,
    this.parentId,
    this.classId,
    this.sectionId,
    this.studentPic,
  }) : super(key: key);
  @override
  _StudentScreenState createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen> {
  @override
  Widget build(BuildContext context) {
    DeepLinkBloc _bloc = Provider.of<DeepLinkBloc>(context);
    return StreamBuilder<String>(
        stream: _bloc.state,
        builder: (context, snapshot) {
          print("##${snapshot.data}##");
          if (!snapshot.hasData) {
            return StudentDashBoard(
              userToken: widget.userToken,
              userId: widget.userId,
              parentId: widget.parentId,
              classId: widget.classId,
              sectionId: widget.sectionId,
              studentPic: widget.studentPic,
            );
          } else {
            return CallingScreen();
          }
        });
  }
}
