import 'package:flutter/material.dart';

class Lists extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _List();
  }
}

class _List extends State<Lists>{

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(child: Text("List")),
    );
  }

}