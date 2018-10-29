import 'package:flutter/material.dart';

class GoogleMaterialColors{

  static List<Color> colorList = [
    Color(0xFF34a853), //Green
    Color(0xFFfbbc04), //Yellow    
    Color(0xFFea4335), //Red
    Color(0xFFa142f4), //Purple
    Color(0xFF399ca4), //Teal
    Color(0xFFc68338), //Dark Orange
    Color(0xFFb74a8e) // Dark Purple
  ];

  Color getLightColor(int number){
    return colorList[number];
  }

  Color primaryColor(){
    return Color(0xFF4285f4).withRed(0).withGreen(100); //Blue
  }

  List<Color> getColorList(int number){
    List<Color> returnColor = [colorList[number], colorList[number].withOpacity(0.2)];
    return returnColor;
  }
}