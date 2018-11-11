import 'package:flutter/material.dart';

class RecipeSelection extends StatefulWidget {
  @override
  _RecipeSelection createState() => _RecipeSelection();
}

class _RecipeSelection extends State<RecipeSelection> {
  bool searchActive = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultAppBar(),
    );
  }


  defaultAppBar(){
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.close, color: Colors.black45),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
          "Rezept auswählen..."
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.search, color: Colors.black45,),
          onPressed: () => searchAction(),
        )
      ],
    );
  }

  searchAppBar(){
    return AppBar(
      leading: IconButton(
        onPressed: (){},
        icon: Icon(Icons.arrow_back, color: Colors.blueAccent),
      ),
    );
  }

  searchAction(){
    print("SEarching...");
  }
}
