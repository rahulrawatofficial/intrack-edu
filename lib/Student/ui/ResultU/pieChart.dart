import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:intrack/Functions/error.dart';
import 'package:intrack/Student/blocs/resultOverall_bloc.dart';
import 'package:intrack/Student/models/resultOverall_model.dart';

class PieChartPage extends StatefulWidget {
  PieChartPage({
    Key key,
    this.percentage,
    this.userToken,
    this.studentId,
    this.sectionId,
  }) : super(key: key);
  final double percentage;
  final String userToken;
  final String studentId;
  final String sectionId;
  _PieChartPageState createState() => _PieChartPageState();
}

class MarksObtained {
  final String type;
  final int marks;
  final Color color;

  MarksObtained(this.type, this.marks, Color color)
      : this.color = Color(r: color.r, g: color.g, b: color.b, a: color.a);
}

List<Color> color = [
  Color(a: 102, b: 205, g: 89, r: 708),
  Color(a: 102, b: 0, g: 140, r: 255),
  Color(a: 102, b: 255, g: 80, r: 8),
  Color(a: 102, b: 405, g: 190, r: 308),
  Color(a: 102, b: 255, g: 80, r: 78),
  Color(a: 102, b: 4, g: 8900, r: 78),
  Color(a: 102, b: 505, g: 19, r: 308),
  Color(a: 102, b: 50, g: 50, r: 255),
];

List<String> types = [
  "Excellent", // 90-100 E
  "Good", // 80-90G
  "Satisfactory", // 70-80S
  "Above average", // 60-70AA
  "Average", // 50-60A
  "Below average", // 40-50BA
  "Unsatisfactory", // 33 - 40U
  "Poor", // 0- 33P
];
List<String> label = [
  "E",
  "G",
  "S",
  "AA",
  "A",
  "BA",
  "U",
  "P",
];
var performance;

class _PieChartPageState extends State<PieChartPage> {
  @override
  void initState() {
    performance = checkPerform(widget.percentage);
    // TODO: implement initState
    super.initState();
  }

  var color1 = [
    Colors.pink[100],
    Colors.yellow[800],
    Colors.blue[300],

    Colors.teal[300],
    Colors.brown[400],

    Colors.green[200],
    Colors.purple[300],
    Colors.red[300],
    // Color.fromARGB(a, r, g, b),
    // Color(a: 102, b: 205, g: 89, r: 708),
    // Color(a: 102, b: 0, g: 140, r: 255),
    // Color(a: 102, b: 45, g: 890, r: 708),
    // Color(a: 102, b: 405, g: 190, r: 308),
    // Color(a: 102, b: 42, g: 80, r: 78),
    // Color(a: 102, b: 4, g: 8900, r: 78),
    // Color(a: 102, b: 505, g: 19, r: 308),
  ];
  @override
  Widget build(BuildContext context) {
    double cHeight = MediaQuery.of(context).size.height;
    double cWidth = MediaQuery.of(context).size.width;

    resultBloc.fetchAllResult(
      context,
      widget.userToken,
      widget.studentId,
      widget.sectionId,
    );

// unsatisfactory
// Below average
// Average
// above average
// satisfactory
// Good
// Excellent
    return Container(
      // padding: _pad,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    backgroundColor: Colors.orange[400],
                    child: Icon(
                      Icons.check,
                      color: Colors.white,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      right: 15,
                    ),
                  ),
                  Expanded(
                    child: RichText(
                      maxLines: null,
                      text: TextSpan(
                        text: "Your ward performance is: ",
                        style: DefaultTextStyle.of(context).style.apply(
                              fontSizeFactor: 1.2,
                            ),
                        children: <TextSpan>[
                          TextSpan(
                            text: performance,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                              color: Colors.orange[400],
                            ),
                          ),
                          // TextSpan(text: ' world!'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          StreamBuilder(
            stream: resultBloc.allResult,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.hasError)
                  return errorCheck();
                else
                  return Card(
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.start,
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                            top: cHeight * 0.02,
                            // left: cWidth * 0.05,
                          ),
                          child: new Text(
                            'Class Performance',
                            style: new TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w700,
                              color: Colors.orange[400],
                            ),
                          ),
                        ),
                        showChart(snapshot),
                        typeList(),
                      ],
                    ),
                  );
              } else
                return Center(
                  child: CircularProgressIndicator(),
                );
            },
          ),
        ],
      ),
    );
  }

  Widget showChart(AsyncSnapshot<ResultOverallModel> snapshot) {
    var typeList = [
      //  excellent,
      //  good,
      //  satisfactory,
      //  aboveAverage,
      //  average,
      //  belowAverage,
      //  unsatisfactory,
      //  poor,
    ];
    print("klkl");
    print(snapshot.data.data.excellent.runtimeType);

    var data = List.generate(8, (index) {
      return new MarksObtained(
        types[index],
        // snapshot.data.data.excellent,
        14,
        color[index],
      );
    });
    // var data = [
    //   new MarksObtained(
    //     types[0],
    //     10,
    //     color[0],
    //   ),
    //   new MarksObtained(
    //     types[1],
    //     5,
    //     color[1],
    //   ),
    //   new MarksObtained(
    //     types[2],
    //     25,
    //     color[2],
    //   ),
    //   new MarksObtained(
    //     types[3],
    //     15,
    //     color[3],
    //   ),
    //   new MarksObtained(
    //     types[4],
    //     10,
    //     color[4],
    //   ),
    //   new MarksObtained(
    //     types[5],
    //     10,
    //     color[5],
    //   ),
    //   new MarksObtained(
    //     types[6],
    //     15,
    //     color[6],
    //   ),
    //   new MarksObtained(
    //     types[7],
    //     10,
    //     color[7],
    //   ),
    // ];

    var series = [
      Series(
        id: "mark",
        domainFn: (MarksObtained mark, _) => mark.type,
        measureFn: (MarksObtained mark, _) => mark.marks,
        colorFn: (MarksObtained mark, _) => mark.color,
        // displayName: "marks",
        data: data,
        labelAccessorFn: (MarksObtained mark, index) =>
            '${label[index]}: ${mark.marks}%',
      ),
    ];

    var chart = PieChart(
      series,
      animate: true,
      // defaultInteractions: false,
      defaultRenderer: new ArcRendererConfig(
        arcRendererDecorators: [
          new ArcLabelDecorator(
            labelPosition: ArcLabelPosition.auto,
          )
        ],
      ),
    );

    var chartWidget = new Padding(
      padding: EdgeInsets.only(
        // top: cHeight * 0.01,
        // bottom: cHeight * 0.02,
        left: cWidth * 0.002,
        right: cWidth * 0.002,
      ),
      child: new SizedBox(
        height: cHeight * 0.45,
        width: cWidth * 0.98,
        child: chart,
      ),
    );

    if (MediaQuery.of(context).orientation == Orientation.landscape) {
      var r = cHeight;
      cHeight = cWidth;
      cWidth = r;
    }
    // EdgeInsets _pad = EdgeInsets.only(
    //   top: cHeight * 0.04,
    //   left: cWidth * 0.04,
    //   right: cWidth * 0.04,
    //   bottom: cHeight * 0.04,
    // );
    return chartWidget;
  }

  Widget typeList() {
    return Container(
      // color: Colors.yellow,
      child: ListView.builder(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        itemCount: 8,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(
                  "${index + 1}. ",
                  style: TextStyle(
                    fontSize: cHeight * 0.03,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 15,
                    ),
                    child: new Text(
                      "${types[index]} (${label[index]})",
                      style: new TextStyle(
                        fontSize: cHeight * 0.03,
                        fontWeight: FontWeight.w300,
                        // color: Colors.purple,
                      ),
                    ),
                  ),
                ),
                Container(
                  color: color1[index],
                  height: 20,
                  width: 120,
                ),
                // new CircleAvatar(
                //   backgroundColor: color1[index],
                //   radius: 8,
                // ),
              ],
            ),
          );
        },
      ),
    );
  }
}

String checkPerform(double number) {
  if (number > 90.0)
    return types[0];
  else if (number > 80.0)
    return types[1];
  else if (number > 70.0)
    return types[2];
  else if (number > 60.0)
    return types[3];
  else if (number > 50.0)
    return types[4];
  else if (number > 40.0)
    return types[5];
  else if (number > 33.0) return types[6];
  return types[7];
}
