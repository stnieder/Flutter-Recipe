import 'package:flutter/material.dart';

class GoogleDivider extends StatefulWidget{
  @override
    State<StatefulWidget> createState() {
      return _GoogleDivider();
    }
}

class _GoogleDivider extends State<GoogleDivider>{
  @override
    Widget build(BuildContext context) {      
      return Padding(
        padding: EdgeInsets.only(left: 45.0, right: 5.0),
        child: Divider(
          color: Colors.black45,
          height: 1.0,
        ),
      );
    }
}