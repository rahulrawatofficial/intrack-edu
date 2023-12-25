import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intrack/Functions/error_handling.dart';
import 'package:intrack/LoginPage/ui/set_new_password.dart';

import 'package:intrack/Theme/theme.dart' as Theme;
import 'package:intrack/Functions/bubble_indication_painter.dart';

import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class ForgotPassword extends StatefulWidget {
  final String role;
  ForgotPassword({Key key, this.role}) : super(key: key);

  @override
  _ForgotPasswordState createState() => new _ForgotPasswordState();
}

var cHeight, cWidth, r;

class _ForgotPasswordState extends State<ForgotPassword>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final FocusNode myFocusNodeEmailLogin = FocusNode();
  final FocusNode myFocusNodePasswordLogin = FocusNode();

  // TextEditingController loginEmailController = TextEditingController();
  // TextEditingController loginPasswordController = TextEditingController();

  // var _formKeyLoginS = GlobalKey<FormState>();
  // var _formKeyLoginT = GlobalKey<FormState>();

  PageController _pageController;

  Color left = Colors.black;
  Color right = Colors.white;
  Map data = new Map();

  int currentPage = 0;

  double cHeight;
  double cWidth;
  TextEditingController _emailController = new TextEditingController();
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
      _getData();
    } else {
      print('Not getting data');
    }
  }

  Future<void> _getData() async {
    var param1 = {"email": _emailController.text, "role": widget.role};
    var param2 = {"phoneNo": _emailController.text, "role": widget.role};
    Uri url = Uri(
      scheme: "https",
      host: "api-dashboard.intrack.in",
      // port: 8001,
      path: "/v1/forgotPassword",
      queryParameters:
          isNumeric(_emailController.text) == false ? param1 : param2,
    );
    var data;
    print(url);
    final response = await http.get(url, headers: {
      "Accept": "applications/json",
      "Content-Type": "application/x-www-form-urlencoded",
      // para
    });
    print(response.body);
    data = convert.jsonDecode(response.body);
    if (response.statusCode == 201) {
      print(response.statusCode);
      data = convert.jsonDecode(response.body);
      // VerifyPassword(token: data["data"]["token"]);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => NewPassword(
                    email: _emailController.text,
                  )));
      // Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //         builder: (context) =>
      //             VerifyPassword(token: data["data"]["token"])));
    } else {
      // print("data ${data["errors"][0]["messages"].runtimeType}");
      String message = data["messgage"] != null
          ? data["messgage"]
          : "Email or Phone number not registered";

      showDialogSingleButton(context, "Error", message, "Ok");
    }
  }

  @override
  Widget build(BuildContext context) {
    cHeight = MediaQuery.of(context).size.height;
    cWidth = MediaQuery.of(context).size.width;
    if (MediaQuery.of(context).orientation == Orientation.landscape) {
      r = cHeight;
      cHeight = cWidth;
      cWidth = r;
    }
    return new Scaffold(
      key: _scaffoldKey,
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overscroll) {
          overscroll.disallowGlow();
        },
        child: SingleChildScrollView(
          child: Container(
            width: cWidth,
            height: cHeight >= 775.0 ? cHeight : 775.0,
            decoration: new BoxDecoration(
              gradient: new LinearGradient(
                  colors: [
                    Theme.Colors.loginGradientStart,
                    Theme.Colors.loginGradientEnd
                  ],
                  begin: const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(1.0, 1.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: cHeight * 0.1),
                  child: Image(
                    width: cWidth / 1.8,
                    height: cHeight / 3.9,
                    fit: BoxFit.fill,
                    image: AssetImage('assets/img/login_logo.png'),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: cHeight * 0.06),
                  child: Text(
                    "Forgot Password?",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Expanded(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints.expand(),
                    child: _buildLogin(context, false), // for student false
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuBar(BuildContext context) {
    cHeight = MediaQuery.of(context).size.height;
    cWidth = MediaQuery.of(context).size.width;
    if (MediaQuery.of(context).orientation == Orientation.landscape) {
      r = cHeight;
      cHeight = cWidth;
      cWidth = r;
    }
    return Container(
      // width: cWidth * 0.71,
      // height: cHeight * 0.067,
      width: 300,
      height: 50,
      decoration: BoxDecoration(
        color: Color(0x552B2B2B),
        borderRadius: BorderRadius.all(
          Radius.circular(25.0),
        ),
      ),
      child: CustomPaint(
        painter: TabIndicationPainter(pageController: _pageController),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              child: FlatButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: _onStudentButtonPress,
                child: Text(
                  "Parent",
                  style: TextStyle(
                    color: left,
                    fontSize: 16.0,
                    fontFamily: "WorkSansSemiBold",
                  ),
                ),
              ),
            ),
            //Container(height: 33.0, width: 1.0, color: Colors.white),
            Expanded(
              child: FlatButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: _onTeacherButtonPress,
                child: Text(
                  "Teacher",
                  style: TextStyle(
                    color: right,
                    fontSize: 16.0,
                    fontFamily: "WorkSansSemiBold",
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogin(BuildContext context, bool type) {
    cHeight = MediaQuery.of(context).size.height;
    cWidth = MediaQuery.of(context).size.width;
    if (MediaQuery.of(context).orientation == Orientation.landscape) {
      r = cHeight;
      cHeight = cWidth;
      cWidth = r;
    }
    return Container(
      // duration: Duration(milliseconds: 20000),
      // curve: Curves.easeOutQuart,
      padding: EdgeInsets.only(top: cHeight * 0.031),
      child: Column(
        children: <Widget>[
          Stack(
            alignment: Alignment.topCenter,
            overflow: Overflow.visible,
            children: <Widget>[
              Card(
                elevation: 2.0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Container(
                  width: cWidth * 0.71,
                  height: cHeight * 0.15,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        feild(
                          context,
                          _emailController,
                          "Email or Phone number",
                          Icon(Icons.account_circle),
                          false,
                          IconButton(
                            icon: Icon(Icons.account_circle),
                            onPressed: () {},
                          ),
                          false,
                          true,
                          _emailController.text,
                          TextInputType.emailAddress,
                        ),
                        Container(
                          width: cWidth * 0.59,
                          height: 1.0,
                          color: Colors.grey[400],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  top: cHeight * 0.13,
                ),
                decoration: new BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Theme.Colors.loginGradientStart,
                      offset: Offset(1.0, 6.0),
                      blurRadius: 20.0,
                    ),
                    BoxShadow(
                      color: Theme.Colors.loginGradientEnd,
                      offset: Offset(1.0, 6.0),
                      blurRadius: 20.0,
                    ),
                  ],
                  gradient: new LinearGradient(
                    colors: [
                      Theme.Colors.loginGradientEnd,
                      Theme.Colors.loginGradientStart
                    ],
                    begin: const FractionalOffset(0.2, 0.2),
                    end: const FractionalOffset(1.0, 1.0),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp,
                  ),
                ),
                child: MaterialButton(
                  highlightColor: Colors.transparent,
                  splashColor: Theme.Colors.loginGradientEnd,
                  // shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: cHeight / 75,
                      horizontal: cWidth * 0.1,
                    ),
                    child: Text(
                      "Next",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25.0,
                        fontFamily: "WorkSansBold",
                      ),
                    ),
                  ),
                  onPressed: () {
                    _launchSubmit();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _onStudentButtonPress() {
    _pageController?.animateToPage(0,
        duration: Duration(milliseconds: 870), curve: Curves.easeOutQuart);
  }

  void _onTeacherButtonPress() {
    _pageController?.animateToPage(1,
        duration: Duration(milliseconds: 870), curve: Curves.easeOutQuart);
  }
}

Widget feild(
  BuildContext context,
  TextEditingController controller,
  String labelText,
  Icon prefixIcon,
  bool suffixPresent,
  IconButton suffixIcon,
  bool obsecure,
  bool autocorrect,
  String feildName,
  TextInputType keyboard,
) {
  // suffixPresent=false;
  cHeight = MediaQuery.of(context).size.height;
  cWidth = MediaQuery.of(context).size.width;
  if (MediaQuery.of(context).orientation == Orientation.landscape) {
    r = cHeight;
    cHeight = cWidth;
    cWidth = r;
  }
  return Padding(
    padding: EdgeInsets.only(
      top: cHeight * 0.018,
      // bottom: cHeight * 0.02,
      left: cWidth * 0.02,
      right: cWidth * 0.02,
    ),
    child: TextFormField(
      controller: controller,
      autofocus: true,
      decoration: InputDecoration(
        border: InputBorder.none,
        // icon: prefixIcon,
        prefixIcon: prefixIcon,
        suffixIcon: suffixPresent ? suffixIcon : null,
        hintText: labelText,
        hintStyle: TextStyle(fontFamily: "WorkSansSemiBold", fontSize: 17.0),
      ),
      style: TextStyle(
        fontFamily: "WorkSansSemi",
        fontSize: cHeight * 0.026,
        color: Colors.black,
      ),
      // style: TextStyle(
      //   fontSize: cHeight * 0.026,
      //   color: Colors.black,
      // ),
      keyboardType: keyboard,
      textInputAction: TextInputAction.done,
      obscureText: obsecure,
      autocorrect: autocorrect,
      onSaved: (value) => feildName = value,
      validator: (value) {
        if (value.isEmpty) {
          return 'Enter the $labelText';
        } else {
          return null;
        }
      },
    ),
  );
}
