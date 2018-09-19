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
      body: new Center(
          child: Text("List")
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF0F9D58),
        elevation: 4.0,
        child: Icon(Icons.add),
        heroTag: 'add_recipe',
        onPressed: (){
          Navigator.pushNamed(context, '/add_recipe');
        },
      )
    );
  }

}