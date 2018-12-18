import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {

  final Widget title;
  final double barHeight = 65.0; // change this for different heights 

  CustomAppBar({this.title});

  @override
  Widget build(BuildContext context) {
    final double statusbarHeight = MediaQuery
        .of(context)
        .padding
        .top;

    return new Container(
      padding: new EdgeInsets.only(top: statusbarHeight),
      height: statusbarHeight + barHeight,
      width: MediaQuery.of(context).size.width,
      child: title
    );
  }
}