import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sliver_fab/sliver_fab.dart';
import 'package:recipe/database/database.dart';
import 'package:recipe/model/Ingredients.dart';

Future<List<Ingredients>> fetchIngredients(String name){
  var dbHelper = new DBHelper();
  Future<List<Ingredients>> ingredients = dbHelper.getIngredients(name);
  return ingredients;
}

class RecipeDetails extends StatefulWidget{
  String recipeName;
  RecipeDetails(this.recipeName);

  @override
    State<StatefulWidget> createState() {
      return new _RecipeDetails(this);
    }
}

class _RecipeDetails extends State<RecipeDetails>{
  RecipeDetails details;
  _RecipeDetails(this.details);
  
  String recipe;

  @override
    void initState() {
      super.initState();      
    }

  @override
  Widget build(BuildContext context) {
    recipe = details.recipeName;    

    return new Scaffold(
      body: FutureBuilder<List<Ingredients>>(
        future: fetchIngredients(recipe),
        builder: (context, snapshot){
          Widget zutaten  = CircularProgressIndicator();
          if(snapshot.hasData){
            zutaten = ListView.builder(              
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index){
                return Text(snapshot.data[index].number.toString() + snapshot.data[index].measure + " " + snapshot.data[index].name);
              },
            );
          } else if(snapshot.hasError){
            zutaten = Text("Keine Daten gefunden");
          }

          return SliverFab(
                expandedHeight: 256.0,
                floatingActionButton: FloatingActionButton(
                  backgroundColor: Colors.red[300],
                  child: Icon(Icons.favorite_border, color: Colors.white),                  
                  onPressed: (){
                    Scaffold.of(context).showSnackBar(
                      new SnackBar(content: new Text("You clicked FAB!"))
                    );
                  },
                ),               
                slivers: <Widget>[
                  SliverAppBar(
                    expandedHeight: 256.0,
                    flexibleSpace: FlexibleSpaceBar(
                      title: new Text(recipe),
                    ),
                    pinned: true,
                  ),
                  SliverPadding(
                    padding: EdgeInsets.only(top: 30.0),
                    sliver: zutaten,
                  )
                ],
              );
        },
      ),
    );
  }
}