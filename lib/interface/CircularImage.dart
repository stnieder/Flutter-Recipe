import 'dart:io';

import 'package:flutter/material.dart';

import 'package:outline_material_icons/outline_material_icons.dart';

class CircularImage extends StatefulWidget{
  File _image;

  CircularImage(
    this._image
  );


  @override
  State<StatefulWidget> createState() {
    return _CircularImage(
      _image
    );
  }
}


class _CircularImage extends State<CircularImage>{
  File _image;

  _CircularImage(
    this._image,
  );


  @override
  Widget build(BuildContext context) {
    return new Container(
      width: 100.0,
      height: 100.0,
      child: Icon(OMIcons.addAPhoto, color: Colors.white, size: 20.0),
      decoration: new BoxDecoration(
        image: new DecorationImage(
          colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.2), BlendMode.darken),
          image: new FileImage(_image),
          fit: BoxFit.cover,
        ),
        borderRadius: new BorderRadius.all(new Radius.circular(50.0)),
      ),
    );
  }
}

