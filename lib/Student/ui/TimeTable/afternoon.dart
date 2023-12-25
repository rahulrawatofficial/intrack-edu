import 'package:flutter/material.dart';
import 'package:intrack/Student/models/timetable_model.dart';

class Afternoon extends StatefulWidget {
  Afternoon({Key key, this.timeTable}) : super(key: key);

  final TimeTableModel timeTable;
  @override
  _AfternoonState createState() => _AfternoonState();
}

// Map<String, dynamic> myTimeTable ;//= new Map<String, dynamic>();
// var schoolToken =
//     "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjVjNGZmYmNkNzBiODY5MzExMmU1OWRjNSIsImVtYWlsIjoic2Nob29sMUBzY2hvb2wxLmNvbSIsInJvbGUiOiJBRE1JTiIsInN1cGVyQWRtaW5JZCI6IjVjNGZmYmNkNzBiODY5MzExMmU1OWRjNSIsImlhdCI6MTU0ODg1MTYxNywiZXhwIjoxNTQ4OTM4MDE3fQ.-ITn7LjuBGUmUPnvHNG9C6GhgDG89JCj8Bh6LGcOHB0";
// var idToken = "5c4ffd8270b8693112e59dd3";

class _AfternoonState extends State<Afternoon> {
  double cHieght;
  double cWidth;
  Color color1;
  Color currentDateTextColor;

  @override
  Widget build(BuildContext context) {
    var myTimeTable = widget.timeTable;
    DateTime currentDate = DateTime.now();
    int weekDay = currentDate.weekday;
    // print('i =  $weekDay');
    print(currentDate);
    if (myTimeTable == null) {
      return Center(child: CircularProgressIndicator());
    } else {
      List<dynamic> timeInList1 = new List(10);
      List<dynamic> timeOutList1 = new List(10);

      for (int i = 0; i < myTimeTable.data.schedule[0].lectures.length; i++) {
        timeInList1[i] = (myTimeTable.data.schedule[0].lectures[i].timeIn);
        timeOutList1[i] = (myTimeTable.data.schedule[0].lectures[i].timeOut);
      }
      return Container(
        height: cHieght,
        width: cWidth,
        child: new Column(
          children: <Widget>[
            defaultPeriodCard(timeInList1),
            new ListView.builder(
              shrinkWrap: true,
              itemCount: myTimeTable == null
                  ? 0
                  : myTimeTable.data.schedule == null
                      ? 0
                      : myTimeTable.data.schedule.length,
              itemBuilder: (BuildContext context1, int index1) {
                var k =
                    myTimeTable == null ? 0 : myTimeTable.data.schedule.length;
                print("itemcount $k");
                var day = myTimeTable.data.schedule[index1] == null
                    ? ""
                    : myTimeTable.data.schedule[index1].day.toString();
                List<dynamic> lecture = new List(10);
                List<dynamic> timeInList = new List(10);
                List<dynamic> timeOutList = new List(10);

                for (int i = 0;
                    i < myTimeTable.data.schedule[index1].lectures.length;
                    i++) {
                  if (lecture[i] == null) lecture[i] = "";
                }

                for (int i = 0;
                    i < myTimeTable.data.schedule[index1].lectures.length;
                    i++) {
                  lecture[i] = (myTimeTable
                      .data.schedule[index1].lectures[i].subjectName);
                  timeInList[i] =
                      (myTimeTable.data.schedule[index1].lectures[i].timeIn);
                  timeOutList[i] =
                      (myTimeTable.data.schedule[index1].lectures[i].timeOut);
                }
                currentDateTextColor = Colors.black;
                if (weekDay == index1 + 1) {
                  color1 = Color(0xFF444B54);
                  currentDateTextColor = Colors.white;
                } else
                  color1 = Colors.white;

                print("day :$day lecture: $lecture");
                // if (index1 > 0)
                return timeTableCard(
                  color1,
                  day,
                  lecture,
                );
              },
            ),
          ],
        ),
      );
    }
  }

  Card timeTableCard(Color color1, String day, List lectures) {
    cHieght = MediaQuery.of(context).size.height;
    cWidth = MediaQuery.of(context).size.width;

    EdgeInsetsGeometry _pad;

    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      _pad = EdgeInsets.only(
        top: cHieght * 0.01,
        left: cWidth * 0.01,
        bottom: cHieght * 0.01,
      );
    } else {
      _pad = EdgeInsets.only(
        top: cHieght * 0.1,
        left: cWidth * 0.5,
        bottom: cHieght * 0.1,
      );
    }

    return Card(
      //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
      margin: EdgeInsets.only(left: 5, right: 5, top: 10.0),
      //elevation: 5.0,
      color: color1,
      child: Container(
        child: Padding(
          padding: _pad,
          child: new Row(
            children: <Widget>[
              periodContainerDay(day),
              Divider(
                color: Colors.grey,
                // height: cHieght * 0.02,
              ),
              lectures[4] != null
                  ? subjectContainer(lectures[4].toString())
                  : Offstage(),
              lectures[5] != null
                  ? subjectContainer(lectures[5].toString())
                  : Offstage(),
              lectures[6] != null
                  ? subjectContainer(lectures[6].toString())
                  : Offstage(),
              lectures[7] != null
                  ? subjectContainer(lectures[7].toString())
                  : Offstage(),
            ],
          ),
        ),
      ),
    );
  }

  Container subjectContainer(String lecture) {
    cHieght = MediaQuery.of(context).size.height;
    cWidth = MediaQuery.of(context).size.width;
    return Container(
      child: Center(
        child: Text(
          lecture,
          style: new TextStyle(
              fontSize: cWidth * 0.037,
              fontWeight: FontWeight.w400,
              color: currentDateTextColor),
        ),
      ),
      height: cHieght * 0.06,
      width: cWidth * 0.185,
    );
  }

  Container periodContainer(String day, String time) {
    cHieght = MediaQuery.of(context).size.height;
    cWidth = MediaQuery.of(context).size.width;
    return Container(
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            time != null
                ? Text(
                    "$time",
                    style: new TextStyle(
                        fontSize: cHieght * 0.024, fontWeight: FontWeight.w400),
                  )
                : Text(
                    " ",
                    style: new TextStyle(
                        fontSize: cHieght * 0.025, fontWeight: FontWeight.w400),
                  ),
            Text(
              day,
              style: new TextStyle(
                  fontSize: cHieght * 0.025, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      height: cHieght * 0.06,
      width: cWidth * 0.185,
    );
  }

  Container periodContainerDay(String day) {
    cHieght = MediaQuery.of(context).size.height;
    cWidth = MediaQuery.of(context).size.width;
    return Container(
      child: Center(
        child: Text(
          day.substring(0, 3),
          style: new TextStyle(
              fontSize: cHieght * 0.025,
              fontWeight: FontWeight.w600,
              color: currentDateTextColor),
        ),
      ),
      height: cHieght * 0.06,
      width: cWidth * 0.185,
    );
  }

  Container defaultPeriodCard(List timeIn) {
    cHieght = MediaQuery.of(context).size.height;
    cWidth = MediaQuery.of(context).size.width;

    EdgeInsetsGeometry _pad;

    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      _pad = EdgeInsets.only(
        top: cHieght * 0.01,
        left: cWidth * 0.03,
        bottom: cHieght * 0.005,
        right: cWidth * 0.03,
      );
    } else {
      _pad = EdgeInsets.only(
        top: cHieght * 0.1,
        left: cWidth * 0.5,
        bottom: cHieght * 0.1,
      );
    }

    return Container(
      child: Padding(
        padding: _pad,
        child: new Row(
          children: <Widget>[
            periodContainer("Period", " "),
            periodContainer("5", timeIn[4]),
            periodContainer("6", timeIn[5]),
            periodContainer("7", timeIn[6]),
            periodContainer("8", timeIn[7])
          ],
        ),
      ),
    );
  }
}

// new ListView.builder(
//   itemCount: myTimeTable["data"]["timeTable"]["schedule"] == null
//       ? 0
//       : myTimeTable["data"]["timeTable"]["schedule"].length,
//   itemBuilder: (BuildContext context1, int index1) {
//     return ListView.builder(
//       itemCount:
//           myTimeTable["data"]["timeTable"]["schedule"][index1] == null
//               ? 0
//               : myTimeTable["data"]["timeTable"]["schedule"][index1]
//                   .length,
//       itemBuilder: (BuildContext context2, int index2) {
//         return timeTableCard(
//           myTimeTable["data"]["timeTable"]["schedule"][index1],
//           myTimeTable["data"]["timeTable"]["schedule"][index1]
//               ["lectures"][index2],
//           myTimeTable["data"]["timeTable"]["schedule"][index1]
//               ["lectures"][index2],
//           myTimeTable["data"]["timeTable"]["schedule"][index1]
//               ["lectures"][index2],
//           myTimeTable["data"]["timeTable"]["schedule"][index1]
//               ["lectures"][index2],
//         );
//       },
//     );
//   },
// ),

// new ListView.builder(
//             shrinkWrap: true,
//             itemCount: myTimeTable == null
//                 ? 0
//                 : myTimeTable.length,
//             itemBuilder: (BuildContext context1, int index1) {
//               return timeTableCard(
//                   myTimeTable[index1],
//                   "gf",
//                   "gffg",
//                   "gfgf",
//                   "fgfgf"
//                   //   );
//                   // },
//                   );
//             },
//           ),
