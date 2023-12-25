import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'package:intrack/Functions/error_handling.dart';
import 'package:intrack/Functions/login_logout/logout.dart';
import 'package:intrack/LoginPage/ui/login_page.dart';

class ChangePasswordPage extends StatefulWidget {
  final String userToken;
  final String url;
  final bool teacher;
  ChangePasswordPage({Key key, this.userToken, this.url, this.teacher})
      : super(key: key);
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  TextEditingController _currentPassword = new TextEditingController();
  TextEditingController _newPassword = new TextEditingController();
  TextEditingController _confirmNewPassword = new TextEditingController();
  double cHieght;
  double cWidth;
  var t;
  final _formKey = GlobalKey<FormState>();

  //checkLogin function
  Future<void> _checkPassword() async {
    Map<String, String> body = {
      'oldPassword': _currentPassword.text,
      'newPassword': _newPassword.text,
    };

    final response = await http.put(
      Uri.parse(widget.url),
      headers: {"authorization": "Bearer " + widget.userToken},
      body: body,
    );
    var convertDataToJson = json.decode(response.body);
    String type = 'Error';
    if (response.statusCode == 200) {
      widget.teacher
          ? teacherLogout(widget.userToken).then((onValue) {
              logOut().then((val) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                  ModalRoute.withName("Logout"),
                );
              });
            })
          : studentLogout(widget.userToken).then((onValue) {
              logOut().then((val) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                  ModalRoute.withName("Logout"),
                );
              });
            });

      print("Success");
      print(response.statusCode);
      print(response.body);
      type = 'Success';
    } else {
      showDialogSingleButton(context, type, convertDataToJson['message'], "ok");
    }
  }

  bool validAndSave() {
    var form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void validAndSubmit() {
    print("valid and submit");
    if (validAndSave()) {
      try {
        callLogic();
      } catch (e) {
        print(e);
      }
    }
  }

  callLogic() {
    print("CurrentPassword ${_currentPassword.text}");
    print("newPassword ${_newPassword.text}");
    print("ConfirmnewPassword ${_confirmNewPassword.text}");
    if (_newPassword.text == _confirmNewPassword.text) {
      if (_confirmNewPassword.text != null)
        _checkPassword();
      else
        showDialogSingleButton(
            context, "Error", "New Password can't be empty", "OK");
    } else
      showDialogSingleButton(
          context, "Error", "Really! Password didn't match", "OK");
  }

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
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      _pad = EdgeInsets.only(
        top: cHieght * 0.03,
        left: cWidth * 0.05,
        right: cWidth * 0.05,
      );
    } else {
      _pad = EdgeInsets.only(
        top: cWidth * 0.1,
        left: cWidth * 0.1,
        right: cWidth * 0.1,
      );
    }

    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Change Password"),
        backgroundColor: widget.teacher ? Color(0xFFFF6144) : Color(0xFF444B54),
      ),
      resizeToAvoidBottomPadding: false,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: new ListView(
              children: <Widget>[
                Padding(
                  padding: _pad,
                  child: new Text(
                    "Reset Password",
                    style: new TextStyle(
                        fontSize: cHieght * 0.04, fontWeight: FontWeight.bold),
                  ),
                ),
                new Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      feildChangePassword(
                        context,
                        _currentPassword,
                        "Current Password",
                        _pad,
                      ),
                      feildChangePassword(
                        context,
                        _newPassword,
                        "New Password",
                        _pad,
                      ),
                      feildChangePassword(
                        context,
                        _confirmNewPassword,
                        "Confirm Password",
                        _pad,
                      ),
                      // Padding(
                      //   padding: EdgeInsets.only(
                      //       top: cHieght * 0.09,
                      //       left: cWidth * 0.07,
                      //       right: cWidth * 0.07,
                      //       bottom: cHieght * 0.05),
                      //   child: MaterialButton(
                      //     height: cHieght * 0.075,
                      //     minWidth: cHieght * 0.88,
                      //     child: new Text(
                      //       "UPDATE PASSWORD",
                      //       style: new TextStyle(
                      //           color: Colors.white,
                      //           fontSize: cHieght * 0.022,
                      //           fontWeight: FontWeight.bold),
                      //     ),
                      //     color:
                      //         widget.teacher ? Color(0xFFFF6144) : Color(0xFF444B54),
                      //     onPressed: () => validAndSubmit(),
                      //   ),
                      // )
                    ],
                  ),
                )
              ],
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: PhysicalModel(
                  color: Theme.of(context).primaryColor,
                  child: MaterialButton(
                    height: cHieght * 0.075,
                    minWidth: cHieght * 0.88,
                    child: new Text(
                      "UPDATE PASSWORD",
                      style: new TextStyle(
                        color: Colors.white,
                        // fontSize: cHieght * 0.022,
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                    color:
                        widget.teacher ? Color(0xFFFF6144) : Color(0xFF444B54),
                    onPressed: () => validAndSubmit(),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

Widget feildChangePassword(
  BuildContext context,
  TextEditingController controller,
  String labelText,
  EdgeInsets _pad,
) {
  return Padding(
    padding: _pad,
    child: TextFormField(
      obscureText: true,
      autocorrect: false,
      keyboardType: TextInputType.text,
      controller: controller,
      decoration: new InputDecoration(labelText: labelText),
      validator: (value) {
        if (value.isEmpty) return "$labelText can't be empty";
      },
    ),
  );
}
