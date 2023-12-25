import 'package:flutter/material.dart';
import 'package:intrack/LoginPage/ui/forgotPassword.dart';
import 'package:intrack/LoginPage/ui/reset_password.dart';

class VerifyPassword extends StatefulWidget {
  VerifyPassword({Key key, this.token}) : super(key: key);
  final String token;

  _VerifyPasswordState createState() => _VerifyPasswordState();
}

class _VerifyPasswordState extends State<VerifyPassword> {
  TextEditingController _codeController = new TextEditingController();
  var _formKey = GlobalKey<FormState>();
  var _code;

  bool validAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      return true;
    } else
      return false;
  }

  void _launchVerify() {
    if (validAndSave()) {
      try {
        _getCheck();
      } catch (e) {}
    }
  }

  _getCheck() {
    print('code: $_code token: ${widget.token}');
    if (_code == widget.token) {
      _launchResetPassword();
      print('go');
    } else {
      print("Wrong verification code");
    }
  }

  _launchResetPassword() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResetPassword(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    double cHeight = MediaQuery.of(context).size.height;
    double cWidth = MediaQuery.of(context).size.width;

    if (MediaQuery.of(context).orientation == Orientation.landscape) {
      var r = cHeight;
      cHeight = cWidth;
      cWidth = r;
    }
    EdgeInsets _pad = EdgeInsets.only(
      top: cHeight * 0.016,
      left: cWidth * 0.085,
      right: cWidth * 0.085,
    );
    return Scaffold(
      // resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,
      body: new Container(
        padding: _pad,
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Text(
              'Verification',
              style: new TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25.0,
                color: Colors.black87,
              ),
            ),
            new CircleAvatar(
              child: new Icon(
                Icons.account_circle,
                size: 140.0,
                color: Color(0xFFf7418c),
              ),
              radius: cHeight * 0.095,
              backgroundColor: Colors.transparent,
            ),
            new Text(
              'Please enter the verification code',
              style: new TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                  color: Colors.black54),
            ),
            new Form(
              key: _formKey,
              child: new TextFormField(
                controller: _codeController,
                autocorrect: false,
                decoration:
                    InputDecoration(hintText: 'Enter verification code'),
                // onSaved: (value) => _code = value,
                validator: (value) {
                  _code = value;
                  if (value.isEmpty) {
                    return "Please enter the verification code";
                  }
                },
              ),
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Text(
                  "If you don't recieve the code!",
                  style: new TextStyle(
                    fontWeight: FontWeight.w200,
                    fontSize: 15.0,
                  ),
                ),
                FlatButton(
                  onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => ForgotPassword(),
                        ),
                        // (Route<dynamic> route) => false,
                        ModalRoute.withName("/"),
                      ),
                  child: new Text(
                    'Resend',
                    style: new TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15.0,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: PhysicalModel(
                    color: Color(0xFFf7418c),
                    borderRadius: BorderRadius.circular(25.0),
                    child: new MaterialButton(
                      child: new Text(
                        'Verify',
                        style: new TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onPressed: () {
                        _launchVerify();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
