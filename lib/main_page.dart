import 'package:flutter/material.dart';
import 'package:intrack/DeepLinking/bloc.dart';
import 'package:intrack/ForceUpdate/force_update_screen.dart';
import 'package:intrack/LoginPage/ui/login_page.dart';
import 'package:intrack/Student/ui/MpinPage/mpin_page.dart';
import 'package:intrack/Teacher/ui/Dashboard/teacher_dashboard.dart';
import 'package:intrack/VideoCalling/dlink_calling_screen.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  final bool needUpdate;
  final String userToken;
  final String userRole;
  final String userId;
  final String studentPic;
  final String parentId;
  final String classId;
  final String sectionId;
  final String studentName;
  final bool pinExist;
  final int mPin;
  const MainPage(
      {Key key,
      this.needUpdate,
      this.userToken,
      this.userRole,
      this.userId,
      this.studentPic,
      this.parentId,
      this.classId,
      this.sectionId,
      this.studentName,
      this.pinExist,
      this.mPin})
      : super(key: key);
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    DeepLinkBloc _bloc = Provider.of<DeepLinkBloc>(context);
    return StreamBuilder<String>(
        stream: _bloc.state,
        builder: (context, snapshot) {
          print(snapshot.data);
          if (!snapshot.hasData) {
            return widget.needUpdate
                ? ForcaUpdateScreen()
                : widget.userToken == null
                    ? LoginPage()
                    : widget.userRole == "TEACHER"
                        ? TeacherDashBoard(
                            userToken: widget.userToken,
                            userId: widget.userId,
                            teacherPic: widget.studentPic,
                          )
                        : MpinPage(
                            userToken: widget.userToken,
                            userId: widget.userId,
                            parentId: widget.parentId,
                            classId: widget.classId,
                            sectionId: widget.sectionId,
                            studentPic: widget.studentPic,
                            pinExist: widget.pinExist,
                            mPin: widget.mPin,
                            studentName: widget.studentName,
                          );
          } else {
            return DLinkCallingScreen(
              url: snapshot.data,
              userToken: widget.userToken,
              userId: widget.userId,
              parentId: widget.parentId,
              classId: widget.classId,
              sectionId: widget.sectionId,
              studentPic: widget.studentPic,
              studentName: widget.studentName,
            );
          }
        });
  }
}
