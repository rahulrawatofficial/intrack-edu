import 'package:flutter/material.dart';

class EventsDetails extends StatefulWidget {
  EventsDetails({Key key, this.index}) : super(key: key);
  final int index;
  @override
  _EventsDetailsState createState() => _EventsDetailsState();
}

class _EventsDetailsState extends State<EventsDetails> {
  double cHieght;
  double cWidth;

  List<String> image = [
    "assets/schoolPlay.jpeg",
    "assets/CollabrativePainting.jpeg",
    "assets/primaryStudentSports.jpeg",
    "assets/extraCuricular.jpeg",
    "assets/sportsDay1.jpeg",
    "assets/sportsGirlsMatch.jpeg",
    "assets/annualFunction.jpeg",
  ];
  List<String> detail = [
    "School Play",
    "Collabrative Painting",
    "Sports Day",
    "Girls InterSchool Competition",
    "Annual Function",
  ];

  List<String> detail2 = [
    "School play took place in the school today so you Want to see the pics related to it",
    "Students have participated to make a humangous painting in record time",
    "Students of different house take part in the school intra school football competition in which Diamond House won",
    "Students develop the skill which can come in handy in near future",
    "Sports is also essential for students to grow so yesterday in our school Sports day took place",
    "Our girs had made us proud by winning the inter school competition held in January 2019",
    "Annual Function took place in the school today. You can check the pics here",
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
    EdgeInsetsGeometry _pad;

    _pad = EdgeInsets.only(
        top: cHieght * 0.01,
        bottom: cHieght * 0.01,
        left: cWidth * 0.02,
        right: cWidth * 0.02);

    return Scaffold(
      appBar: new AppBar(
        title: new Text("Event Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: <Widget>[
            new Card(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: _pad,
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: new Text(
                        detail[widget.index],
                        style: new TextStyle(
                            fontSize: cWidth * 0.06,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Padding(
                    padding: _pad,
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        new Row(
                          children: <Widget>[
                            Icon(Icons.calendar_today),
                            Text("29.01.2019"),
                          ],
                        ),
                        new Row(
                          children: <Widget>[
                            Icon(Icons.timer),
                            Text("4:00 pm to 6:00 pm"),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: _pad,
                    child: new Container(
                      color: Colors.tealAccent,
                      height: cHieght * 0.3,
                      width: cWidth * 0.98,
                      child: Image(
                        image: AssetImage(image[widget.index]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: _pad,
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: new Text(
                        detail2[widget.index],
                      ),
                    ),
                  ),
                  Padding(
                    padding: _pad,
                    child: new Row(
                      children: <Widget>[
                        Icon(Icons.location_on),
                        new Text("In School campus")
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
