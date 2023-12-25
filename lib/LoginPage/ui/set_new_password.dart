import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intrack/Functions/error_handling.dart';
import 'dart:convert' as convert;
import 'package:intrack/main.dart';

class NewPassword extends StatefulWidget {
  final String role;
  final String email;

  const NewPassword({Key key, this.role, this.email}) : super(key: key);
  State createState() => new _NewPasswordState();
}

class _NewPasswordState extends State<NewPassword> {
  double cHeight;
  double cWidth;
  TextEditingController _uniqueCodeController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var _email;
  var url;

  bool isNumeric(String str) {
    try {
      var value = double.parse(str);
      return true;
    } on FormatException {
      return false;
    }
  }

  bool validandsave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      print('good');
      return true;
    } else {
      print('not good');
      return false;
    }
  }

  void _launchSubmit() {
    if (validandsave()) {
      _changePassword();
    } else {
      print('Not getting data');
    }
  }

  Future<void> _changePassword() async {
    Uri url = Uri(
      scheme: "https",
      host: "api-dashboard.intrack.in",
      // port: 8001,
      path: "/v1/resetPassword",
      // queryParameters: {},
    );
    var body1 = {
      "email": widget.email,
      "uniqueCode": _uniqueCodeController.text,
      "password": _passwordController.text,
    };
    var body2 = {
      "phoneNo": widget.email,
      "uniqueCode": _uniqueCodeController.text,
      "password": _passwordController.text,
    };
    var data;
    print(url);
    final response = await http.post(
      url,
      headers: {
        "Accept": "applications/json",
        "Content-Type": "application/x-www-form-urlencoded",
        // para
      },
      body: isNumeric(widget.email) == false ? body1 : body2,
    );
    print(response.body);
    data = convert.jsonDecode(response.body);
    if (response.statusCode == 201) {
      print(response.statusCode);
      data = convert.jsonDecode(response.body);
      // VerifyPassword(token: data["data"]["token"]);
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => MyApp()),
        (Route<dynamic> route) => false,
        // ModalRoute.withName("/"),
      );
      // Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //         builder: (context) =>
      //             VerifyPassword(token: data["data"]["token"])));
    } else {
      // print("data ${data["errors"][0]["messages"].runtimeType}");
      data = convert.jsonDecode(response.body);
      String message =
          // data["errors"][0]["messages"].toString();
          // message =
          data["message"];

      showDialogSingleButton(context, "Error", message, "Ok");
    }
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
      top: cHeight * 0.02,
      left: cWidth * 0.085,
      right: cWidth * 0.085,
    );
    return Scaffold(
      // resizeToAvoidBottomPadding: false,
      body: Container(
        // height: cHeight,
        // width: cWidth,
        padding: _pad,
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            new Text(
              'Set New Password',
              textAlign: TextAlign.center,
              style: new TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: cWidth * 0.09,
                color: Colors.black54,
              ),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  new TextFormField(
                    controller: _uniqueCodeController,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: 'Unique Code',
                    ),
                    keyboardType: TextInputType.emailAddress,
                    onSaved: (value) => _email = value,
                    validator: (value) {
                      if (value.isEmpty) return "Please enter valid code";
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 18.0),
                    child: TextFormField(
                      controller: _passwordController,
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: 'New Password',
                      ),
                      keyboardType: TextInputType.visiblePassword,
                      onSaved: (value) => _email = value,
                      validator: (value) {
                        if (value.isEmpty) return "Please enter valid code";
                      },
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              flex: 3,
              child: PhysicalModel(
                elevation: 5.0,
                borderRadius: BorderRadius.circular(25.0),
                color: Theme.of(context).primaryColor,
                child: new MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0)),
                  child: new Text(
                    'Submit',
                    style: TextStyle(color: Colors.white),
                  ),
                  // onHighlightChanged: ButtonTheme.of(context).,
                  onPressed: () {
                    _launchSubmit();
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
