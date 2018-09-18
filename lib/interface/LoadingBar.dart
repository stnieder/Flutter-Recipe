import 'package:flutter/material.dart';
import 'dart:math';

class LoadingBar extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _LoadingBar();
}

class _LoadingBar extends State<LoadingBar> with TickerProviderStateMixin{
  bool reverseAnimation = false;

  bool removeBlue = false;
  bool removeRed = false;
  bool removeYellow = false;
  bool removeGreen = false;

  double tweenStart = 1.0;
  double tweenEnd = 408.4;

  AnimationController _redController;
  AnimationController _greenController;
  AnimationController _blueController;
  AnimationController _yellowController;

  Animation<double> _redAnimationWidth;
  Animation<double> _greenAnimationWidth;
  Animation<double> _blueAnimationWidth;
  Animation<double> _yellowAnimationWidth;

  Curve _curve = Curves.easeInOut;

  @override
  void initState() {


    _blueController = AnimationController(vsync: this, duration: Duration(seconds: 1))..addListener((){setState(() {});})..addStatusListener((status){
      if(status == AnimationStatus.forward){
        _redController.forward();
      } else if(status == AnimationStatus.completed){
        removeBlue = !removeBlue;
      }
    });

    _redController = AnimationController(vsync: this, duration: Duration(seconds: 1))..addListener((){setState(() {});})..addStatusListener((status){
      if(status == AnimationStatus.forward){
        _yellowController.forward();
      } else if(status == AnimationStatus.completed){
        removeRed = !removeRed;
      }
    });

    _yellowController = AnimationController(vsync: this, duration: Duration(seconds: 1))..addListener((){setState(() {});})..addStatusListener((status){
      if(status == AnimationStatus.forward){
        _greenController.forward();
      } else if(status == AnimationStatus.completed){
        removeYellow = !removeYellow;
      }
    });

    _greenController = AnimationController(vsync: this, duration: Duration(seconds: 1))..addListener((){setState(() {});})..addStatusListener((status){
      if(status == AnimationStatus.forward){
        _blueController.reverse();
      } else if(status == AnimationStatus.completed){
        removeGreen = !removeGreen;
        _blueController.reset();
        _redController.reset();
        _yellowController.reset();
        _greenController.reset();

      }
    });


    //Create Animations
    _blueAnimationWidth = Tween(begin: tweenStart, end: tweenEnd).animate(CurvedAnimation(parent: _blueController, curve: Curves.linear));
    _redAnimationWidth = Tween(begin: tweenStart, end: tweenEnd).animate(CurvedAnimation(parent: _redController, curve: Curves.linear));
    _yellowAnimationWidth = Tween(begin: tweenStart, end: tweenEnd).animate(CurvedAnimation(parent: _yellowController, curve: Curves.linear));
    _greenAnimationWidth = Tween(begin: tweenStart, end: tweenEnd).animate(CurvedAnimation(parent: _greenController, curve: Curves.linear));


    _blueController.forward();
    super.initState();
  }

  @override
  void dispose() {
    _blueController.dispose();
    _redController.dispose();
    _yellowController.dispose();
    _greenController.dispose();
    super.dispose();
  }

  Widget forwardBar(){
    return AnimatedBuilder(
      animation: _yellowController,
      builder: (BuildContext context, Widget child){
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            (removeBlue
                ? Container()
                : Container(
                    alignment: Alignment.centerLeft,
                    height: 10.0,
                    width: _blueAnimationWidth.value,
                    decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: Color(0xFF4285F4)))
                    ),
                  )
            ),
            (removeRed
                ? Container()
                : Container(
              height: 10.0,
              width: _redAnimationWidth.value,
              decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Color(0xFFDB4437)))
              ),
            )
            ),
            (removeYellow
                ? Container()
                : Container(
              height: 10.0,
              width: _yellowAnimationWidth.value,
              decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Color(0xFFF4B400)))
              ),
            )
            ),
            (removeGreen
                ? Container()
                : Container(
              height: 10.0,
              width: _greenAnimationWidth.value,
              decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Color(0xFF0F9D58)))
              ),
            )
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return forwardBar();
  }
}