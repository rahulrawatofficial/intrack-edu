// import 'package:flutter/material.dart';
// import 'package:intrack/Student/models/timetable_model.dart';
// import 'package:intrack/Student/ui/TimeTable/newnoon.dart';
// import 'forenoon.dart';
// import 'afternoon.dart';
// import 'package:intrack/Student/blocs/timetable_bloc.dart';

// class TimeTable extends StatefulWidget {
//   final String userToken;
//   final String studentId;
//   TimeTable({
//     Key key,
//     this.userToken,
//     this.studentId,
//   }) : super(key: key);
//   @override
//   _TimeTableState createState() => _TimeTableState();
// }

// // _InternalLinkedHashMap<String, dynamic> jk;
// TimeTableModel timeTable;

// class _TimeTableState extends State<TimeTable> {
//   final String url = "http://139.59.58.160:8001/v1/studentViewTimeTable";

//   @override
//   void initState() {
//     super.initState();
//     print(widget.studentId);
//     timeTableBloc.fetchAllTimeTable(
//         context, widget.userToken, widget.studentId);
//     //print(timeTable.data.id);
//     //this._postConnect();
//     // });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder(
//         stream: timeTableBloc.allTimeTable,
//         builder: (context, AsyncSnapshot<TimeTableModel> snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Scaffold(
//                 appBar: AppBar(
//                   title: Text("Time Table"),
//                 ),
//                 body: Center(
//                   child: CircularProgressIndicator(),
//                 ));
//           } else {
//             if (snapshot.hasData) {
//               return DefaultTabController(
//                 length:
//                     snapshot.data.data.schedule[0].lectures.length > 8 ? 3 : 2,
//                 child: Scaffold(
//                   appBar: new AppBar(
//                     title: new Text("TimeTable"),
//                     bottom: TabBar(
//                       // isScrollable: true,
//                       labelColor: Colors.white,
//                       indicatorColor: Colors.white,
//                       tabs: snapshot.data.data.schedule[0].lectures.length > 8
//                           ? <Widget>[
//                               Tab(
//                                 text: "Forenoon",
//                               ),
//                               Tab(text: "Afternoon"),
//                               Tab(text: "Afternoon"),
//                             ]
//                           : <Widget>[
//                               Tab(
//                                 text: "Forenoon",
//                               ),
//                               Tab(text: "Afternoon"),
//                             ],
//                     ),
//                   ),
//                   body: TabBarView(
//                     children: snapshot.data.data.schedule[0].lectures.length > 8
//                         ? <Widget>[
//                             Forenoon(
//                               timeTable: snapshot.data,
//                             ),
//                             Afternoon(
//                               timeTable: snapshot.data,
//                             ),
//                             Newnoon(
//                               timeTable: snapshot.data,
//                             )
//                           ]
//                         : <Widget>[
//                             Forenoon(
//                               timeTable: snapshot.data,
//                             ),
//                             Afternoon(
//                               timeTable: snapshot.data,
//                             ),
//                           ],
//                   ),
//                 ),
//               );
//             } else {
//               return Scaffold(
//                   appBar: AppBar(
//                     title: Text("TimeTable"),
//                   ),
//                   body: Center(
//                     child: Text("No Data Found"),
//                   ));
//             }
//           }
//         });
//   }
// }
