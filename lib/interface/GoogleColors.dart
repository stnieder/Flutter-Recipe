import 'dart:math';

import 'package:flutter/material.dart';

class GoogleMaterialColors{

  static List<Color> colorList = [
    Color(0xFF34a853), //Green
    Color(0xFFfbbc04), //Yellow    
    Color(0xFFea4335), //Red
    Color(0xFFa142f4), //Purple
    Color(0xFF399ca4), //Teal
    Color(0xFFffa700), //Orange
    Color(0xFFb74a8e), //Dark Purple
    Color(0xFF4285f4)  //Blue
  ];

  static List<Color> darkList = [
    Color(0xFF34a853), //Green
    Color(0xFF4285f4), //Blue
    Color(0xFF0047ab), //Cobalt blue
  ];

  static List<Color> lightList = [
    Color(0xFFfbbc04), //Yellow
    Color(0xFFea4335), //Red
    Color(0xFFffa700), //Orange
  ];

  Color getLightColor(int number) {
    return colorList[number];
  }

  List<Color> getColorCombination(){
    int random = new Random().nextInt(3);
    List<Color> value = [darkList[random], lightList[random]];
    return value;
  }

  Color primaryColor(){
    return Color(0xFF4285f4).withRed(0).withGreen(115); //Blue
  }

  List<Color> getColorList(int number){
    List<Color> returnColor = [colorList[number], colorList[number].withOpacity(0.2)];
    return returnColor;
  }
}