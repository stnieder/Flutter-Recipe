import 'dart:convert';

class RecIngre{
  RecIngre();

  int id, id_recipes, id_ingredients;

  static final columns = ["id", "id_ingredients", "id_ingredients"];

  Map toMap(){
    Map map = {
      "id_recipes": id_recipes,
      "number": id_ingredients
    };

    if(id != null){
      map["id"] = id;
    }

    return map;
  }

  static fromMap(Map map){
    RecIngre recIngre = new RecIngre();

    recIngre.id = map["id"];
    recIngre.id_recipes = map["id_recipes"];
    recIngre.id_ingredients = map["id_ingredients"];
  }
}