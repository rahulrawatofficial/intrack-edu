// import 'package:flutter/material.dart';
// import 'package:charts_flutter/flutter.dart' as charts;

// import 'package:intrack/Student/models/result_model.dart';

// var color = [
//   Colors.pinkAccent,
//   Colors.grey,
//   Colors.yellow,
//   Colors.blue,
//   Colors.green,
// ];

// class MarksObtained {
//   final String subject;
//   final int marks;
//   final charts.Color color; // = Colors.blue;

//   MarksObtained(this.subject, this.marks, Color color)
//       : this.color = charts.Color(
//             r: color.red, g: color.green, b: color.blue, a: color.alpha);
// }

// double cHeight;
// double cWidth;
// var myData;
// List<int> data2 = [
//   30,
//   20,
//   10,
//   15,
//   16,
// ];

// class SubjectWiseAnalysis extends StatefulWidget {
//   SubjectWiseAnalysis({
//     Key key,
//     this.mydata,
//     this.title,
//     this.index,
//   }) : super(key: key);
//   final ResultModel mydata;
//   final title;
//   final index;
//   State createState() => _SubjectWiseAnalysisState();
// }

// class _SubjectWiseAnalysisState extends State<SubjectWiseAnalysis> {
//   @override
//   Widget build(BuildContext context) {
//     print("data: ${widget.mydata}");
//     cHeight = MediaQuery.of(context).size.height;
//     cWidth = MediaQuery.of(context).size.width;

//     EdgeInsets _pad = EdgeInsets.only(
//         // top: cHeight * 0.04,
//         // left: cWidth * 0.04,
//         // right: cWidth * 0.04,
//         // bottom: cHeight * 0.2,
//         );

//     return Scaffold(
//       appBar: AppBar(
//         title: Text("${widget.title.toString() ?? ""} vs. average"),
//       ),
//       body: Container(
//         padding: _pad,
//         decoration: BoxDecoration(
//           color: Colors.white70,
//         ),
//         child: showChart(),
//       ),
//     );
//   }

//   // Widget inputDisplay(double cHeight, double cWidth, int index) {
//   //   if (MediaQuery.of(context).orientation == Orientation.landscape) {
//   //     var r = cHeight;
//   //     cHeight = cWidth;
//   //     cWidth = r;
//   //   }

//   //   return Padding(
//   //     padding: EdgeInsets.only(
//   //       top: cHeight * 0.05,
//   //     ),
//   //     child:  Card(
//   //       elevation: 5.0,
//   //       shape: RoundedRectangleBorder(
//   //         borderRadius: BorderRadius.circular(10.0),
//   //       ),
//   //       child: Padding(
//   //         padding: EdgeInsets.only(
//   //           top: cHeight * 0.02,
//   //           bottom: cHeight * 0.02,
//   //           left: cWidth * 0.001,
//   //           right: cWidth * 0.001,
//   //         ),
//   //         child:  ListTile(
//   //           title:  Text("data"),
//   //           leading:  CircleAvatar(
//   //             radius: cHeight * 0.05,
//   //             backgroundColor: Colors.blue,
//   //             child:  Text("$index"),
//   //           ),
//   //         ),
//   //       ),
//   //     ),
//   //   );
//   // }

//   Widget showChart() {
//     cHeight = MediaQuery.of(context).size.height;
//     cWidth = MediaQuery.of(context).size.width;
//     List<List<MarksObtained>> data = List(3);
//     print("index: ${widget.index}");
//     var itemCount = widget.mydata == null
//         ? 0
//         : widget.mydata.data[widget.index].performance.length;
//     data[0] = List.generate(
//       itemCount,
//       (index) {
//         var k = widget.mydata.data[widget.index].performance[index];
//         var colorIndex = 0;
//         // print("i: $i");
//         return MarksObtained(
//           k.subject.toString(),
//           k.marksObtained,
//           color[colorIndex],
//         );
//       },
//     );
//     data[1] = List.generate(
//       itemCount,
//       (index) {
//         var k = widget.mydata.data[widget.index].performance[index];
//         var colorIndex = 1;
//         // print("i: $i");
//         return MarksObtained(
//           k.subject.toString(),
//           k.marksObtained - data2[index % 5],
//           color[colorIndex],
//         );
//       },
//     );
//     // for (int i = 0; i < len; i++) {
//     //   var itemCount =
//     //       widget.mydata == null ? 0 : widget.mydata.data[i].performance.length;
//     //   data[i] = List.generate(
//     //     itemCount,
//     //     (index) {
//     //       var k = widget.mydata.data[i].performance[index];
//     //       var colorIndex = i % color.length;
//     //       // print("i: $i");
//     //       return MarksObtained(
//     //         k.subject.toString(),
//     //         k.marksObtained,
//     //         color[colorIndex],
//     //       );
//     //     },
//     //   );
//     // }
//     var series1 = charts.Series(
//       id: "marksOverall0", // + index.toString(),
//       domainFn: (MarksObtained mark, _) => mark.subject,
//       measureFn: (MarksObtained mark, _) => mark.marks,
//       colorFn: (MarksObtained mark, _) => mark.color,
//       data: data[0],
//     );
//     var series2 = charts.Series(
//       id: "marksOverall1", // + index.toString(),
//       domainFn: (MarksObtained mark, _) => mark.subject,
//       measureFn: (MarksObtained mark, _) => mark.marks,
//       colorFn: (MarksObtained mark, _) => mark.color,
//       data: data[1],
//     );

//     var series = [series1, series2];
//     print("setjs: ${series.runtimeType}");
//     print("data: ${data[0].runtimeType}");

//     var chart = charts.BarChart(
//       series,
//       barGroupingType: charts.BarGroupingType.grouped,
//     );

//     var chartWidget = Padding(
//       padding: EdgeInsets.only(
//         top: cHeight * 0.01,
//         bottom: cHeight * 0.02,
//         left: cWidth * 0.02,
//         right: cWidth * 0.02,
//       ),
//       child: SizedBox(
//         height: cHeight * 0.7,
//         width: cWidth,
//         child: chart,
//       ),
//     );

//     return Card(
//       elevation: 5.0,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(10.0),
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: <Widget>[
//           Padding(
//             padding: EdgeInsets.only(
//               top: cHeight * 0.03,
//               left: cWidth * 0.03,
//               right: cWidth * 0.03,
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: <Widget>[
              
//                 Text(
//                   'Marks Scored',
//                   style: TextStyle(
//                     fontSize: 16.0,
//                     fontWeight: FontWeight.w700,
//                     // color: Colors.purple,
//                   ),
//                 ),
//                 Container(
//                   height: cHeight * 0.03,
//                   width: cWidth * 0.3,
//                   // color: Colors.teal,
//                   alignment: Alignment.topRight,
//                   child: ListView.builder(
//                     scrollDirection: Axis.horizontal,
//                     shrinkWrap: true,
//                     itemCount: 2,
//                     itemBuilder: (context, index) {
//                       return Row(
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         // crossAxisAlignment: CrossAxisAlignment.end,
//                         children: <Widget>[
//                           CircleAvatar(
//                             backgroundColor: color[index % 5],
//                             radius: cHeight * 0.008,
//                           ),
//                           Padding(
//                             padding: EdgeInsets.only(
//                               left: cWidth * 0.015,
//                               right: cWidth * 0.015,
//                             ),
//                             child: Text(
//                               index == 1
//                                   ? "Average"
//                                   : widget.mydata.data[index].id,
//                               style: TextStyle(
//                                   fontSize: 12.0,
//                                   fontWeight: FontWeight.w300,
//                                   color: Colors.purple),
//                             ),
//                           ),
//                         ],
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Divider(),
//           chartWidget,
//         ],
//       ),
//     );
//   }
// }
