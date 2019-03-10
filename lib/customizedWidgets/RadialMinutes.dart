import 'dart:math';

import 'package:flutter/material.dart';

class RadialMinutes extends StatefulWidget {
  final double radius;
  final Widget center;
  final double minutes;
  final Color completeColor;
  final Color lineColor;
  RadialMinutes(
    {
      this.radius, 
      this.center, 
      this.minutes,
      @required this.completeColor,
      @required this.lineColor
    }
  );

  @override
  _RadialMinutesState createState() => _RadialMinutesState();
}

class _RadialMinutesState extends State<RadialMinutes> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.radius,
      width: widget.radius,
      child: CustomPaint(
        foregroundPainter: new MyPainter(
          lineColor: widget.lineColor,
          standardWidth: 2.0,
          completeWidth: 4.0,
          minutes: widget.minutes,
          completeColor: widget.completeColor
        ),
        child: Center(
          child: widget.center,
        ),
      ),
    );
  }
}

class MyPainter extends CustomPainter{
  Color lineColor;
  Color completeColor;
  double completeWidth;
  double standardWidth;
  double minutes;
  MyPainter({this.lineColor, this.minutes, this.completeColor, this.completeWidth, this.standardWidth});

  @override
  void paint(Canvas canvas, Size size){
    Offset center = new Offset(size.width / 2, size.height / 2);
    double radius = min(size.width/2, size.height/2);    
    double hours = minutes / 60;
    double rest = minutes % 60;

    if(hours >= 1){
      double opacity = hours/10;
      if(opacity >= 0.7) hours = hours / 100;
      lineColor = completeColor.withOpacity(opacity);
      completeColor = completeColor.withOpacity(opacity+0.3);

      minutes = rest;
    } 

    Paint line = new Paint()
      ..color = lineColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = standardWidth;
    Paint complete = new Paint()
      ..color = completeColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = completeWidth;

    canvas.drawCircle(
      center,
      radius,
      line
    );  
    
    double arcAngle = 2*pi* (((minutes / 60)));

    canvas.drawArc(
      new Rect.fromCircle(center:  center, radius: radius),
      -pi/2,
      arcAngle,
      false,
      complete
    );
    
  }

  @override
    bool shouldRepaint(CustomPainter oldDelegate) {
      return true;
    }
}