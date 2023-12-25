// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:intrack/Functions/error_handling.dart';
// import 'package:intrack/LoginPage/ui/feild.dart';
// import 'package:intrack/LoginPage/ui/set_new_password.dart';
// import 'dart:convert' as convert;
// import 'package:intrack/Theme/theme.dart' as Themes;

// class ForgotPassword extends StatefulWidget {
//   final String role;

//   const ForgotPassword({Key key, this.role}) : super(key: key);
//   @override
//   State createState() => new _ForgotPasswordState();
// }

// class _ForgotPasswordState extends State<ForgotPassword> {
//   double cHeight;
//   double cWidth;
//   TextEditingController _emailController = new TextEditingController();

//   TextEditingController loginPasswordController = new TextEditingController();
//   TextEditingController loginEmailController = new TextEditingController();
//   final _formKey = GlobalKey<FormState>();
//   var _email;
//   var url;

//   bool isNumeric(String str) {
//     try {
//       var value = double.parse(str);
//       return true;
//     } on FormatException {
//       return false;
//     }
//   }

//   bool validandsave() {
//     final form = _formKey.currentState;
//     if (form.validate()) {
//       form.save();
//       print('good');
//       return true;
//     } else {
//       print('not good');
//       return false;
//     }
//   }

//   void _launchSubmit() {
//     if (validandsave()) {
//       _getData();
//     } else {
//       print('Not getting data');
//     }
//   }

//   Future<void> _getData() async {
//     var param1 = {"email": _emailController.text, "role": widget.role};
//     var param2 = {"phoneNo": _emailController.text, "role": widget.role};
//     Uri url = Uri(
//       scheme: "https",
//       host: "api-dashboard.intrack.in",
//       // port: 8001,
//       path: "/v1/forgotPassword",
//       queryParameters:
//           isNumeric(_emailController.text) == false ? param1 : param2,
//     );
//     var data;
//     print(url);
//     final response = await http.get(url, headers: {
//       "Accept": "applications/json",
//       "Content-Type": "application/x-www-form-urlencoded",
//       // para
//     });
//     print(response.body);
//     data = convert.jsonDecode(response.body);
//     if (response.statusCode == 201) {
//       print(response.statusCode);
//       data = convert.jsonDecode(response.body);
//       // VerifyPassword(token: data["data"]["token"]);
//       Navigator.push(
//           context,
//           MaterialPageRoute(
//               builder: (context) => NewPassword(
//                     email: _emailController.text,
//                   )));
//       // Navigator.push(
//       //     context,
//       //     MaterialPageRoute(
//       //         builder: (context) =>
//       //             VerifyPassword(token: data["data"]["token"])));
//     } else {
//       // print("data ${data["errors"][0]["messages"].runtimeType}");
//       String message = data["messgage"] != null
//           ? data["messgage"]
//           : "Email or Phone number not registered";

//       showDialogSingleButton(context, "Error", message, "Ok");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     cHeight = MediaQuery.of(context).size.height;
//     cWidth = MediaQuery.of(context).size.width;

//     if (MediaQuery.of(context).orientation == Orientation.landscape) {
//       var r = cHeight;
//       cHeight = cWidth;
//       cWidth = r;
//     }
//     EdgeInsets _pad = EdgeInsets.only(
//       top: cHeight * 0.02,
//       left: cWidth * 0.085,
//       right: cWidth * 0.085,
//     );
//     return Scaffold(
//       // resizeToAvoidBottomPadding: false,
//       body: Container(
//         decoration: new BoxDecoration(
//           borderRadius: BorderRadius.all(Radius.circular(5.0)),
//           boxShadow: <BoxShadow>[
//             BoxShadow(
//               color: Themes.Colors.loginGradientStart,
//               offset: Offset(1.0, 6.0),
//               blurRadius: 20.0,
//             ),
//             BoxShadow(
//               color: Themes.Colors.loginGradientEnd,
//               offset: Offset(1.0, 6.0),
//               blurRadius: 20.0,
//             ),
//           ],
//           gradient: new LinearGradient(
//             colors: [
//               Themes.Colors.loginGradientEnd,
//               Themes.Colors.loginGradientStart
//             ],
//             begin: const FractionalOffset(0.2, 0.2),
//             end: const FractionalOffset(1.0, 1.0),
//             stops: [0.0, 1.0],
//             tileMode: TileMode.clamp,
//           ),
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: <Widget>[
//             Container(
//               height: cHeight * 0.8,
//               // width: cWidth,
//               padding: _pad,
//               child: new Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: <Widget>[
//                   new Text(
//                     'Forgot Password?',
//                     textAlign: TextAlign.center,
//                     style: new TextStyle(
//                       fontWeight: FontWeight.w600,
//                       fontSize: cWidth * 0.09,
//                       color: Colors.black54,
//                     ),
//                   ),
//                   new CircleAvatar(
//                     child: new Icon(
//                       Icons.account_circle,
//                       size: 140.0,
//                       color: Theme.of(context).primaryColor,
//                     ),
//                     radius: cHeight * 0.095,
//                     backgroundColor: Colors.transparent,
//                   ),
//                   new Text(
//                     'Enter the registered email address',
//                     textAlign: TextAlign.center,
//                     style: new TextStyle(
//                         fontSize: 25.0, fontWeight: FontWeight.w200),
//                   ),
//                   // Form(
//                   //   key: _formKey,
//                   //   child: new TextFormField(
//                   //     controller: _emailController,
//                   //     autofocus: true,
//                   //     decoration: InputDecoration(
//                   //       hintText: 'Email or Phone Number',
//                   //     ),
//                   //     keyboardType: TextInputType.emailAddress,
//                   //     onSaved: (value) => _email = value,
//                   //     validator: (value) {
//                   //       if (value.isEmpty) return "Please enter a valid email";
//                   //     },
//                   //   ),
//                   // ),
//                   Container(
//                     // duration: Duration(milliseconds: 20000),
//                     // curve: Curves.easeOutQuart,
//                     padding: EdgeInsets.only(top: cHeight * 0.031),
//                     child: Column(
//                       children: <Widget>[
//                         Stack(
//                           alignment: Alignment.topCenter,
//                           overflow: Overflow.visible,
//                           children: <Widget>[
//                             Card(
//                               elevation: 2.0,
//                               color: Colors.white,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(8.0),
//                               ),
//                               child: Container(
//                                 width: cWidth * 0.71,
//                                 height: cHeight * 0.12,
//                                 child: Form(
//                                   // key: type ? _formKeyLoginT : _formKeyLoginS,
//                                   child: Column(
//                                     children: <Widget>[
//                                       feild(
//                                         context,
//                                         loginEmailController,
//                                         "Email or Phone number",
//                                         Icon(Icons.account_circle),
//                                         false,
//                                         IconButton(
//                                           icon: Icon(Icons.account_circle),
//                                           onPressed: () {},
//                                         ),
//                                         false,
//                                         true,
//                                         "_emailLogin",
//                                         TextInputType.emailAddress,
//                                       ),
//                                       // feild(
//                                       //   context,
//                                       //   loginPasswordController,
//                                       //   "Password",
//                                       //   Icon(Icons.lock),
//                                       //   true,
//                                       //   IconButton(
//                                       //     icon: Icon(Icons.arrow_back_ios),
//                                       //     color: Color(0xFFF47E50),
//                                       //     onPressed: () {},
//                                       //   ),
//                                       //   true,
//                                       //   false,
//                                       //   "_passwordLogin",
//                                       //   TextInputType.text,
//                                       // ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             Container(
//                               margin: EdgeInsets.only(
//                                 top: cHeight * 0.226,
//                               ),
//                               decoration: new BoxDecoration(
//                                 borderRadius:
//                                     BorderRadius.all(Radius.circular(5.0)),
//                                 boxShadow: <BoxShadow>[
//                                   BoxShadow(
//                                     color: Themes.Colors.loginGradientStart,
//                                     offset: Offset(1.0, 6.0),
//                                     blurRadius: 20.0,
//                                   ),
//                                   BoxShadow(
//                                     color: Themes.Colors.loginGradientEnd,
//                                     offset: Offset(1.0, 6.0),
//                                     blurRadius: 20.0,
//                                   ),
//                                 ],
//                                 gradient: new LinearGradient(
//                                   colors: [
//                                     Themes.Colors.loginGradientEnd,
//                                     Themes.Colors.loginGradientStart
//                                   ],
//                                   begin: const FractionalOffset(0.2, 0.2),
//                                   end: const FractionalOffset(1.0, 1.0),
//                                   stops: [0.0, 1.0],
//                                   tileMode: TileMode.clamp,
//                                 ),
//                               ),
//                               child: MaterialButton(
//                                 highlightColor: Colors.transparent,
//                                 splashColor: Themes.Colors.loginGradientEnd,
//                                 // shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
//                                 child: Padding(
//                                   padding: EdgeInsets.symmetric(
//                                     vertical: cHeight / 75,
//                                     horizontal: cWidth * 0.1,
//                                   ),
//                                   child: Text(
//                                     "Log-In",
//                                     style: TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 25.0,
//                                       fontFamily: "WorkSansBold",
//                                     ),
//                                   ),
//                                 ),
//                                 onPressed: () {},
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                   // Flexible(
//                   //   flex: 3,
//                   //   child: PhysicalModel(
//                   //     elevation: 5.0,
//                   //     borderRadius: BorderRadius.circular(25.0),
//                   //     color: Theme.of(context).primaryColor,
//                   //     child: new MaterialButton(
//                   //       shape: RoundedRectangleBorder(
//                   //           borderRadius: BorderRadius.circular(25.0)),
//                   //       child: new Text(
//                   //         'Next',
//                   //         style: TextStyle(color: Colors.white),
//                   //       ),
//                   //       // onHighlightChanged: ButtonTheme.of(context).,
//                   //       onPressed: () {
//                   //         _launchSubmit();
//                   //       },
//                   //     ),
//                   //   ),
//                   // )
//                 ],
//               ),
//             ),
//             Row(
//               children: <Widget>[
//                 Expanded(
//                   child: PhysicalModel(
//                     color: Theme.of(context).primaryColor,
//                     child: MaterialButton(
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(25.0)),
//                       child: new Text(
//                         'Next',
//                         style: TextStyle(color: Colors.white),
//                       ),
//                       // onHighlightChanged: ButtonTheme.of(context).,
//                       onPressed: () {
//                         _launchSubmit();
//                       },
//                     ),
//                   ),
//                 ),
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   Widget feild(
//     BuildContext context,
//     TextEditingController controller,
//     String labelText,
//     Icon prefixIcon,
//     bool suffixPresent,
//     IconButton suffixIcon,
//     bool obsecure,
//     bool autocorrect,
//     String feildName,
//     TextInputType keyboard,
//   ) {
//     // suffixPresent=false;
//     cHeight = MediaQuery.of(context).size.height;
//     cWidth = MediaQuery.of(context).size.width;
//     if (MediaQuery.of(context).orientation == Orientation.landscape) {
//       r = cHeight;
//       cHeight = cWidth;
//       cWidth = r;
//     }
//     return Padding(
//       padding: EdgeInsets.only(
//         top: cHeight * 0.018,
//         // bottom: cHeight * 0.02,
//         left: cWidth * 0.02,
//         right: cWidth * 0.02,
//       ),
//       child: TextFormField(
//         controller: controller,
//         autofocus: true,
//         decoration: InputDecoration(
//           border: InputBorder.none,
//           // icon: prefixIcon,
//           prefixIcon: prefixIcon,
//           suffixIcon: suffixPresent ? suffixIcon : null,
//           hintText: labelText,
//           hintStyle: TextStyle(fontFamily: "WorkSansSemiBold", fontSize: 17.0),
//         ),
//         style: TextStyle(
//           fontFamily: "WorkSansSemi",
//           fontSize: cHeight * 0.026,
//           color: Colors.black,
//         ),
//         // style: TextStyle(
//         //   fontSize: cHeight * 0.026,
//         //   color: Colors.black,
//         // ),
//         keyboardType: keyboard,
//         textInputAction: TextInputAction.done,
//         obscureText: obsecure,
//         autocorrect: autocorrect,
//         onSaved: (value) => feildName = value,
//         validator: (value) {
//           if (value.isEmpty) {
//             return 'Please enter the $labelText';
//           }
//         },
//       ),
//     );
//   }
// }
