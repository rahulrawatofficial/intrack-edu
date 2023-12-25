import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:intrack/Functions/error.dart';
import 'package:intrack/Student/blocs/result_bloc.dart';
import 'package:intrack/Student/models/result_model.dart';

class MarksObtained {
  final String subject;
  final int marks;
  final charts.Color color; // = Colors.blue;

  MarksObtained(
    this.subject,
    this.marks,
    Color color,
  ) : this.color = charts.Color(
            r: color.red, g: color.green, b: color.blue, a: color.alpha);
}

double cHeight;
double cWidth;
// List<int> data2 = [
//   30,
//   20,
//   10,
//   15,
//   16,
// ];

var color = [
  Color(0xFF444B54),
  Colors.grey,
  Colors.yellow,
  Colors.blue,
  Colors.green,
];

class OverallPerformance extends StatefulWidget {
  OverallPerformance({
    Key key,
    this.userToken,
    this.studentId,
    this.sectionId,
  }) : super(key: key);
  final String userToken;
  final String studentId;
  final String sectionId;
  _OverallPerformanceState createState() => _OverallPerformanceState();
}

class _OverallPerformanceState extends State<OverallPerformance> {
  // var data;
  @override
  Widget build(BuildContext context) {
    cHeight = MediaQuery.of(context).size.height;
    cWidth = MediaQuery.of(context).size.width;

    if (MediaQuery.of(context).orientation == Orientation.landscape) {
      // swapHeight();
      cHeight = MediaQuery.of(context).size.width;
      cWidth = MediaQuery.of(context).size.height;
    }
    EdgeInsets _pad = EdgeInsets.only(
      top: cHeight * 0.02,
      left: cWidth * 0.01,
      right: cWidth * 0.01,
      bottom: cHeight * 0.02,
    );

    // resultBloc.fetchAllResultOverall(context, widget.userToken);

    //var k = widget.mydata.performance;
    // var itemCount =
    //     widget.mydata == null ? 0 : widget.mydata.performance.length;

    // data = List.generate(itemCount, (index) {
    //   var k = widget.mydata.performance[index];

    //   return new MarksObtained(
    //     k.subject.toString().substring(0, 3),
    //     k.marksObtained,
    //   );
    // });

    resultBloc.fetchAllResult(
      context,
      widget.userToken,
      widget.studentId,
      widget.sectionId,
    );

    return StreamBuilder(
      stream: resultBloc.allResult,
      builder: (context, AsyncSnapshot<ResultModel> snapshot) {
        print(snapshot.connectionState);
        if (snapshot.hasData) {
          if (snapshot.hasError)
            return errorCheck();
          else {
            if (snapshot.data.data.length > 0) {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data.data.length == 0
                    ? 0
                    : snapshot.data.data[0].performance.length + 1,
                itemBuilder: (context, index) {
                  print(index);
                  if (index == 0)
                    return Padding(
                      padding: _pad,
                      child: showChartAverage(snapshot),
                    );
                  else
                    return Padding(
                      padding: _pad,
                      child: showChart(index - 1, snapshot),
                    );
                },
              );
            } else {
              return Center(
                child: Text("No Data Found"),
              );
            }
          }
        } else
          return Center(
            child: CircularProgressIndicator(),
          );
      },
    );
  }

  Widget showChartAverage(AsyncSnapshot<ResultModel> snapshot) {
    cHeight = MediaQuery.of(context).size.height;
    cWidth = MediaQuery.of(context).size.width;
    List<List<MarksObtained>> data = List(3);
    // print("index: ${widget.index}");
    var itemCount = snapshot.data == null ? 0 : snapshot.data.data.length;
    data[0] = List.generate(
      itemCount,
      (index) {
        var k = snapshot.data.data[index];
        var colorIndex = 0;
        // print("i: $i");
        return MarksObtained(
          k.id.toString(),
          k.percentage.toInt(),
          // 42,
          color[colorIndex],
        );
      },
    );
    data[1] = List.generate(
      itemCount,
      (index) {
        var k = snapshot.data.data[index];
        var colorIndex = 1;
        return MarksObtained(
          k.id.toString(),
          k.totalPercentage.toInt(),
          // 32,
          color[colorIndex],
        );
      },
    );
    var series1 = charts.Series(
      id: "marksOverall0", // + index.toString(),
      domainFn: (MarksObtained mark, _) => mark.subject,
      measureFn: (MarksObtained mark, _) => mark.marks,
      colorFn: (MarksObtained mark, _) => mark.color,
      data: data[0],
    );
    var series2 = charts.Series(
      id: "marksOverall1", // + index.toString(),
      domainFn: (MarksObtained mark, _) => mark.subject,
      measureFn: (MarksObtained mark, _) => mark.marks,
      colorFn: (MarksObtained mark, _) => mark.color,
      data: data[1],
    );

    var series = [series1, series2];

    var chart = charts.BarChart(
      series,
      barGroupingType: charts.BarGroupingType.grouped,
    );

    var chartWidget = Padding(
      padding: EdgeInsets.only(
        top: cHeight * 0.01,
        bottom: cHeight * 0.02,
        left: cWidth * 0.02,
        right: cWidth * 0.02,
      ),
      child: SizedBox(
        height: cHeight * 0.5,
        width: cWidth,
        child: chart,
      ),
    );

    return Card(
      // elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
              top: cHeight * 0.03,
              left: cWidth * 0.02,
              right: cWidth * 0.03,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Vs class average',
                  style: TextStyle(
                    fontSize: cHeight * 0.017,
                    fontWeight: FontWeight.w700,
                    // color: Colors.purple,
                  ),
                ),
                Container(
                  height: cHeight * 0.03,
                  width: cWidth * 0.6,
                  // color: Colors.teal,
                  alignment: Alignment.topRight,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: 2,
                    itemBuilder: (context, index) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          CircleAvatar(
                            backgroundColor: color[index % 5],
                            radius: cHeight * 0.008,
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              left: cWidth * 0.015,
                              right: cWidth * 0.015,
                            ),
                          ),
                          Text(
                            index == 0 ? "Student   " : "Average ",
                            style: TextStyle(fontSize: cHeight * 0.015),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Divider(),
          chartWidget,
        ],
      ),
    );
  }

  Widget showChart(int index1, AsyncSnapshot<ResultModel> snapshot) {
    var itemCount = snapshot.data == null ? 0 : snapshot.data.data.length;
    var subject = snapshot.data.data[0].performance[index1].subject ?? "";
    print(subject);
    var data = List.generate(itemCount, (index) {
      var k = snapshot.data.data[index].performance[index1];

      return new MarksObtained(
        snapshot.data.data[index].id.toString(),
        k.marksObtained,
        color[0],
      );
    });

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
              left: cWidth * 0.02,
              right: cWidth * 0.02,
            ),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new Text(
                  subject,
                  style: new TextStyle(
                    fontSize: cHeight * 0.017,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF444B54),
                  ),
                ),
                // Row(
                //   children: <Widget>[
                //     new CircleAvatar(
                //       backgroundColor: Colors.blue,
                //       radius: cHeight * 0.008,
                //     ),
                //     Padding(
                //       padding: EdgeInsets.only(left: cWidth * 0.015),
                //       child: new Text(
                //         'Marks',
                //         style: new TextStyle(
                //             fontSize: 12.0,
                //             fontWeight: FontWeight.w300,
                //             color: Colors.purple),
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
