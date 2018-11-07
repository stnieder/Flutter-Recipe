import 'dart:io';

import 'package:flutter/material.dart';

import 'package:outline_material_icons/outline_material_icons.dart';

class CircularImage extends StatefulWidget{
  final String imagePath;

  CircularImage(
    this.imagePath
  );


  @override
  State<StatefulWidget> createState() {
    return _CircularImage();
  }
}


class _CircularImage extends State<CircularImage>{
  
  Widget circularImage(){
    return new Container(
      width: 40.0,
      height: 40.0,
      decoration: new BoxDecoration(
        image: new DecorationImage(
          colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.2), BlendMode.darken),
          image: AssetImage(widget.imagePath),
          fit: BoxFit.cover,
        ),
        borderRadius: new BorderRadius.all(new Radius.circular(50.0)),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return circularImage();
  }
}

