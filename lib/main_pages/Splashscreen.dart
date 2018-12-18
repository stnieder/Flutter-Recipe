import 'dart:async';

import 'package:Time2Eat/customizedWidgets/GoogleColors.dart';
import 'package:Time2Eat/main_pages/recipebook.dart';
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
      body: Padding(        
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).size.height/4,
          left: MediaQuery.of(context).size.width/3.8
        ),
        child: Stack(
          children: <Widget>[
            new Image.asset(
              'images/time2eat.png',
              height: 175.0,
              width: 175.0,
            ),
            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height/1.5,
                left: 45.0
              ),
              child: Text(
                "Vendetta",
                style: TextStyle(
                  color: Colors.grey.withOpacity(0.45),
                  fontFamily: "Google-Sans",
                  fontSize: 22.0,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w600
                ),
              ),
            )
          ],
        ),
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