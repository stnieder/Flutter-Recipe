import 'dart:io';

import 'package:flutter/material.dart';

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
      width: 190.0,
      height: 190.0,
      decoration: new BoxDecoration(
        shape: BoxShape.circle,
        image: new DecorationImage(
          fit: BoxFit.fill,
          image: new FileImage(_image)
        )
    )
    );
  }
}

