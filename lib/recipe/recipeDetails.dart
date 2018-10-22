import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sliver_fab/sliver_fab.dart';
import 'package:recipe/database/database.dart';
import 'package:recipe/model/Ingredients.dart';
import 'package:recipe/model/StepDescription.dart';


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
  int portionen=1;

  @override
    void initState() {
      super.initState();      
    }

  @override
  Widget build(BuildContext context) {
    recipe = details.recipeName;        

    return new Scaffold(
      appBar: AppBar(
        title: Text(recipe),
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
          Expanded(
            child: FutureBuilder(
              future: fetchIngredients(),
              initialData: [],
              builder: (BuildContext context, AsyncSnapshot snapshot){
                if(snapshot.hasData){
                  return new ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index){
                      return Row(
                        children: <Widget>[
                          Text(snapshot.data[index].number.toString()),
                          Text(snapshot.data[index].measure),
                          Text(snapshot.data[index].name)
                        ],
                      );
                    },
                  );
                } else if(snapshot.hasError){
                  return new Text("Keine Daten vorhanden.");
                }
                return new CircularProgressIndicator();
              },
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: fetchSteps(),
              initialData: [],
              builder: (BuildContext context, AsyncSnapshot snapshot){
                if(snapshot.hasData){
                  return new ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index){
                      return Row(
                        children: <Widget>[
                          Text(snapshot.data[index].number.toString()),
                          Text(snapshot.data[index].description)
                        ],
                      );                      
                    },
                  );
                } else if(snapshot.hasError){
                  return new Text("Keine Daten vorhanden.");
                }
                return new CircularProgressIndicator();
              },
            ),
          )
        ],
      )
    );
  }

  Future<List<Ingredients>> fetchIngredients() async{
    DBHelper dbHelper = new DBHelper();
    var parsedIngredients = await dbHelper.getIngredients(recipe);
    List<Ingredients> ingredients = List<Ingredients>();    
    for(int i=0; i< parsedIngredients.length; i++){
      ingredients.add(parsedIngredients[i]);           
    }    
    print("Ingredients-Anzahl: "+ingredients.length.toString());
    return ingredients;
  }

  Future<List<Steps>> fetchSteps() async{
    DBHelper dbHelper = new DBHelper();
    var parsedSteps = await dbHelper.getSteps(recipe);
    List<Steps> steps = List<Steps>();
    for(int i=0; i < parsedSteps.length; i++){
      steps.add(parsedSteps[i]);
    }
    print("Steps-Anzahl: "+steps.length.toString());
    return steps;
  }
}