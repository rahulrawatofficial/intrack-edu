import 'package:flutter/material.dart';

const String _name = "Rachna";

class TeacherComments extends StatelessWidget {
  final String text;
  final String teacherName;
  double cHeight;
  double cWidth;
  TeacherComments({this.text, this.teacherName});
  @override
  Widget build(BuildContext context) {
    cHeight = MediaQuery.of(context).size.height;
    cWidth = MediaQuery.of(context).size.width;
    return new Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Container(
            margin: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundColor: Color(0xFF444B54),
              child: new Text(teacherName[0],style: TextStyle(color: Colors.white,),),
            ),
          ),
          new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Text(teacherName, style: Theme.of(context).textTheme.subhead),
              new Container(
                height: cHeight * 0.05,
                width: cWidth * 0.4,
                margin: const EdgeInsets.only(top: 5.0),
                child: new Text(text),
              ),
            ],
          )
        ],
      ),
    );
  }
}
