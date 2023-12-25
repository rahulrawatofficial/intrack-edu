// import 'package:flutter/material.dart';
// import 'package:intrack/Student/ui/Attendance/calender_view.dart';
// import 'package:intrack/Student/ui/Attendance/attendance_overview.dart';
// import 'package:intrack/Student/ui/homework/homework_page.dart';
// import 'package:intrack/Student/ui/homework/previous_homework.dart';

// class HomeworkMain extends StatefulWidget {
//   final String userToken;
//   final String studentId;

//   HomeworkMain({
//     Key key,
//     this.userToken,
//     this.studentId,
//   }) : super(key: key);
//   _HomeworkMainState createState() => _HomeworkMainState();
// }

// class _HomeworkMainState extends State<HomeworkMain> {
//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       initialIndex: 0,
//       length: 2,
//       child: new Scaffold(
//         appBar: new AppBar(
//           // leading: new IconButton(
//           //   icon: new Icon(Icons.arrow_back),
//           //   onPressed: () {
//           //     print('go to dashboard');
//           //   },
//           // ),
//           title: new Text('Homework'),
//           bottom: TabBar(
//             // unselectedLabelColor: Colors.grey,
//             labelColor: Colors.white,
//             indicatorColor: Colors.white,
//             tabs: <Widget>[
//               Tab(
//                 text: 'Homework List',
//               ),
//               Tab(
//                 text: 'Previous',
//               ),
//             ],
//           ),
//         ),
//         body: new TabBarView(
//           children: <Widget>[
//             HomeworkPage(
//               studentId: widget.studentId,
//               userToken: widget.userToken,
//             ),
//             PreviousHomework(
//               studentId: widget.studentId,
//               userToken: widget.userToken,
//             )
//             // CalenderView();
//           ],
//         ),
//       ),
//     );
//   }
// }
