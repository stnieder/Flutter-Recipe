import 'package:flutter/foundation.dart';

class RecipesDB{
  RecipesDB();

  int id, favorite;
  String image;
  String name, definition, timestamp, pre_duration, cre_duration, resting_time,  people, backgroundColor;

  static final columns = ["id", "name", "definition","pre_duration", "cre_duration", "resting_time", "people", "favorite", "timestamp", "image", "backgroundColor"];

  Map<String, dynamic> toMap(){
    Map<String, dynamic> map = {
      "name": name,
      "definition": definition,      
      "pre_duration": pre_duration,
      "cre_duration": cre_duration,
      "resting_time": resting_time,
      "people": people,
      "favorite": favorite,
      "timestamp": timestamp,
      "image": image,
      "backgroundColor": backgroundColor
    };

    if(id != null){
      map["id"] = id;
    }

    return map;
  }

  static fromMap(Map map){
    RecipesDB recipes = new RecipesDB();

    recipes.id = map["id"];
    recipes.name = map["name"];
    recipes.definition = map["definition"];
    recipes.pre_duration = map["pre_duration"];
    recipes.cre_duration = map["cre_duration"];
    recipes.resting_time = map["resting_time"];
    recipes.people = map["people"];
    recipes.favorite = map["favorite"];
    recipes.timestamp = map["timestamp"];
    recipes.image = map["image"];
    recipes.backgroundColor = map["backgroundColor"];

    return recipes;
  }
}


class Recipes{
  int id, favorite;
  String image;
  String name, definition, timestamp, pre_duration, cre_duration, resting_time, people, backgroundColor;

  Recipes(
    {
      @required this.id, 
      this.name, 
      this.definition, 
      this.pre_duration,
      this.cre_duration,
      this.resting_time,
      this.people,
      this.favorite, 
      this.timestamp, 
      this.image, 
      this.backgroundColor
    }
  );
}