import 'dart:convert';

class RecDesc{
  RecDesc();

  int id, id_recipes, id_descriptions;

  static final columns = ["id", "id_ingredients", "id_descriptions"];

  Map toMap(){
    Map map = {
      "id_recipes": id_recipes,
      "id_descriptions": id_descriptions
    };

    if(id != null){
      map["id"] = id;
    }

    return map;
  }

  static fromMap(Map map){
    RecDesc recDesc = new RecDesc();

    recDesc.id = map["id"];
    recDesc.id_recipes = map["id_recipes"];
    recDesc.id_descriptions = map["id_descriptions"];
  }
}