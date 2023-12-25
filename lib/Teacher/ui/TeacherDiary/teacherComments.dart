import 'package:flutter/material.dart';
import 'package:intrack/LoginPage/ui/feild.dart';

const String _name = "Rahul Rawat";

class TeacherComments extends StatelessWidget {
  final String text;
  final String teacherName;
  TeacherComments({this.text, this.teacherName});
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: new Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            new Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                new Text(
                  teacherName,
                  style: Theme.of(context).textTheme.subhead,
                ),
                new Container(
                  width: cWidth * 0.5,
                  margin: const EdgeInsets.only(top: 5.0),
                  child: new Text(
                    text,
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: new Container(
                margin: const EdgeInsets.only(right: 16.0),
                child: CircleAvatar(
                  backgroundColor: Color(0xFFFF6144),
                  child: new Text(
                    teacherName[0],
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
