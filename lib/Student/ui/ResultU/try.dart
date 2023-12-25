import 'package:flutter/material.dart';
import 'package:intrack/Student/blocs/result_bloc.dart';
import 'package:intrack/Student/models/result_model.dart';
import 'package:intrack/Student/ui/ResultU/viewInsights.dart';

class Result extends StatefulWidget {
  final String userToken;
  final String studentId;
  final String sectionId;
  Result({Key key, this.userToken, this.studentId, this.sectionId})
      : super(key: key);
  _ResultState createState() => _ResultState();
}

class _ResultState extends State<Result> {
  double cHeight;
  double cWidth;
  // _launchButton(int index) {}

  _launchInsights(int index, AsyncSnapshot<ResultModel> snapshot) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ViewInsights(
          title: snapshot.data.data[index].id,
          data: snapshot.data,
          index: index,
        ),
      ),
    );
  }

  var refreshKey = GlobalKey<RefreshIndicatorState>();

  Future<void> refereshList() async {
    await Future.delayed(Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    cHeight = MediaQuery.of(context).size.width;
    cWidth = MediaQuery.of(context).size.height;

    resultBloc.fetchAllResult(
      context,
      widget.userToken,
      widget.studentId,
      widget.sectionId,
    );

    return Scaffold(
      appBar: new AppBar(
        elevation: 1.0,
        title: new Text(
          'Performance',
          style: new TextStyle(
            fontSize: 16.0,
          ),
        ),
      ),
      resizeToAvoidBottomPadding: false,
      body: Container(
        padding: EdgeInsets.only(
          top: cHeight * 0.04,
          // left: cWidth * 0.04,
          // right: cWidth * 0.04,
          bottom: cHeight * 0.04,
        ),
        child: new StreamBuilder(
          stream: resultBloc.allResult,
          builder: (context, AsyncSnapshot<ResultModel> snapshot) {
            print(snapshot.connectionState);
            print(snapshot.data);
            if (snapshot.hasData) {
              return ListView.builder(
                shrinkWrap: true,
                itemCount:
                    snapshot.data.data == null ? 0 : snapshot.data.data.length,
                itemBuilder: (context, index) {
                  return inputDisplay(index, snapshot);
                },
              );
            } else
              return Center(
                child: CircularProgressIndicator(),
              );
          },
        ),
      ),
    );
  }

  Widget inputDisplay(int index, AsyncSnapshot<ResultModel> snapshot) {
    return Padding(
      padding: EdgeInsets.symmetric(
        // horizontal: cWidth * 0.04,
        vertical: cHeight * 0.005,
      ),
      child: Column(
        children: <Widget>[
          InkWell(
            onTap: () => _launchInsights(index, snapshot),
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Expanded(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Color(0xFFfffc6d7),
                      radius: cWidth * 0.05,
                      child: new Text(
                        snapshot.data.data[index].id.toString(),
                        style: new TextStyle(
                          fontSize: 20, //cHeight * 0.02,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    title: Row(
                      children: <Widget>[
                        new Text(
                          'Percentage: ',
                          style: new TextStyle(
                            fontSize: 18, // cHeight * 0.02,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        new Text(
                          "82%",
                          // snapshot
                          //     .data.data[index].performance[0].maximumMarks
                          //     .toString(),
                          style: new TextStyle(
                            fontSize: 18, //cHeight * 0.02,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    subtitle: Row(
                      children: <Widget>[
                        new Text(
                          'Rank: ',
                          style: new TextStyle(
                            fontSize: 18, //cHeight * 0.02,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        new Text(
                          "2",
                          // snapshot
                          //     .data.data[index].performance[0].maximumMarks
                          //     .toString(),
                          style: new TextStyle(
                            fontSize: 18, //cHeight * 0.02,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(18),
                  child: Icon(
                    Icons.arrow_forward_ios,
                  ),
                  // child: Column(
                  //   children: <Widget>[
                  //     Text(
                  //       "10,000",
                  //       style: TextStyle(
                  //         fontSize: 18,
                  //       ),
                  //     ),
                  //     Padding(
                  //       padding: EdgeInsets.all(3),
                  //     ),
                  //     Text(
                  //       "@ 10,000",
                  //       style: TextStyle(
                  //         fontSize: 13,
                  //       ),
                  //     ),
                  //   ],
                  // ),
                ),
              ],
            ),
          ),
          Divider(),
        ],
      ),
    );
    //   return InkWell(
    //     onTap: () => _launchInsights(index, snapshot),
    //     child: new Row(
    //       mainAxisSize: MainAxisSize.min,
    //       // mainAxisAlignment: MainAxisAlignment.spaceAround,
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: <Widget>[
    //         Padding(
    //           padding: EdgeInsets.only(
    //             left: cWidth * 0.03,
    //           ),
    //         ),
    //         ListTile(
    //           leading: CircleAvatar(
    //             backgroundColor: Color(0xFFfffc6d7),
    //             radius: cWidth * 0.1,
    //             child: new Text(
    //               snapshot.data.data[index].id.toString(),
    //               style: new TextStyle(
    //                 fontSize: 20, //cHeight * 0.02,
    //                 fontWeight: FontWeight.w600,
    //               ),
    //             ),
    //           ),
    //           title: Row(
    //             children: <Widget>[
    //               new Text(
    //                 'Percentage',
    //                 style: new TextStyle(
    //                   fontSize: 18, // cHeight * 0.02,
    //                   fontWeight: FontWeight.w300,
    //                 ),
    //               ),
    //               new Text(
    //                 "  " +
    //                     snapshot.data.data[index].performance[0].maximumMarks
    //                         .toString(),
    //                 style: new TextStyle(
    //                   fontSize: 18, //cHeight * 0.02,
    //                   fontWeight: FontWeight.w400,
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    //         // CircleAvatar(
    //         //   backgroundColor: Color(0xFFfffc6d7),
    //         //   radius: cWidth * 0.1,
    //         //   child: new Text(
    //         //     snapshot.data.data[index].id.toString(),
    //         //     style: new TextStyle(
    //         //       fontSize: 20, //cHeight * 0.02,
    //         //       fontWeight: FontWeight.w600,
    //         //     ),
    //         //   ),
    //         // ),
    //         // Padding(
    //         //   padding: EdgeInsets.only(
    //         //     top: cHeight * 0.015,
    //         //     left: cWidth * 0.02,
    //         //   ),
    //         //   child: Column(
    //         //     children: <Widget>[
    //         //       Row(
    //         //         children: <Widget>[
    //         //           new Text(
    //         //             'Percentage',
    //         //             style: new TextStyle(
    //         //               fontSize: 18, // cHeight * 0.02,
    //         //               fontWeight: FontWeight.w300,
    //         //             ),
    //         //           ),
    //         //           new Text(
    //         //             "  " +
    //         //                 snapshot
    //         //                     .data.data[index].performance[0].maximumMarks
    //         //                     .toString(),
    //         //             style: new TextStyle(
    //         //               fontSize: 18, //cHeight * 0.02,
    //         //               fontWeight: FontWeight.w400,
    //         //             ),
    //         //           ),
    //         //         ],
    //         //       ),
    //         //       Row(
    //         //         children: <Widget>[
    //         //           new Text(
    //         //             'Rank',
    //         //             style: new TextStyle(
    //         //               fontSize: 18, //cHeight * 0.02,
    //         //               fontWeight: FontWeight.w300,
    //         //             ),
    //         //           ),
    //         //           new Text(
    //         //             "  " +
    //         //                 snapshot
    //         //                     .data.data[index].performance[0].maximumMarks
    //         //                     .toString(),
    //         //             style: new TextStyle(
    //         //               fontSize: 18, //cHeight * 0.02,
    //         //               fontWeight: FontWeight.w400,
    //         //             ),
    //         //           ),
    //         //         ],
    //         //       ),
    //         //     ],
    //         //   ),
    //         //   // child:
    //         // ),
    //       ],
    //     ),
    //   );
  }
}
