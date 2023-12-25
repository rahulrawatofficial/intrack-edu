import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';

Future versionCheck(context) async {
  //Get Current installed version of app
  final PackageInfo info = await PackageInfo.fromPlatform();
  // double currentVersion = double.parse(info.version.trim().replaceAll(".", ""));
  print("!!${info.buildNumber}!!");
  return int.parse(info.buildNumber);
}

Future getLatestVersion(BuildContext context, String userToken) async {
  int port;
  print("****");
  try {
    final response = await http.get(
      Uri(
        scheme: "https",
        host: "api-dashboard.intrack.in",
        port: port,
        path: "/v1/getAppVersion",
      ),
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        // "authorization": "Bearer " + userToken,
      },
    );
    // final response = await ApiBase().get(context, "/api/getApp", null, userToken);
    if (response.statusCode == 200) {
      print("Success");
      print(response.body);
      var data = json.decode(response.body);
      // return 0;
      if (Platform.isIOS)
        return data["data"]["iosAppVersion"];
      else
        return data["data"]["androidAppVersion"];

      // return json.decode(response.body);
    } else {
      print("Fail");
      print(response.body);
      print(response.statusCode);
      return 0;
    }
  } on SocketException {
    print("Fail");
    return 0;
  }
}

_launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

//Alert for Force Update
showVersionDialog(context) async {
  await Future.delayed(Duration(milliseconds: 50));
  await showDialog<String>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      String title = "New Update Available";
      String message =
          "There is a newer version of app available please update it now. ";
      String btnLabel = "Update Now";
      String btnLabelCancel = "Later";
      return Platform.isIOS
          ? new CupertinoAlertDialog(
              title: Text(title),
              content: Text(message),
              actions: <Widget>[
                FlatButton(
                    child: Text(btnLabel),
                    onPressed: () => _launchURL(
                        "https://apps.apple.com/in/app/intrack-education/id1500257908")
                    // _launchURL(APP_STORE_URL),
                    ),
                // FlatButton(
                //   child: Text(btnLabelCancel),
                //   onPressed: () {},
                //   // => Navigator.pop(context),
                // ),
              ],
            )
          : new AlertDialog(
              title: Text(title),
              content: Text(message),
              actions: <Widget>[
                FlatButton(
                  child: Text(btnLabel),
                  onPressed: () => _launchURL(
                      "https://play.google.com/store/apps/details?id=com.intrack.app"),
                ),
                // FlatButton(
                //   child: Text(btnLabelCancel),
                //   onPressed: () => Navigator.pop(context),
                // ),
              ],
            );
    },
  );
}
