import 'package:flutter/material.dart';
import 'package:recipe/interface/SearchBox.dart';

class SearchPage extends StatefulWidget{
  @override
    State<StatefulWidget> createState() {
      return _SearchPage();
    }
}

class _SearchPage extends State<SearchPage>{
  @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: false,          
          elevation: 0.0,          
          title: SearchBox(
            autofocus: false,
            addBorder: true,
            elevation: 6.0,
            height: 40.0,
            width: 450.0,
            hintText: "Rezepte suchen",
            leadingButton: IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.black45,
              ),
              onPressed: (){},
            ),
            trailingButton: [
              IconButton(
                icon: Icon(
                  Icons.more_vert,
                  color: Colors.black45
                ),
                onPressed: (){},
              )
            ]
          ),
        ),
        body: Center(
          child: Text("Filter sind hier"),
        ),
      );
    }
}