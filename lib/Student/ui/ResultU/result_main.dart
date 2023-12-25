import 'package:flutter/material.dart';
import 'package:intrack/Student/ui/ResultU/overall.dart';
import 'package:intrack/Student/ui/ResultU/resultPage.dart';

class Result extends StatefulWidget {
  final String userToken;
  final String studentId;
  final String sectionId;
  Result({
    Key key,
    this.userToken,
    this.studentId,
    this.sectionId,
  }) : super(key: key);
  _ResultState createState() => _ResultState();
}

class _ResultState extends State<Result> {
  double cHeight;
  double cWidth;

  @override
  Widget build(BuildContext context) {
    cHeight = MediaQuery.of(context).size.width;
    cWidth = MediaQuery.of(context).size.height;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: new AppBar(
          title: new Text("Performance"),
          bottom: new TabBar(
            labelColor: Colors.white,
            indicatorColor: Colors.white,
            tabs: <Widget>[
              Tab(
                text: 'Exam-Type',
              ),
              Tab(
                text: 'Overall ',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            ResultPage(
              userToken: widget.userToken,
              studentId: widget.studentId,
              sectionId: widget.sectionId,
            ),
            OverallPerformance(
              userToken: widget.userToken,
              studentId: widget.studentId,
              sectionId: widget.sectionId,
            ),
          ],
        ),
      ),
    );
  }
}
