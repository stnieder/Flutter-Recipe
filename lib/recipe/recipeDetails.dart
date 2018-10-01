import 'dart:async';

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
  _RecipeDetails(details);


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body:  new CustomScrollView(
        scrollDirection: Axis.vertical,
        slivers: <Widget>[
          new SliverAppBar(
            expandedHeight: 180.0,
            pinned: true,
            flexibleSpace: new FlexibleSpaceBar(
              title: Container(
                child: Text(details.recipeName),                
                decoration: BoxDecoration(
                  gradient: new LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.1, 0.3, 0.5, 0.7, 0.9],
                    colors: [
                      Colors.white.withOpacity(0.9),
                      Colors.white.withOpacity(0.7),
                      Colors.white.withOpacity(0.5),
                      Colors.white.withOpacity(0.3),
                      Colors.white
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
                (builder, index) => listBuilder()
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget listBuilder(){
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 10.0, bottom: 20.0),
          child: Column(
            children: <Widget>[
              Text(
                "Zutaten",
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 15.0
                ),
              ),
              ingredientsBuilder()
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 10.0, bottom: 20.0),
          child: Column(
            children: <Widget>[
              Text(
                "Zubereitung",
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 15.0
                ),
              ),
              stepsBuilder()
            ],
          ),
        )
      ],
    );
  }


  Widget ingredientsBuilder(){
    return new FutureBuilder(
      future: fetchIngredients(fetchRecipe(details.recipeName)),
      builder: (BuildContext context, snapshot){
        if(snapshot.hasData){
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index){
              return new Text("${snapshot.data[index].number}${snapshot.data[index].measure} ${snapshot.data[index].name}");
            },
          );
        }
      },
    );
  }

  Widget stepsBuilder(){
    return FutureBuilder(
      future: fetchSteps(fetchRecipe(details.recipeName)),
      builder: (BuildContext context, snapshot){
        if(snapshot.hasData){
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, index){
              return new Text(
                "${snapshot.data[index].number}. ${snapshot.data[index].description}"
              );
            },
          );
        }
      },
    );
  }
}