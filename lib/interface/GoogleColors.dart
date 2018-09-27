import 'dart:math';

import 'package:flutter/material.dart';

class GoogleMaterialColors{

  static List<Color> colorList = [
    Color(0xFF34a853), //Green
    Color(0xFFfbbc04), //Yellow
    Color(0xFF4285f4), //Blue
    Color(0xFFea4335), //Red
    Color(0xFFa142f4) //Purple
  ];

  Color getLightColor(int number){
    return colorList[number];
  }

  List<Color> getColorList(int number){
    List<Color> returnColor = [colorList[number], colorList[number].withOpacity(0.2)];
    return returnColor;
  }
}