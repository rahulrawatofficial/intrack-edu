import 'package:flutter/material.dart';
import 'package:intrack/Student/models/timetable_model.dart';

class Forenoon extends StatefulWidget {
  Forenoon({Key key, this.timeTable}) : super(key: key);

  final TimeTableModel timeTable;
  @override
  _ForenoonState createState() => _ForenoonState();
}

class _ForenoonState extends State<Forenoon> {
  double cHieght;
  double cWidth;

  @override
  Widget build(BuildContext context) {
    cHieght = MediaQuery.of(context).size.height;
    cWidth = MediaQuery.of(context).size.width;
    Data tData = widget.timeTable.data;

    return Column(
      children: <Widget>[
        Card(
          child: Row(
            children: <Widget>[
              Container(
                width: cWidth * 0.15,
                child: Center(child: Text("Time")),
              ),
              Container(
                width: cWidth * 0.8,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(5, (indexR) {
                    return Container(
                        height: cHieght * 0.06,
                        width: cWidth * 0.16,
                        child: Center(
                            child: Text(tData
                                .schedule[0].lectures[indexR].timeIn
                                .toString())));
                  }),
                ),
              ),
            ],
          ),
        ),
        Card(
          child: Row(
            children: <Widget>[
              Container(
                width: cWidth * 0.15,
                child: Center(child: Text("Period")),
              ),
              Container(
                width: cWidth * 0.8,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(5, (indexR) {
                    return Container(
                        height: cHieght * 0.06,
                        width: cWidth * 0.16,
                        child: Center(child: Text(indexR.toString())));
                  }),
                ),
              ),
            ],
          ),
        ),
        Column(
          children: List.generate(tData.schedule.length, (indexL) {
            // int subjectLength= (tData.schedule[indexL].lectures.length / 2).toInt();
            return Card(
              child: Row(
                children: <Widget>[
                  Container(
                    width: cWidth * 0.15,
                    child: Center(child: Text("MON")),
                  ),
                  Container(
                    width: cWidth * 0.8,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(5, (indexR) {
                        return Container(
                            height: cHieght * 0.06,
                            width: cWidth * 0.16,
                            child: Center(
                                child: Text(
                              tData.schedule[indexL].lectures[indexR]
                                  .subjectName,
                              style: TextStyle(fontSize: 10),
                            )));
                      }),
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ],
    );
  }
}
