import 'package:flutter/material.dart';
import 'package:intrack/Student/models/diary/get_student_diary_model.dart';
import 'package:intrack/Student/models/diary/task.dart';
import 'package:intrack/Student/ui/Diary/comments_page.dart';
import 'package:intrack/Student/ui/Diary/diaryPage.dart';

class TaskRow extends StatefulWidget {
  final Datum task;
  final bool printDate;
  final double dotSize = 10;
  final String userToken;
  final String diaryId;
  final String studentId;

  const TaskRow({
    Key key,
    this.task,
    this.printDate,
    this.userToken,
    this.diaryId,
    this.studentId,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TaskRowState();
  }
}

var currentDate = DateTime.now();

class TaskRowState extends State<TaskRow> {
  @override
  Widget build(BuildContext context) {
    // print("DateTaskRow: " + "${widget.task.date}");
    return Column(
      children: <Widget>[
        Container(
          color: Colors.grey[50],
          child: Align(
              alignment: Alignment.topLeft,
              child: !widget.printDate
                  ? Container()
                  : dateCondition(DateTime.parse(widget.task.date))),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 45 - widget.dotSize / 2, vertical: 8),
                  child: Container(
                    height: widget.dotSize,
                    width: widget.dotSize,
                    // child: Image(
                    //   image: AssetImage(widget.task.image),
                    // ),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      widget.task.title,
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          "Teacher",
                          style: TextStyle(
                            fontSize: 12.0,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          " . " + widget.task.date.substring(0, 10),
                          style: TextStyle(
                            fontSize: 12.0,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  right: cWidth * 0.02,
                ),
                child: PhysicalModel(
                  color: Colors.grey[50],
                  // borderRadius: BorderRadius.circular(25),
                  shape: BoxShape.circle,
                  child: FlatButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CommentsPage(
                              userToken: widget.userToken,
                              diaryId: widget.diaryId,
                              studentId: widget.studentId,
                            ),
                          ));
                    },
                    child: Icon(
                      Icons.message,
                      color: Color(0xFF444B54),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
