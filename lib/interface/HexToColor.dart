import 'package:flutter/material.dart';

class ConvertColor{
  ConvertColor();

  convertToColor(String color){
    String valueString = color.split('(0x')[1].split(')')[0];
    int value = int.parse(valueString, radix: 16);
    Color usedColor = new Color(value);

    return usedColor;
  }
  
}