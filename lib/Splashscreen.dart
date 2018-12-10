import 'dart:async';

import 'package:Time2Eat/recipe/recipebook.dart';
import 'package:flutter/material.dart';

class Splashscreen extends StatefulWidget {
  @override
  _SplashscreenState createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {

  @override
    void initState() {
      super.initState();
      startTime();
    }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      body: Center(        
        child: new Image.asset('images/time2eat.png'),
      ),
    );
  }

  startTime() async{
    var _duration = new Duration(seconds: 3);
    return new Timer(_duration, navigationPage);
  }

  navigationPage() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => Recipebook()
      )
    );
  }
}