class RecipeSteps{
  RecipeSteps();

  int id, idRecipes, idSteps;

  static final columns = ["id", "idRecipes", "idSteps"];

  Map<String, dynamic> toMap(){
    Map<String, dynamic> map = {
      "idRecipes": idRecipes,
      "idSteps": idSteps
    };

    if(id != null){
      map["id"] = id;
    }

    return map;
  }

  static fromMap(Map map){
    RecipeSteps recipeSteps = new RecipeSteps();

    recipeSteps.id = map["id"];
    recipeSteps.idRecipes = map["idRecipes"];
    recipeSteps.idSteps = map["idSteps"];
  }
}
