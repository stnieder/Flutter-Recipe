import 'dart:math';

import 'package:flutter/material.dart';

class RadialMinutes extends StatelessWidget {
  final double radius;
  final String text;
  final double percentage;
  RadialMinutes({this.radius, this.text, this.percentage});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: this.radius,
      width: this.radius,
      child: new CustomPaint(
        foregroundPainter: new MyPainter(
          lineColor: Colors.grey[400],
          standardWidth: 2.0,
          completeWidth: 4.0,
          completePercent: percentage,
          completeColor: Colors.amber
        ),
        child: Padding(
          padding: EdgeInsets.only(top: radius / 3, left: radius / 8),
          child: Text(
            this.text,
            style: TextStyle(
              fontFamily: "Google-Sans",
              fontSize: 15.0,
              fontWeight: FontWeight.w500
            ),
          ),
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
  double completePercent;
  MyPainter({this.lineColor, this.completePercent, this.completeColor, this.completeWidth, this.standardWidth});

  @override
  void paint(Canvas canvas, Size size){
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
    
    Offset center = new Offset(size.width / 2, size.height / 2);
    double radius = min(size.width/2, size.height/2);
    canvas.drawCircle(
      center,
      radius,
      line
    );

    double arcAngle = 2*pi* (completePercent / 100);

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