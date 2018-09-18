import 'package:flutter/material.dart';

class Shopping extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _Shopping();
  }
}

class _Shopping extends State<Shopping>{

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(child: Text("Shopping")),
    );
  }

}