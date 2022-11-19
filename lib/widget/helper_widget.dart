import 'package:flutter/material.dart';

Widget customDorpDown({required Widget child, required Icon icon}) {
  return Stack(children: <Widget>[
    Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: Colors.black38,
          ),
        ),
      ),
      padding: EdgeInsets.only(left: 44.0, bottom: 7),
      child: child,
    ),
    Container(
      margin: EdgeInsets.only(top: 12, left: 13),
      child: icon,
    ),
  ]);
}
