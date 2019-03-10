import 'package:flutter/material.dart';

class MaterialColors{

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
    Color(0xFFf96167), //Red
    Color(0xFFf9d342), //Yellow
    Color(0xFFdf678c), //Pink
    Color(0xFFccf381),  //Green
    Color(0xFF4a274f)   //Purple
  ];

  static List<Color> lightList = [
    Color(0xFFfce77d), //Yellow
    Color(0xFF292826), //Black
    Color(0xFF3d155f), //Purple
    Color(0xFF3642c6),  //Blue
    Color(0xFFf0a07c)  //Orange
  ];

  Color getLightColor(int number) {
    return colorList[number];
  }

  List<Color> getColorCombination(double combination){
    List<Color> value = [darkList[combination.round()], lightList[combination.round()]];
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