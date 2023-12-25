import 'package:flutter/material.dart';

class NotificationsDetails extends StatefulWidget {
  final List value;
  final int currentIndex;
  NotificationsDetails({Key key, this.value, this.currentIndex})
      : super(key: key);
  //NotificationsDetails({Key key, this.currentIndex}) : super(key: key);
  @override
  _NotificationsDetailsState createState() => _NotificationsDetailsState();
}

class _NotificationsDetailsState extends State<NotificationsDetails> {
  double cHieght;
  double cWidth;

  List<String> image = [
    "assets/annualFunction.jpeg",
    "assets/sportsDay1.jpeg",
    "assets/sportsGirlsMatch.jpeg",
    "assets/extraCuricular.jpeg"
  ];
  List<String> detail = [
    "Annual Function",
    "Sports Day",
    "Girls InterSchool Competition",
    "Extra Curicular Activities",
  ];
  List<String> detail2 = [
    "Annual Function took place in the school today. You can check the pics here",
    "Sports is also essential for students to grow so yesterday in our school Sports day took place",
    "Our girs had made us proud by winning the inter school competition held in January 2019",
    "Students develop the skill which can come in handy in near future",
  ];

  @override
  Widget build(BuildContext context) {
    cHieght = MediaQuery.of(context).size.height;
    cWidth = MediaQuery.of(context).size.width;

    if (MediaQuery.of(context).orientation == Orientation.landscape) {
      var c = cHieght;
      cHieght = cWidth;
      cWidth = c;
    }

    return Scaffold(
      appBar: new AppBar(
        title: new Text("Notification Detail"),
      ),
      body: Container(
        padding: EdgeInsets.only(
            left: cWidth * 0.05,
            right: cWidth * 0.05,
            top: cHieght * 0.05,
            bottom: cHieght * 0.05),
        child: new Column(
          // mainAxisAlignment: MainAxisAlignment.,
          children: <Widget>[
            Container(
              color: Colors.green,
              height: cHieght * 0.3,
              width: cWidth,
              child: Image(
                image: AssetImage(image[widget.currentIndex]),
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: cHieght * 0.01,
                  left: cWidth * 0.002,
                  right: cWidth * 0.002),
              child: Align(
                alignment: Alignment.topLeft,
                child: new Text(
                  // widget.value[widget.currentIndex]['notification']['title'],
                  detail[widget.currentIndex],
                  // textAlign: TextAlign.start,
                  style: new TextStyle(
                    fontSize: cHieght * 0.03,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: cHieght * 0.02,
                  left: cWidth * 0.002,
                  right: cWidth * 0.002),
              child: new Text(
                // widget.value[widget.currentIndex]['notification']['description'],
                detail2[widget.currentIndex],
              ),
            )
          ],
        ),
      ),
    );
  }
}
