import 'package:flutter/material.dart';

var cHeight, cWidth, r;
// Widget feild(
//   BuildContext context,
//   TextEditingController controller,
//   String labelText,
//   IconButton icon,
//   bool obsecure,
//   bool autocorrect,
//   String feildName,
//   TextInputType keyboard,
// ) {
//   cHeight = MediaQuery.of(context).size.height;
//   cWidth = MediaQuery.of(context).size.width;
//   return TextFormField(
//     controller: controller,
//     // autofocus: true,
//     decoration: InputDecoration(
//       labelText: labelText,
//       suffixIcon: icon,
//       contentPadding: EdgeInsets.only(
//         top: cHeight * 0.01,
//         bottom: cHeight * 0.005,
//         right: cWidth * 0.02,
//       ),
//     ),
//     style: TextStyle(
//       fontSize: cHeight * 0.026,
//       color: Colors.black,
//     ),
//     keyboardType: keyboard,
//     textInputAction: TextInputAction.next,
//     obscureText: obsecure,
//     autocorrect: autocorrect,
//     onSaved: (value) => feildName = value,
//     validator: (value) {
//       if (value.isEmpty) {
//         return 'Please enter the $labelText';
//       }
//     },
//   );
// }

// Widget gorgeousButton(
//   BuildContext context,
//   String buttonText,
//   bool signUp,
// ) {
//   return Container(
//     margin: EdgeInsets.only(top: signUp ? 340 : 170.0),
//     decoration: new BoxDecoration(
//       borderRadius: BorderRadius.all(Radius.circular(5.0)),
//       boxShadow: <BoxShadow>[
//         BoxShadow(
//           color: Theme.Colors.loginGradientStart,
//           offset: Offset(1.0, 6.0),
//           blurRadius: 20.0,
//         ),
//         BoxShadow(
//           color: Theme.Colors.loginGradientEnd,
//           offset: Offset(1.0, 6.0),
//           blurRadius: 20.0,
//         ),
//       ],
//       gradient: new LinearGradient(
//           colors: [
//             Theme.Colors.loginGradientEnd,
//             Theme.Colors.loginGradientStart
//           ],
//           begin: const FractionalOffset(0.2, 0.2),
//           end: const FractionalOffset(1.0, 1.0),
//           stops: [0.0, 1.0],
//           tileMode: TileMode.clamp),
//     ),
//     child: MaterialButton(
//       highlightColor: Colors.transparent,
//       splashColor: Theme.Colors.loginGradientEnd,
//       //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 42.0),
//         child: Text(
//           buttonText,
//           style: TextStyle(
//               color: Colors.white, fontSize: 25.0, fontFamily: "WorkSansBold"),
//         ),
//       ),
//       onPressed: () {
//         if (signUp) {
//         } else {
//           SystemChannels.textInput.invokeMethod('TextInput.hide');
//           // validateandsubmit();
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => PurposePage(),
//             ),
//           );
//         }
//       },
//     ),
//   );
// }

Widget gorgeousLine(BuildContext context) {
    cHeight = MediaQuery.of(context).size.height;
    cWidth = MediaQuery.of(context).size.width;
    if (MediaQuery.of(context).orientation == Orientation.landscape) {
      r = cHeight;
      cHeight = cWidth;
      cWidth = r;
    }
  return Padding(
    padding: EdgeInsets.only(
      top: cHeight * 0.013,
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  Colors.white10,
                  Colors.white,
                ],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0, 1.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp),
          ),
          width: cWidth * 0.23,
          height: 1.0,
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  Colors.white,
                  Colors.white10,
                ],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0, 1.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp),
          ),
          width: cWidth * 0.23,
          height: 1.0,
        ),
      ],
    ),
  );
}
