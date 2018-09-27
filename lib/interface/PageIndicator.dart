//Created at 26.09.18 by stnieder


import 'package:flutter/material.dart';

class PageIndicator extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PageIndicator();
}

class _PageIndicator extends State<PageIndicator> with TickerProviderStateMixin{
  AnimationController widthController;
  Animation<double> widthAnimation;


  @override
  void initState() {

    widthController = AnimationController(vsync: this, duration: Duration(seconds: 4))..addListener((){setState(() {});});
    widthAnimation = Tween(begin: 0.0, end: 200.0).animate(CurvedAnimation(parent: widthController, curve: Curves.linear));
    widthController.forward();
    super.initState();
  }

  @override
  void dispose() {
    widthController.dispose();
    super.dispose();
  }

  Widget Indicator(){
    return AnimatedBuilder(
      animation: widthController,
      builder: (BuildContext context, Widget child) {
        return Container(
          color: Colors.blue,
          height: 10.0,
          width: widthAnimation.value,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Indicator();
  }
}