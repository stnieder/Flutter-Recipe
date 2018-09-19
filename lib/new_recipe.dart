import 'package:flutter/material.dart';

import 'package:outline_material_icons/outline_material_icons.dart';

import 'interface/ContainerDesign.dart';

class NewRecipe extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _NewRecipe();
}

class _NewRecipe extends State<NewRecipe>{
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'add_recipe',
      child: Scaffold(
        appBar: AppBar(
          title: Text("Neues Rezept hinzufügen"),
        ),
        body: Column(
          children: <Widget>[
            Container(
              child: ContainerRedesign(
                title: "Allgemein",
                children: <Widget>[
                  ListTile(
                    leading: Padding(
                      padding: EdgeInsets.only(bottom: 20.0),
                      child: Icon(OMIcons.fastfood),
                    ),
                    title: TextField(
                        autofocus: true,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Name",
                        ),
                        maxLength: 30,
                        maxLengthEnforced: true
                    ),
                  ),
                  ListTile(
                    leading: Padding(
                      padding: EdgeInsets.only(bottom: 20.0),
                      child: Icon(OMIcons.subject),
                    ),
                    title: TextField(
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Beschreibe dein Rezept..."
                      ),
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      maxLength: 200,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}