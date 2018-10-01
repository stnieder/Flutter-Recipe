import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:outline_material_icons/outline_material_icons.dart';

import 'package:recipe/database/database.dart';
import 'package:recipe/interface/GoogleColors.dart';
import 'package:recipe/model/Recipes.dart';


Future<List<Recipes>> fetchRecipes() async{
  var dbHelper = DBHelper();
  Future<List<Recipes>> recipes = dbHelper.getRecipes();
  return recipes;
}


class Lists extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _List();
  }
}

class _List extends State<Lists>{
  GoogleMaterialColors colors = new GoogleMaterialColors();
  Random random = new Random();

  @override
    void initState() {
      super.initState();
    }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Container(
        child: Card(   
          elevation: 10.0,
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  child: Text("1"),
                  backgroundColor: colors.getLightColor(random.nextInt(5)),              
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15.0, left: 7.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Rezeptname",
                        style: TextStyle(
                          fontSize: 15.0,
                          fontFamily: "Google-Sans",
                          color: Colors.black
                        ),
                      ),
                      Container(
                        child: Text(
                          "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.5)
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        width: 300.0,
                      ),
                      
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    OMIcons.favoriteBorder,
                    color: Colors.red,
                  ),
                  onPressed: (){
                    
                  },
                )
              ],
          ),
        ),
        width: 550.0,
        height: 80.0,
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