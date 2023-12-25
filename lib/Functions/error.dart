import 'package:flutter/material.dart';

double cHeight = 700;
double cWidth = 400;
@override
Widget errorCheck() {
  // cHeight = MediaQuery.of(context).size.height;
  // cWidth = MediaQuery.of(context).size.width;

  return Center(
    child: Container(
      height: cHeight * 0.2,
      width: cWidth,
      padding: EdgeInsets.only(
          // top: cHeight * 0.028,
          left: cWidth * 0.025,
          right: cWidth * 0.025,
          bottom: cHeight * 0.015),
      child: Card(
        child: Center(
          child: Padding(
            padding: EdgeInsets.only(left: cWidth * 0.04),
            child: Text(
              "Check your internet connectivity",
              style: TextStyle(
                fontSize: 17.0,
                fontWeight: FontWeight.w500,
                color: Colors.redAccent,
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

// Widget Error(String s, double cHeight, double cWidth) {}
