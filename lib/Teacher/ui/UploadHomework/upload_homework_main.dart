import 'package:flutter/material.dart';
import 'package:intrack/Teacher/ui/UploadHomework/teacher_previous_homework.dart';
import 'package:intrack/Teacher/ui/UploadHomework/uploadhomework.dart';

class UploadHomeworkMain extends StatefulWidget {
  final String userToken;
  final String sectionId;
  final classData;
  final List subjects;

  UploadHomeworkMain({
    Key key,
    this.userToken,
    this.sectionId,
    this.classData,
    this.subjects,
  }) : super(key: key);
  _UploadHomeworkMainState createState() => _UploadHomeworkMainState();
}

class _UploadHomeworkMainState extends State<UploadHomeworkMain> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: new Scaffold(
        resizeToAvoidBottomPadding: true,
        appBar: new AppBar(
          // leading: new IconButton(
          //   icon: new Icon(Icons.arrow_back),
          //   onPressed: () {
          //     print('go to dashboard');
          //   },
          // ),
          title: new Text('Homework'),
          bottom: TabBar(
            // unselectedLabelColor: Colors.grey,
            labelColor: Colors.white,
            indicatorColor: Colors.white,
            tabs: <Widget>[
              Tab(
                text: 'Upload Homework',
              ),
              Tab(
                text: 'Previous',
              ),
            ],
          ),
        ),
        body: new TabBarView(
          children: <Widget>[
            UploadHomework(
              // studentId: widget.studentId,
              classData: widget.classData,
              userToken: widget.userToken,
              subjects: widget.subjects,
            ),
            TeacherPreviousHomework(
              sectionId: widget.sectionId,
              userToken: widget.userToken,
              classData: widget.classData,
              subjects: widget.subjects,
            )
            // CalenderView();
          ],
        ),
      ),
    );
  }
}
