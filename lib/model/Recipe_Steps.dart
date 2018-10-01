import 'dart:convert';

class RecipeSteps{
  RecipeSteps();

  int id, id_recipes, id_steps;

  static final columns = ["id", "id_ingredients", "id_steps"];

  Map<String, dynamic> toMap(){
    Map<String, dynamic> map = {
      "id_recipes": id_recipes,
      "id_steps": id_steps
    };

    if(id != null){
      map["id"] = id;
    }

    return map;
  }

  static fromMap(Map map){
    RecipeSteps recipeSteps = new RecipeSteps();

    recipeSteps.id = map["id"];
    recipeSteps.id_recipes = map["id_recipes"];
    recipeSteps.id_steps = map["id_steps"];
  }
}