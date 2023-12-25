import 'package:flutter/material.dart';
import 'package:intrack/Teacher/ui/UploadSyllabus/previous_syllabus.dart';
import 'package:intrack/Teacher/ui/UploadSyllabus/upload_syllabus.dart';

class UploadSyllabusMain extends StatefulWidget {
  final String userToken;
  final String classId;
  final String sectionId;
  final List subjects;

  UploadSyllabusMain({
    Key key,
    this.userToken,
    this.sectionId,
    this.classId,
    this.subjects,
  }) : super(key: key);
  _UploadSyllabusMainState createState() => _UploadSyllabusMainState();
}

class _UploadSyllabusMainState extends State<UploadSyllabusMain> {
  @override
  void initState() {
    super.initState();
  }

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
          title: new Text('Syllabus'),
          bottom: TabBar(
            // unselectedLabelColor: Colors.grey,
            labelColor: Colors.white,
            indicatorColor: Colors.white,
            tabs: <Widget>[
              Tab(
                text: 'Upload Syllabus',
              ),
              Tab(
                text: 'All Syllabus',
              ),
            ],
          ),
        ),
        body: new TabBarView(
          children: <Widget>[
            UploadSyllabus(
              // studentId: widget.studentId,
              classId: widget.classId,
              sectionId: widget.sectionId,
              userToken: widget.userToken,
              subjects: widget.subjects,
            ),
            TeacherPreviousSyllabus(
              sectionId: widget.sectionId,
              userToken: widget.userToken,
            )
            // CalenderView();
          ],
        ),
      ),
    );
  }
}
