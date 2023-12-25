import 'package:flutter/material.dart';
import 'package:intrack/Student/models/result_model.dart';
import 'package:intrack/Student/ui/ResultU/NormalView.dart';
import 'package:intrack/Student/ui/ResultU/graphView.dart';
import 'package:intrack/Student/ui/ResultU/pieChart.dart';

class ViewInsights extends StatefulWidget {
  ViewInsights({
    Key key,
    this.title,
    this.data,
    this.index,
    this.userToken,
    this.studentId,
    this.sectionId,
  }) : super(key: key);
  final String title;
  final int index;
  final ResultModel data;
  final String userToken;
  final String studentId;
  final String sectionId;

  _ViewInsightsState createState() => _ViewInsightsState();
}

// Flutter catalog

class _ViewInsightsState extends State<ViewInsights> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: new Scaffold(
        // backgroundColor: Colors.white,
        appBar: new AppBar(
          title: new Text('${widget.title}'),
          bottom: new TabBar(
            // isScrollable: true,
            labelColor: Colors.white,
            indicatorColor: Colors.white,
            tabs: <Widget>[
              Tab(
                text: 'Normal View',
              ),
              // Tab(
              //   text: 'Vs Other Exams',
              // ),
              Tab(
                text: 'Graphical ', //Analysis',
              ),
              Tab(
                text: 'Comparison ', //Analysis',
              ),
              // Tab(
              //   text: 'Overall ', //Comparision',
              // ),
            ],
          ),
        ),
        body: new TabBarView(
          children: <Widget>[
            ListView(
              // shrinkWrap: true,
              children: <Widget>[
                Insights(
                  title: widget.title,
                  mydata: widget.data.data[widget.index],
                  data: widget.data,
                  index: widget.index,
                  userToken: widget.userToken,
                  studentId: widget.studentId,
                  sectionId: widget.sectionId,
                ),
              ],
            ),
            ListView(
              // shrinkWrap: true,
              children: <Widget>[
                Insights2(
                  title: widget.title,
                  mydata: widget.data.data[widget.index],
                  data: widget.data,
                  index: widget.index,
                ),
              ],
            ),
            ListView(
              // shrinkWrap: true,
              children: <Widget>[
                PieChartPage(
                  percentage: widget.data.data[widget.index].percentage,
                  userToken: widget.userToken,
                  studentId: widget.studentId,
                  sectionId: widget.sectionId,
                ),
              ],
            ),
            // ListView(
            //   children: <Widget>[
            //     VsOtherExams(title: widget.title, mydata: widget.data),
            //   ],
            // ),
            // ListView(
            //   children: <Widget>[
            //     SubjectWiseAnalysis(mydata: widget.data),
            //   ],
            // ),
            // ListView(
            //   children: <Widget>[
            //     OverallPerformance(
            //       title: widget.title,
            //       mydata: widget.data.data[widget.index],
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}
