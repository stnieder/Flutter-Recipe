import 'dart:async';

import 'package:flutter/material.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:recipe/database/database.dart';
import 'package:recipe/interface/GoogleColors.dart';
import 'package:recipe/model/Ingredients.dart';
import 'package:recipe/model/Recipes.dart';
import 'package:recipe/model/StepDescription.dart';


class RecipeDetails extends StatefulWidget{
  final String recipeName;
  RecipeDetails(this.recipeName);

  @override
    State<StatefulWidget> createState() {
      return new _RecipeDetails();
    }
}

class _RecipeDetails extends State<RecipeDetails>{
  GoogleMaterialColors googleMaterialColors = new GoogleMaterialColors();

  
  String recipeName = "";
  int portionen=1;
  bool titleVisibility = false;

  @override
    void initState() {
      super.initState();      
      recipeName = widget.recipeName; 
    }

  @override
  Widget build(BuildContext context) {          
    return new Scaffold(
      appBar: AppBar(        
        actions: <Widget>[
          FutureBuilder(
            future: fetchRecipe(),
            initialData: [],
            builder: (BuildContext context, AsyncSnapshot snapshot){
              if(snapshot.hasData){

                int favorite = snapshot.data[0].favorite;

                return IconButton(
                  icon: ( favorite == 0
                    ? Icon(Icons.star_border, color: Colors.black54)
                    : Icon(Icons.star, color: Colors.black54)
                  ),
                  onPressed: (){
                    setState(() {
                      updateFavorite(favorite);
                    });
                  },
                );
              } else if(snapshot.hasError){

                return Text("");
              }
              return Icon(Icons.check_box_outline_blank, color: Colors.black54);
            },
          )
        ],
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0.0,        
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color:  Colors.black54),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        title: Opacity(
          opacity: (titleVisibility
            ? 0.0
            : 1.0
          ),
          child: Text(recipeName),
        ),
      ),
      body: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.remove),
                onPressed: (){
                  setState((){
                    if(portionen > 1)
                    portionen--;
                  });
                },
              ),
              Text(
                portionen == 1
                  ? "1 Portion"
                  : portionen.toString()+" Portionen"
              ),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: (){
                  setState((){
                    portionen++;
                  });
                },
              )
            ],
          ),
          FutureBuilder(
            future: fetchIngredients(),
            initialData: [],
            builder: (BuildContext context, AsyncSnapshot snapshot){
              if(snapshot.hasData){
                List<Text> numberList = new List();
                List<Text> measureList = new List();
                List<Text> nameList = new List();

                List<Widget> ingredients = new List();

                for(int i=0; i < snapshot.data.length; i++){
                  numberList.add(Text((double.parse(snapshot.data[i].number)*portionen).toString()));
                  measureList.add(Text(snapshot.data[i].measure));
                  nameList.add(Text(snapshot.data[i].name));
                }
                
                for(int i=0; i< numberList.length; i++){
                  ingredients.add(
                    Row(
                      children: <Widget>[
                        numberList[i],
                        measureList[i],
                        nameList[i]
                      ],
                    )
                  );
                }
                
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: ingredients,
                );
                
              } else if(snapshot.hasError){
                return new Text("Keine Daten vorhanden.");
              }
              return new CircularProgressIndicator();
            },
          ),
          FutureBuilder(
            future: fetchSteps(),
            initialData: [],
            builder: (BuildContext context, AsyncSnapshot snapshot){
              if(snapshot.hasData){
                List<Text> numberList = new List();
                List<Text> descriptionList = new List();

                List<Widget> steps = new List();

                for(int i=0; i < snapshot.data.length; i++){
                  numberList.add(Text(snapshot.data[i].number.toString()));
                  descriptionList.add(Text(snapshot.data[i].description));
                }
                
                for(int i=0; i< numberList.length; i++){
                  steps.add(
                    Row(
                      children: <Widget>[
                        numberList[i],
                        descriptionList[i]
                      ],
                    )
                  );
                }
                
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: steps,
                );
              } else if(snapshot.hasError){
                return new Text("Keine Daten vorhanden.");
              }
              return new CircularProgressIndicator();
            },
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: googleMaterialColors.primaryColor(),
        child: Icon(
          OMIcons.create
        ),
        onPressed: (){},
      ),
      
    );
  }

  Future<List<Recipes>> fetchRecipe() async{
    DBHelper dbHelper = new DBHelper();
    var parsedRecipe = await dbHelper.getSpecRecipe(recipeName);
    List<Recipes> recipe = List<Recipes>();
    for(int i=0; i < parsedRecipe.length; i++){
      recipe.add(parsedRecipe[i]);
    }
    return recipe;
  }

  Future<int> updateFavorite(int favorite)async{
    if(favorite == 0) favorite = 1;
    else if(favorite == 1) favorite = 0;
    print("Updated favorite("+favorite.toString()+")");
    DBHelper dbHelper = new DBHelper();
    int updated = await dbHelper.updateFavorite(recipeName, favorite);
    return updated;
  }

  Future<List<Ingredients>> fetchIngredients() async{
    DBHelper dbHelper = new DBHelper();
    var parsedIngredients = await dbHelper.getIngredients(recipeName);
    List<Ingredients> ingredients = List<Ingredients>();    
    for(int i=0; i< parsedIngredients.length; i++){
      ingredients.add(parsedIngredients[i]);           
    }    
    print("Ingredients-Anzahl: "+ingredients.length.toString());
    return ingredients;
  }

  Future<List<Steps>> fetchSteps() async{
    DBHelper dbHelper = new DBHelper();
    var parsedSteps = await dbHelper.getSteps(recipeName);
    List<Steps> steps = List<Steps>();
    for(int i=0; i < parsedSteps.length; i++){
      steps.add(parsedSteps[i]);
    }
    print("Steps-Anzahl: "+steps.length.toString());
    return steps;
  }
}