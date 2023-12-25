import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:intrack/Student/ui/ResultU/averageComparision.dart';

class MarksObtained {
  final String subject;
  final int marks;
  final charts.Color color;

  MarksObtained(this.subject, this.marks, Color color)
      : this.color = new charts.Color(
            r: color.red, g: color.green, b: color.blue, a: color.alpha);
}

double cHeight;
double cWidth;
var totalMarks = "100";

class Insights2 extends StatefulWidget {
  Insights2({
    Key key,
    this.title,
    this.mydata,
    this.data,
    this.index,
  }) : super(key: key);
  final String title;
  final mydata;
  final data;
  final index;
  _Insights2State createState() => _Insights2State();
}

class _Insights2State extends State<Insights2> {
  var data;
  @override
  Widget build(BuildContext context) {
    print("###${widget.mydata}***");
    print("***${widget.data}***");
    cHeight = MediaQuery.of(context).size.height;
    cWidth = MediaQuery.of(context).size.width;

    if (MediaQuery.of(context).orientation == Orientation.landscape) {
      // swapHeight();
      cHeight = MediaQuery.of(context).size.width;
      cWidth = MediaQuery.of(context).size.height;
      print("LandScape => cHeight $cHeight,\ncWidth: $cWidth");
    }
    EdgeInsets _pad = EdgeInsets.only(
      top: cHeight * 0.04,
      left: cWidth * 0.04,
      right: cWidth * 0.04,
      bottom: cHeight * 0.04,
    );

    //var k = widget.mydata.performance;
    var itemCount =
        widget.mydata == null ? 0 : widget.mydata.performance.length;

    data = List.generate(itemCount, (index) {
      var k = widget.mydata.performance[index];
      totalMarks = k.maximumMarks.toString();

      return new MarksObtained(
        k.subject.toString().substring(0, 3),
        k.marksObtained,
        Color(0xFF444B54),
      );
    });

    return Container(
      padding: _pad,
      // height: cHeight,
      // width: cWidth,
      decoration: BoxDecoration(
        color: Colors.white70,
      ),
      child: showChart(),
    );
  }

  // Widget showData(int index) {
  //   cHeight = MediaQuery.of(context).size.height;
  //   cWidth = MediaQuery.of(context).size.width;

  //   return Padding(
  //     padding: EdgeInsets.only(
  //       top: cHeight * 0.05,
  //     ),
  //     child: new Card(
  //       elevation: 5.0,
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(10.0),
  //       ),
  //       child: Padding(
  //         padding: EdgeInsets.only(
  //           top: cHeight * 0.02,
  //           bottom: cHeight * 0.02,
  //           left: cWidth * 0.001,
  //           right: cWidth * 0.001,
  //         ),
  //         child: new ListTile(
  //           title: new Text("data"),
  //           leading: new CircleAvatar(
  //             radius: cHeight * 0.05,
  //             backgroundColor: Colors.blue,
  //             child: new Text("$index"),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget showChart() {
    cHeight = MediaQuery.of(context).size.height;
    cWidth = MediaQuery.of(context).size.width;

    // var data = [
    //   new MarksObtained("Eng", 46),
    //   new MarksObtained("Math", 45),
    //   new MarksObtained("Comp", 45),
    //   // new MarksObtained("Sci", 89),
    //   new MarksObtained("S.Sc.", 29),
    //   new MarksObtained("M.Sc.", 73),
    //   // new MarksObtained("Hindi", 92),
    // ];

    var series = [
      charts.Series(
        id: "marksOverall",
        domainFn: (MarksObtained mark, _) => mark.subject,
        measureFn: (MarksObtained mark, _) => mark.marks,
        colorFn: (MarksObtained mark, _) => mark.color,
        data: data,
      ),
    ];

    var chart = charts.BarChart(
      series,
      animate: true,
    );

    var chartWidget = new Padding(
      padding: EdgeInsets.only(
        top: cHeight * 0.01,
        bottom: cHeight * 0.02,
        left: cWidth * 0.02,
        right: cWidth * 0.02,
      ),
      child: new SizedBox(
        height: cHeight * 0.5,
        width: cWidth,
        child: chart,
      ),
    );

    return new Card(
      // elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
              top: cHeight * 0.02,
              left: cWidth * 0.04,
              right: cWidth * 0.04,
            ),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new Text(
                  'Marks Scored',
                  style: new TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF444B54),
                  ),
                ),
                Row(
                  children: <Widget>[
                    new Text(
                      'Marks out of',
                      style: new TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w300,
                        color: Color(0xFF444B54),
                      ),
                    ),
                    new Text(
                      "  " +
                          widget.mydata.performance[0].maximumMarks.toString(),
                      style: new TextStyle(
                        fontSize: cHeight * 0.02,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF444B54),
                      ),
                    ),
                  ],
                ),
                // Row(
                //   children: <Widget>[
                //     new CircleAvatar(
                //       backgroundColor: Colors.pinkAccent,
                //       radius: cHeight * 0.008,
                //     ),
                //     Padding(
                //       padding: EdgeInsets.only(left: cWidth * 0.015),
                //       child: new Text(
                //         totalMarks,
                //         // widget.mydata.performance[0]["maximumMarks"],
                //         style: new TextStyle(
                //           fontSize: 12.0,
                //           fontWeight: FontWeight.w300,
                //           color: Colors.pink,
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
          Divider(),
          Container(
            child: chartWidget,
          ),
        ],
      ),
    );
  }
}
