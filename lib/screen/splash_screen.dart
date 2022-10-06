import 'dart:async';
import 'package:chalkboard/screen/landing_page.dart';
import 'package:flutter/material.dart';

class SpalshScreen extends StatefulWidget {
  const SpalshScreen({Key? key}) : super(key: key);

  @override
  _SpalshScreenState createState() => _SpalshScreenState();
}

class _SpalshScreenState extends State<SpalshScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 6), () {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LandingPage(),
          ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // SizedBox(height: 100),
          Row(children: [
            SizedBox(width: 37,),
          Image.asset("assets/images/chalkboard.png"),
          ],)
        ],
      ),
    );
  }
}
