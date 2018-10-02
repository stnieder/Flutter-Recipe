import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:recipe/database/database.dart';
import 'package:recipe/model/Ingredients.dart';
import 'package:recipe/model/Recipes.dart';
import 'package:recipe/model/StepDescription.dart';

Future fetchRecipe(String name) async{
  var dbHelper = new DBHelper();
  Future<List<Recipes>> recipes = dbHelper.getSpecRecipe(name);
  return recipes;
}

Future<List<Ingredients>> fetchIngredients(var recipes) async{
  var dbHelper = DBHelper();
  print("Ingredients:" + dbHelper.getIngredients(recipes[0]).toString());
  Future<List<Ingredients>> ingredients = dbHelper.getIngredients(recipes[0]);  
  return ingredients;
}

Future<List<Steps>> fetchSteps(var recipes) async{
  var dbHelper = DBHelper();
  Future<List<Steps>> steps = dbHelper.getSteps(recipes[0]);
  return steps;
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

  var stringImage;


  @override
    void initState() {
      super.initState();

      (()async {
        var recipeImage = await fetchRecipe(details.recipeName);
        print(recipeImage[6]);
      });
    }

  @override
  Widget build(BuildContext context) {
    String name = details.recipeName;    
    return new Scaffold(
      body:  new CustomScrollView(
        scrollDirection: Axis.vertical,
        slivers: <Widget>[
          new SliverAppBar(
            expandedHeight: 180.0,
            pinned: true,
            flexibleSpace: new FlexibleSpaceBar(
              background: Image.memory(stringImage),
              title: Container(
                child: Text(details.recipeName),                
                decoration: BoxDecoration(
                  gradient: new LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.1, 0.3, 0.5, 0.7],
                    colors: [
                      Colors.white.withOpacity(0.1),
                      Colors.white.withOpacity(0.2),
                      Colors.white.withOpacity(0.3),
                      Colors.white.withOpacity(0.5)                                                               
                    ]
                  )
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(vertical: 2.0),
            sliver: SliverFixedExtentList(
              itemExtent: 200.0,
              delegate: SliverChildBuilderDelegate(
                (builder, index) {
                  return FutureBuilder(
                    future: fetchIngredients(fetchRecipe(name)),
                    builder: (context,snapshot){
                      if(snapshot.hasData){
                        return ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (BuildContext context, int index){                            
                            return Card(
                              child: Row(
                                children: <Widget>[
                                  Text("${snapshot.data[index].number}"),
                                  Text("${snapshot.data[index].description}")
                                ],
                              ),
                            );
                          },
                        );
                      } else if(!snapshot.hasData){
                        return new Text("Keine daten gefunden");
                      }
                    },
                  );
                }
              ),
            ),
          )
        ],
      ),
    );
  }
}