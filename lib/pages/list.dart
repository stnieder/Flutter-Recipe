import 'dart:async';
import 'dart:math';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:side_header_list_view/side_header_list_view.dart';

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
      body: new Container(
        padding: new EdgeInsets.all(16.0),
        child: new FutureBuilder<List<Recipes>>(
          future: fetchRecipes(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return new SideHeaderListView(
                itemCount: snapshot.data.length,
                itemExtend: 150.0,
                headerBuilder: (BuildContext context, int index){
                  return new Text(snapshot.data[index].name[0]);
                },
                itemBuilder: (BuildContext context, int index){
                  return Container(
                    child: Card(   
                        child: Row(
                          children: <Widget>[
                            CircleAvatar(
                              child: Text("1"),                                   
                              backgroundColor: colors.getLightColor(5),       
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 15.0, left: 7.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "${snapshot.data[index].name}",
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      fontFamily: "Google-Sans",
                                      color: Colors.black
                                    ),
                                  ),
                                  Container(
                                    child: Text(
                                      "${snapshot.data[index].definition}",
                                      style: TextStyle(
                                        color: Colors.black.withOpacity(0.5)
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                    width: 265.0,
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
                    height: 80.0,
                  );
                },
                hasSameHeader: (int a, int b){
                  return snapshot.data[a].name == snapshot.data[b].name;
                },
              );
            } else if (snapshot.hasError) {
              return new Text("Zurzeit sind keine Daten vorhanden.");
            }
            return new Container(alignment: AlignmentDirectional.center,child: new CircularProgressIndicator(),);
          },
        ),
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