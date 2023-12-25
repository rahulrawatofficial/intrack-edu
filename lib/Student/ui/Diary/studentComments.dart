import 'package:flutter/material.dart';

const String _name = "Rahul Rawat";

class StudentComments extends StatelessWidget {
  final String text;
  final String studentName;
  double cHeight;
  double cWidth;
  StudentComments({this.text, this.studentName});
  @override
  Widget build(BuildContext context) {
    cHeight = MediaQuery.of(context).size.height;
    cWidth = MediaQuery.of(context).size.width;
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
                new Text(studentName,
                    style: Theme.of(context).textTheme.subhead),
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
                  backgroundColor: Color(0xFF444B54),
                  child: new Text(
                    studentName[0],
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
