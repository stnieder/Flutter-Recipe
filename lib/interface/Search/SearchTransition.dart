import 'package:flutter/material.dart';

class SearchTransition extends PageRouteBuilder{
  final Widget widget;

  SearchTransition({this.widget})
    : super(
      pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation){
        return widget;
      },
      transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child){
        return new FadeTransition(
          opacity: new Tween<double>(
            begin: 0.5,
            end: 1.0
          ).animate(animation),
          child: child,
        );
      }
    );
}