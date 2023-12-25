import 'package:intrack/Student/ui/Events/eventsdetails.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class Events extends StatefulWidget {
  final String userToken;
  Events({Key key, this.userToken}) : super(key: key);
  @override
  _EventsState createState() => _EventsState();
}

class _EventsState extends State<Events> {
  double cHieght;
  double cWidth;
  final String url = "https://api-dashboard.intrack.in/v1/getEventsList";
  List data;

  @override
  void initState() {
    super.initState();
    this.getJsonData();
  }

  Future<String> getJsonData() async {
    var response = await http.get(
        //Encode The Url
        Uri.encodeFull(url),
        //only accept Json Response
        headers: {
          "authorization":
              "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjVjNGZmYmRmNzBiODY5MzExMmU1OWRjNiIsImVtYWlsIjoic2Nob29sQHNjaG9vbC5jb20iLCJuYW1lIjoiU2Nob29sIiwicm9sZSI6IkFETUlOIiwiaWF0IjoxNTQ4NzQ1Njk1LCJleHAiOjE1NDg4MzIwOTV9.sJ8x2Wmni4Hl3rtd36OwiYt9WYHc7w0ojc3ITBNCgLQ"
        });

    print(response.body);

    setState(() {
      var converDataToJson = json.decode(response.body);
      data = converDataToJson['data'];
    });
    return "success";
  }

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

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: new ListView.builder(
          itemCount: 3,
          // data == null ? 0 : data.length,
          itemBuilder: (BuildContext context, int index) {
            // var dateCreated = data[index]['created'];
            // String s = "";
            // for (int i = 0; i <= 9; i++) {
            //   s = s + dateCreated[i];
            // }
            return GestureDetector(
              child: new Card(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(cWidth * 0.05, cHieght * 0.02,
                      cWidth * 0.02, cHieght * 0.02),
                  child: new Column(
                    children: <Widget>[
                      Align(
                          child: new Text(
                            // data[index]['name'],
                            detail[index],
                            style: new TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: cWidth * 0.045),
                          ),
                          alignment: Alignment.topLeft),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      EventsDetails(index: index)));
                        },
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(cWidth * 0.005,
                              cHieght * 0.01, cWidth * 0.005, cHieght * 0.01),
                          child: new Container(
                            color: Colors.teal,
                            height: cHieght * 0.2,
                            width: cWidth * 0.95,
                            child: Image(
                              image: AssetImage(image[index]),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      new Text(
                        detail2[index],
                        style: new TextStyle(fontSize: cWidth * 0.04),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: cHieght * 0.01),
                        child: Align(
                            child: new Text(
                              "Upsprit",
                              style: new TextStyle(
                                  fontSize: cWidth * 0.04, color: Colors.grey),
                            ),
                            alignment: Alignment.bottomLeft),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
