import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intrack/Functions/error_handling.dart';
import 'package:intrack/Functions/login_logout/savecurrentlogin.dart';
import 'package:intrack/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangeStudent extends StatefulWidget {
  final String userToken;

  const ChangeStudent({
    Key key,
    this.userToken,
  }) : super(key: key);
  @override
  _ChangeStudentState createState() => _ChangeStudentState();
}

class _ChangeStudentState extends State<ChangeStudent> {
  var studentData;

  Future getStudents(BuildContext context, String authToken) async {
    final response = await http.get(
        Uri.encodeFull(
            "https://api-dashboard.intrack.in/v1/parentStudentsList"),
        headers: {
          "authorization": "Bearer " + authToken,
        });
    print(response.statusCode);
    print(response.body);

    var data = json.decode(response.body);
    print("data ${data["message"]}");
    if (response.statusCode == 200) {
      setState(() {
        studentData = data;
      });
      print(authToken);
      print("***SUCCESS*****");
    } else {
      String message = data["message"];
      showDialogSingleButton(context, "Error", message, "Ok");
    }
  }

  Future changeStudent(
    String name,
    String userId,
    String classId,
    String sectionId,
    String studentPic,
  ) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString('CurrentUserName', name);
    await preferences.setString('CurrentUserId', userId);
    await preferences.setString('classId', classId);
    await preferences.setString('sectionId', sectionId);
    await preferences.setString('studentPic', studentPic);
  }

  @override
  void initState() {
    getStudents(context, widget.userToken);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Change Student"),
      ),
      body: studentData != null
          ? ListView.builder(
              itemCount: studentData['data']['students'].length,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: <Widget>[
                    ListTile(
                      enabled: studentData['data']['students'][index]['status'],
                      onTap: () {
                        // changeStudent(
                        //         studentData['data']['students'][index]['name'],
                        //         studentData['data']['students'][index]['_id'])
                        //     .then(() {
                        // });

                        changeStudent(
                          studentData['data']['students'][index]['name'],
                          studentData['data']['students'][index]['_id'],
                          studentData['data']['students'][index]['classId'],
                          studentData['data']['students'][index]['sectionId'],
                          studentData['data']['students'][index]
                              ['profilePicUrl'],
                        ).then((val) {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => MyApp()),
                            ModalRoute.withName("DashBoard"),
                          );
                        });
                      },
                      trailing: Icon(Icons.swap_vertical_circle),
                      leading: studentData['data']['students'][index]
                                  ['profilePicUrl'] !=
                              null
                          ? CircleAvatar(
                              radius: 20,
                              backgroundImage: NetworkImage(studentData['data']
                                  ['students'][index]['profilePicUrl']),
                            )
                          : CircleAvatar(
                              radius: 20,
                            ),
                      title:
                          Text(studentData['data']['students'][index]['name']),
                      subtitle:
                          Text(studentData['data']['students'][index]['email']),
                    ),
                    Divider(),
                  ],
                );
              },
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
