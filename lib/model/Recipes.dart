import 'dart:convert';

class RecipesDB{
  RecipesDB();

  int id, favorite, backgroundColor;
  dynamic image;
  String name, definition, timestamp, duration;

  static final columns = ["id", "name", "definition","duration", "favorite", "timestamp", "image", "backgroundColor"];

  Map<String, dynamic> toMap(){
    Map<String, dynamic> map = {
      "name": name,
      "definition": definition,      
      "duration": duration,
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
    recipes.duration = map["duration"];
    recipes.favorite = map["favorite"];
    recipes.timestamp = map["timestamp"];
    recipes.image = map["image"];
    recipes.backgroundColor = map["backgroundColor"];

    return recipes;
  }
}


class Recipes{
  int id, favorite, backgroundColor;
  dynamic image;
  String name, definition, timestamp, duration;

  Recipes(this.name, this.definition, this.duration, this.favorite, this.timestamp, this.image, this.backgroundColor);
}