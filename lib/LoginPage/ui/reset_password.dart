import 'package:flutter/material.dart';
import 'package:intrack/LoginPage/ui/login_page.dart';

class ResetPassword extends StatefulWidget {
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var _password;
  var _confirmPassword;
  bool passwordVisible = true;
  Widget iconVisible = new Icon(Icons.visibility_off);
  bool confirmPasswordVisible = true;
  Widget confirmIconVisible = new Icon(Icons.visibility_off);

  bool validAndSave() {
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

  void validAndSubmit() {
    if (validAndSave()) {
      _savePassword();
    } else {
      print("Password:$_password Confirm Password:$_confirmPassword");
      print("error saving password");
    }
  }

  _savePassword() {
    // Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //         builder: (context) =>
    //             VerifyPassword(token: information["data"]["token"])));
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

  void _checkPasswordVisibility() {
    passwordVisible = passwordVisible == true ? false : true;
    setState(() {
      iconVisible = passwordVisible == false
          ? new Icon(Icons.visibility)
          : new Icon(Icons.visibility_off);
    });
  }

  void _checkConfirmPasswordVisibility() {
    confirmPasswordVisible = confirmPasswordVisible == true ? false : true;
    setState(() {
      confirmIconVisible = confirmPasswordVisible == false
          ? new Icon(Icons.visibility)
          : new Icon(Icons.visibility_off);
    });
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
      top: cHeight * 0.02,
      left: cWidth * 0.085,
      right: cWidth * 0.085,
    );
    _password = _passwordController.text;
    _confirmPassword = _confirmPasswordController.text;
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Container(
        padding: _pad,
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            new Text(
              'Reset Password',
              textAlign: TextAlign.center,
              style: new TextStyle(fontSize: 25.0, fontWeight: FontWeight.w200),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  new TextFormField(
                    controller: _passwordController,
                    autocorrect: false,
                    decoration: InputDecoration(
                      labelText: 'New Password',
                      suffixIcon: IconButton(
                        icon: iconVisible,
                        color: Colors.blue,
                        onPressed: () {
                          _checkPasswordVisibility();
                        },
                      ),
                    ),
                    keyboardType: TextInputType.text,
                    // onSaved: (value) => _password = value,

                    validator: (value) {
                      if (value.isEmpty) return "Password can't be empty";
                    },
                    obscureText: passwordVisible,
                  ),
                  new TextFormField(
                    controller: _confirmPasswordController,
                    autocorrect: false,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      suffixIcon: IconButton(
                        icon: confirmIconVisible,
                        color: Colors.blue,
                        onPressed: () {
                          _checkConfirmPasswordVisibility();
                        },
                      ),
                    ),
                    keyboardType: TextInputType.text,
                    // onSaved: (value) => _confirmPassword = value,
                    validator: (value) {
                      print(value);
                      if (value.isEmpty && _password.isEmpty)
                        return "Password can't be empty";
                      else if (_confirmPassword != _password)
                        return "Password doesn't match";
                    },
                    obscureText: confirmPasswordVisible,
                  ),
                ],
              ),
            ),
            Flexible(
              flex: 3,
              child: PhysicalModel(
                elevation: 5.0,
                borderRadius: BorderRadius.circular(25.0),
                color: Colors.blue,
                child: new MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0)),
                  child: new Text('Submit'),
                  // onHighlightChanged: ButtonTheme.of(context).,
                  onPressed: () {
                    validAndSubmit();
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
