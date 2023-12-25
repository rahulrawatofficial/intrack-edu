import 'package:flutter/material.dart';
import 'package:intrack/Functions/login_logout/logout.dart';
import 'package:intrack/LoginPage/ui/login_page.dart';

class ShowError {
  tokenExpired(BuildContext context, String title, String message,
      String buttonLabel, String userToken, String userRole) {
//flutter define function
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          //return object of type dialoge
          return AlertDialog(
            // title: new Text("$title \n"),
            content: new Text(
              // message
              "Session Expired",
            ),
            actions: <Widget>[
              FlatButton(
                // usually buttons at the bottom of the dialog
                child: new Text(buttonLabel),
                onPressed: () {
                  userRole == "STUDENT"
                      ? studentLogout(userToken).then((val) {
                          logOut().then((v) {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()),
                              ModalRoute.withName("Logout"),
                            );
                          });
                        })
                      : teacherLogout(userToken).then((val) {
                          logOut().then((v) {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()),
                              ModalRoute.withName("Logout"),
                            );
                          });
                        });
                  ;

                  // Navigator.pushAndRemoveUntil(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => LoginPage()),
                  //   ModalRoute.withName('HomePage'),
                  // );
                },
              )
            ],
          );
        });
  }
}

void showDialogSingleButton(
    BuildContext context, String title, String message, String buttonLabel) {
//flutter define function
  showDialog(
      context: context,
      builder: (BuildContext context) {
        //return object of type dialoge
        return AlertDialog(
          title: new Text("$title \n"),
          content: new Text(message ?? "Empty"),
          actions: <Widget>[
            FlatButton(
              // usually buttons at the bottom of the dialog
              child: new Text(buttonLabel),
              onPressed: () {
                Navigator.of(context).pop();
                // Navigator.pushAndRemoveUntil(
                //     context,
                //     MaterialPageRoute(builder: (context) => LoginPage()),
                //     ModalRoute.withName('HomePage'));
              },
            )
          ],
        );
      });
}
