import 'package:intrack/Teacher/ui/TeacherDiary/studentComments.dart';
import 'package:intrack/Teacher/ui/TeacherDiary/teacherComments.dart';
import 'package:intrack/Student/models/diary/comments_model.dart';
import 'package:flutter/material.dart';
// import 'chat_message.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CommentsPage extends StatefulWidget {
  final String userToken;
  final String diaryId;
  CommentsPage({
    Key key,
    this.diaryId,
    this.userToken,
  }) : super(key: key);
  @override
  State createState() => new CommentsPageState();
}

class CommentsPageState extends State<CommentsPage> {
  double cHeight;
  double cWidth;

  final TextEditingController _textController = new TextEditingController();
  final List _messages = [];
  String title;
  String teacherName;
  var data;

  void _handleSubmitted(String text) {
    _textController.clear();
    TeacherComments message = new TeacherComments(
      text: text,
      teacherName: teacherName,
    );
    setState(() {
      _messages.insert(0, message);
    });
  }

  Widget _textComposerWidget() {
    return IconTheme(
      data: new IconThemeData(color: Colors.blue),
      child: new Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: new Row(
          children: <Widget>[
            new Flexible(
              child: new TextField(
                keyboardType: TextInputType.multiline,
                decoration:
                    new InputDecoration.collapsed(hintText: "Send a Message"),
                controller: _textController,
                //onSubmitted: _handleSubmitted,
              ),
            ),
            new Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child: new IconButton(
                icon: new Icon(Icons.send),
                onPressed: () {
                  postComment(_textController.text);
                  _handleSubmitted(_textController.text);
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<CommentsModel> getComments() async {
    String path = "/v1/getParticularDiary";
    Map<String, String> params = {'diaryId': widget.diaryId};
    print("entered");
    final response = await http.get(
      Uri(
        scheme: "https",
        host: "api-dashboard.intrack.in",
        // port: 8001,
        path: path,
        queryParameters: params,
      ),
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        "authorization": "Bearer " + widget.userToken
      },
    );
    //print(response.body.toString());
    if (response.statusCode == 200) {
      setState(() {
        data = json.decode(response.body);
        teacherName = data["data"]["teacherId"]["name"];
      });
      // If the call to the server was successful, parse the JSON
      //print(data["data"]["comments"]);

      _messages.clear();
      for (int i = 0; i < data["data"]["comments"].length; i++) {
        if (data["data"]["comments"][i]["studentId"] == null) {
          TeacherComments message = new TeacherComments(
            text: data["data"]["comments"][i]["description"],
            teacherName: data["data"]["teacherId"]["name"],
          );
          _messages.insert(0, message);
        } else {
          StudentComments message = new StudentComments(
            text: data["data"]["comments"][i]["description"],
            studentName: data["data"]["studentId"]["name"],
          );
          _messages.insert(0, message);
        }

        //setState(() {
        //_messages.insert(0, message);
        //});

        title = data["data"]["title"];
        teacherName = data["data"]["teacherId"]["name"];
      }
      return CommentsModel.fromJson(json.decode(response.body));
    }
  }

  Future postComment(String comment) async {
    String path = "/v1/addComments";
    Map<String, String> body = {
      'diaryId': widget.diaryId,
      'description': comment,
    };
    print("entered");
    final response = await http.post(
      Uri(
        scheme: "https",
        host: "api-dashboard.intrack.in",
        // port: 8001,
        path: path,
      ),
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        "authorization": "Bearer " + widget.userToken
      },
      body: body,
    );
    print(response.body);
    if (response.statusCode == 200) {
      print("comment posted");
    }
  }

  @override
  void initState() {
    print("dairy id is: $widget.diaryId");
    super.initState();
    getComments();
  }

  @override
  Widget build(BuildContext context) {
    cHeight = MediaQuery.of(context).size.height;
    cWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Comments"),
      ),
      body: data != null
          ? Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                    top: cHeight * 0.03,
                    left: cWidth * 0.02,
                    right: cWidth * 0.02,
                    bottom: cHeight * 0.02,
                  ),
                  child: Text(
                    data["data"]["title"],
                    style: TextStyle(fontSize: cHeight * 0.022),
                  ),
                ),
                Divider(),
                new Flexible(
                  child: new ListView.builder(
                    padding: new EdgeInsets.all(8.0),
                    reverse: true,
                    itemBuilder: (BuildContext context, int index) {
                      return _messages[index];
                    },
                    itemCount: _messages.length,
                  ),
                ),
                new Divider(height: 1.0),
                new Container(
                  decoration: new BoxDecoration(
                    color: Theme.of(context).cardColor,
                  ),
                  child: _textComposerWidget(),
                ),
              ],
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
