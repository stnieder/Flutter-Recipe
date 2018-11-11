class RecipeTermine{
  RecipeTermine();

  int id, idRecipes, idTermine;

  static final columns = ["id", "idRecipes", "idTermine"];

  Map<String, dynamic> toMap(){
    Map<String, dynamic> map = {
      "idRecipes": idRecipes,
      "idTermine": idTermine
    };

    if(id != null){
      map["id"] = id;
    }

    return map;
  }

  static fromMap(Map map){
    RecipeTermine recTer = new RecipeTermine();

    recTer.id = map["id"];
    recTer.idRecipes = map["idRecipes"];
    recTer.idTermine = map["idIngredients"];
  }
}