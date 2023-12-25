// import 'package:flutter/material.dart';

// import 'package:date_utils/date_utils.dart';
// import 'package:flutter/services.dart';
// import 'package:intl/intl.dart';
// import 'package:intrack/Student/resources/reminder/createReminderApi.dart';

// class PreviousHomework extends StatefulWidget {
//   final String userToken;
//   final String studentId;
//   PreviousHomework({
//     Key key,
//     this.userToken,
//     this.studentId,
//   }) : super(key: key);
//   @override
//   _PreviousHomeworkState createState() => _PreviousHomeworkState();
// }

// class _PreviousHomeworkState extends State<PreviousHomework> {
//   double cHeight;
//   double cWidth;

//   TextEditingController controller = TextEditingController();
//   final scaffoldKey = GlobalKey<ScaffoldState>();

//   DateTime _selectedDate = new DateTime.now();
//   List<DateTime> selectedMonthsDays;
//   Iterable<DateTime> selectedWeeksDays;
//   String displayDate;

//   DateTime currentDate = DateTime.now();
//   DateTime selected = DateTime.now();

//   DateTime _selectedDate1 = DateTime.now();
//   // use DateTime.now() istead of DateTime(2019,01,01)
//   String displayMonth1 = Utils.fullDayFormat(DateTime.now());

//   void _launchStartDate() async {
//     //display = false;

//     _selectedDate = _selectedDate1;
//     displayMonth1 = await selectDateFromPicker();
//     setState(() {
//       _selectedDate1 = _selectedDate;
//     });
//   }

//   Future<String> selectDateFromPicker() async {
//     DateTime _date = DateTime(3050);

//     selected = await showDatePicker(
//         context: context,
//         initialDate: _selectedDate,
//         firstDate: currentDate,
//         lastDate: _date);

//     if (selected != null) {
//       _selectedDate = selected;
//       displayDate = Utils.fullDayFormat(selected);
//     }
//     //print(displayMonth);
//     displayDate = DateFormat.MMMMEEEEd().format(_selectedDate);
//     return displayDate;
//   }

//   @override
//   Widget build(BuildContext context) {
//     cHeight = MediaQuery.of(context).size.height;
//     cWidth = MediaQuery.of(context).size.width;

//     EdgeInsets _pad;

//     _pad = EdgeInsets.only(
//         left: cWidth * 0.05,
//         right: cWidth * 0.05,
//         top: cHeight * 0.01,
//         bottom: cHeight * 0.01);

//     return Column(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: <Widget>[
//         Container(
//           child: Column(
//             children: <Widget>[
//               Padding(
//                 padding: _pad,
//                 child: Container(
//                   //color: Colors.lightBlue,
//                   child: GestureDetector(
//                     onTap: () {
//                       SystemChannels.textInput.invokeMethod('TextInput.hide');
//                       _launchStartDate();
//                     },
//                     child: Padding(
//                       padding: EdgeInsets.only(
//                         top: cHeight * 0.02,
//                         bottom: cHeight * 0.02,
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: <Widget>[
//                           Padding(
//                             padding: EdgeInsets.only(
//                               right: cWidth * 0.03,
//                             ),
//                             child: Icon(
//                               Icons.date_range,
//                               size: 30,
//                               color: Colors.orange,
//                             ),
//                           ),
//                           Text(
//                             displayMonth1,
//                             style: TextStyle(
//                               fontSize: cWidth * 0.05,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: _pad,
//                 child: TextField(
//                   controller: controller,
//                   keyboardType: TextInputType.multiline,
//                   maxLines: 4,
//                   decoration: InputDecoration(
//                     border: OutlineInputBorder(),
//                     hintText: "Description",
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         Row(
//           children: <Widget>[
//             Expanded(
//               child: MaterialButton(
//                 height: cHeight * 0.06,
//                 child: Text(
//                   "Add",
//                   style:
//                       TextStyle(color: Colors.white, fontSize: cWidth * 0.045),
//                 ),
//                 color: Color(0xFF444B54),
//                 onPressed: () {
//                   // addReminder();
//                   showDialogSingleButton(
//                     context,
//                     "Add Reminder",
//                     "You want to add this reminder",
//                     "Cancel",
//                     "Add",
//                   );
//                 },
//               ),
//             ),
//           ],
//         )
//       ],
//     );
//   }

//   void showDialogSingleButton(BuildContext context, String title,
//       String message, String buttonLabel1, String buttonLabel2) {
// //flutter define function
//     showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           //return object of type dialoge
//           return AlertDialog(
//             title: new Text("$title \n"),
//             content: new Text(message ?? "Empty"),
//             actions: <Widget>[
//               FlatButton(
//                 // usually buttons at the bottom of the dialog
//                 child: new Text(buttonLabel1),
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//               ),
//               FlatButton(
//                 // usually buttons at the bottom of the dialog
//                 child: new Text(buttonLabel2),
//                 onPressed: () {
//                   // _uploadHomework();
//                   Navigator.of(context).pop();
//                   createReminder(
//                     context,
//                     widget.userToken,
//                     "Add it",
//                     controller.text,
//                     selected.toString().substring(0, 10),
//                   );
//                   Navigator.of(context).pop(context);
//                 },
//               ),
//             ],
//           );
//         });
//   }
// }
