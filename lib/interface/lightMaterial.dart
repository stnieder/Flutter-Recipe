import 'dart:math';

import 'package:flutter/material.dart';

class LightMaterialColors{
  static Color red = Color(0xFFF44336);
  static Color pink = Color(0xFFF44336);
  static Color purple = Color(0xFFF44336);
  static Color deepPurple = Color(0xFFF44336);
  static Color indigo = Color(0xFFF44336);
  static Color blue = Color(0xFFF44336);
  static Color lightBlue = Color(0xFFF44336);
  static Color cyan = Color(0xFFF44336);
  static Color teal = Color(0xFFF44336);
  static Color green = Color(0xFFF44336);
  static Color lightGreen = Color(0xFFF44336);
  static Color lime = Color(0xFFF44336);
  static Color amber = Color(0xFFF44336);
  static Color orange = Color(0xFFF44336);

  static Color redOpacity = Color(0xFFF44336).withOpacity(0.2);
  static Color pinkOpacity = Color(0xFFF44336).withOpacity(0.2);
  static Color purpleOpacity = Color(0xFFF44336).withOpacity(0.2);
  static Color deepPurpleOpacity = Color(0xFFF44336).withOpacity(0.2);
  static Color indigoOpacity = Color(0xFFF44336).withOpacity(0.2);
  static Color blueOpacity = Color(0xFFF44336).withOpacity(0.2);
  static Color lightBlueOpacity = Color(0xFFF44336).withOpacity(0.2);
  static Color cyanOpacity = Color(0xFFF44336).withOpacity(0.2);
  static Color tealOpacity = Color(0xFFF44336).withOpacity(0.2);
  static Color greenOpacity = Color(0xFFF44336).withOpacity(0.2);
  static Color lightGreenOpacity = Color(0xFFF44336).withOpacity(0.2);
  static Color limeOpacity = Color(0xFFF44336).withOpacity(0.2);
  static Color amberOpacity = Color(0xFFF44336).withOpacity(0.2);
  static Color orangeOpacity = Color(0xFFF44336).withOpacity(0.2);

  List<Color> colorList = [
    red,
    pink,
    purple,
    deepPurple,
    indigo,
    blue,
    lightBlue,
    cyan,
    teal,
    green,
    lightGreen,
    lime,
    amber,
    orange
  ];

  List<Color> colorListOpacity = [
    redOpacity,
    pinkOpacity,
    purpleOpacity,
    deepPurpleOpacity,
    indigoOpacity,
    blueOpacity,
    lightBlueOpacity,
    cyanOpacity,
    tealOpacity,
    greenOpacity,
    lightGreenOpacity,
    limeOpacity,
    amberOpacity,
    orangeOpacity
  ];


  List<Color> getLightColor(int number){
    List<Color> returnColor = [colorList[number], colorListOpacity[number]];
    return returnColor;
  }
}