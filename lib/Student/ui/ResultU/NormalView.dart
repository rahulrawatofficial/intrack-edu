import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:intrack/Functions/error_handling.dart';
import 'package:intrack/Functions/login_logout/logout.dart';
import 'package:intrack/Student/models/result_model.dart';
import 'package:intrack/Student/ui/ResultU/averageComparision.dart';
import 'package:http/http.dart' as http;

class ClicksPerYear {
  final String year;
  final int clicks;
  final charts.Color color;

  ClicksPerYear(this.year, this.clicks, Color color)
      : this.color = new charts.Color(
            r: color.red, g: color.green, b: color.blue, a: color.alpha);
}

class Insights extends StatefulWidget {
  // ViewInsights({Key key, this.title, this.data}) : super(key: key);
  Insights({
    Key key,
    this.title,
    this.mydata,
    this.data,
    this.index,
    this.userToken,
    this.studentId,
    this.sectionId,
  }) : super(key: key);
  final String title;
  final mydata;
  final ResultModel data;
  final index;
  final String userToken;
  final String studentId;
  final String sectionId;

  _InsightsState createState() => _InsightsState();
}

class _InsightsState extends State<Insights> {
  double cHeight;
  double cWidth;

  var rankData;

  @override
  void initState() {
    getRank().then((val) {
      print("#######$val########");
      print("#######${widget.data.data[0].id}########");
      setState(() {
        rankData = val['data'];
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    cHeight = MediaQuery.of(context).size.height;
    cWidth = MediaQuery.of(context).size.width;

    if (MediaQuery.of(context).orientation == Orientation.landscape) {
      var r = cHeight;
      cHeight = cWidth;
      cWidth = r;
    }
    EdgeInsets _pad = EdgeInsets.only(
      top: cHeight * 0.04,
      left: cWidth * 0.01,
      right: cWidth * 0.01,
      bottom: cHeight * 0.04,
    );

    // chart
    // var k = widget.mydata.performance;
    var itemCount =
        widget.mydata == null ? 0 : widget.mydata.performance.length;

    var data = List.generate(itemCount, (index) {
      var k = widget.mydata.performance[index];

      return new ClicksPerYear(
        k.subject.toString().substring(0, 3),
        k.marksObtained,
        Colors.green[700],
      );
    });

    // [
    //   new ClicksPerYear(widget.mydata, 92, Colors.blue),
    //   new ClicksPerYear('Math', 42, Colors.blue),
    //   new ClicksPerYear('Sci', 56, Colors.blue),
    //   new ClicksPerYear('S.Sc', 80, Colors.blue),
    //   new ClicksPerYear('Comp', 45, Colors.blue),
    //   new ClicksPerYear('M.Sc.', 63, Colors.blue),
    // ];

    var series = [
      new charts.Series(
        id: 'Clicks',
        domainFn: (ClicksPerYear clickData, _) => clickData.year,
        measureFn: (ClicksPerYear clickData, _) => clickData.clicks,
        colorFn: (ClicksPerYear clickData, _) => clickData.color,
        data: data,
        labelAccessorFn: (ClicksPerYear mark, _) =>
            '${mark.year} : ${mark.clicks.toString()}',
      ),
    ];
    var chart = new charts.BarChart(
      series,
      animate: true,
      barRendererDecorator: charts.BarLabelDecorator<String>(),
      vertical: false,
      // domainAxis: charts.OrdinalAxisSpec(renderSpec: charts.NoneRenderSpec()),
    );
    var chartWidget = new Padding(
      padding: EdgeInsets.only(
        top: cHeight * 0.01,
        bottom: cHeight * 0.02,
        left: cWidth * 0.01,
        right: cWidth * 0.01,
      ),
      child: new SizedBox(
        height: cHeight * 0.5,
        width: cWidth,
        child: chart,
      ),
    );

    return Container(
      padding: _pad,
      child: rankData != null
          ? Card(
              // elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: cHeight * 0.02,
                      horizontal: cWidth * 0.05,
                    ),
                    child: new Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Expanded(
                          child: new Text(
                            'Marks',
                            style: new TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF444B54),
                            ),
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            new Text(
                              'Rank ',
                              style: new TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                                color: Colors.deepOrange,
                              ),
                            ),
                            new Text(
                              rankData["rank"].toString(),
                              style: new TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Colors.deepOrange,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  new Divider(
                    height: 12.0,
                    indent: 10.0,
                  ),
                  Container(
                    // height: cHeight * 0.4,
                    // width: cWidth * 0.8,
                    padding: EdgeInsets.symmetric(
                      horizontal: cWidth * 0.05,
                      vertical: cHeight * 0.03,
                    ),
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                            // horizontal: cWidth*0.01,
                            bottom: cHeight * 0.01,
                          ),
                          child: subjectFormat("Subject", "Marks", "Grade"),
                        ),
                        ListView.builder(
                          physics: ClampingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: widget.mydata == null
                              ? 0
                              : widget.mydata.performance.length,
                          itemBuilder: (context, index) {
                            var k = widget.mydata.performance[index];
                            String grade = k.grade.toString();
                            var j = k.grade.toString().length;
                            if (j == 1) grade = grade + "  ";
                            return subjectMarks(
                              k.subject.toString(),
                              k.marksObtained.toString(),
                              k.maximumMarks.toString(),
                              grade,
                            );
                          },
                        ),
                        // subjectMarks("Mathematics", "44", "B+"),
                        // subjectMarks("Hindi", "49", "A "),
                        // subjectMarks("Science", "40", "C+"),
                        // subjectMarks("Computer", "34", "D "),
                        // subjectMarks("Social Science", "47", "A "),
                        // subjectMarks("G.K", "48", "A "),
                        // subjectMarks("Moral Science", "39", "C "),
                      ],
                    ),
                  ),
                ],
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  Widget subjectFormat(String subject, String marks, String grade) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        new Text(
          subject,
          style: new TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        new Text(
          marks,
          style: new TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        new Text(
          grade,
          style: new TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget subjectMarks(
      String subjectName, String marks, String maxMarks, String grade) {
    cHeight = MediaQuery.of(context).size.width;
    cWidth = MediaQuery.of(context).size.height;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: new Text(
            subjectName,
            style: new TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        Expanded(
          child: new Text(
            marks + "/" + maxMarks,
            style: new TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        new Text(
          grade,
          style: new TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Future<dynamic> getRank() async {
    Map<String, dynamic> params = {
      "sectionId": widget.sectionId,
      "studentId": widget.studentId,
      "examType": widget.data.data[0].id,
    };
    var url = Uri(
      scheme: "https",
      host: "api-dashboard.intrack.in",
      // port: 8001,
      path: "/v1/checkStudentRank",
      queryParameters: params,
    );
    print(url);
    var response = await http.get(
      url,
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        "authorization": "Bearer " + widget.userToken
      },
    );

    print(response.statusCode);
    // print(response.body);

    var data;
    var status;
    var message;
    if (response.statusCode == 401) {
      logOut();
      return ShowError().tokenExpired(context, "Error", "Session Expired",
          "Login", widget.userToken, "STUDENT");
    }
    if (response.statusCode != 200) {
      status = "Failed";
      message = "Failed to Fetch the list";

      showDialogSingleButton(
        context,
        status,
        message,
        "ok",
      );
    } else
      data = json.decode(response.body);
    return data;
  }
}
