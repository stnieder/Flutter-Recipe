import 'dart:convert';

class RecipesDB{
  RecipesDB();

  int id, favorite;
  String name, definition, timestamp;

  static final columns = ["id", "name", "definition", "favorite", "timestamp"];

  Map toMap(){
    Map map = {
      "name": name,
      "definition": definition,
      "favorite": favorite,
      "timestamp": timestamp
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
    recipes.favorite = map["favorite"];
    recipes.timestamp = map["timestamp"];

    return recipes;
  }

}