class RecipeTermine{
  RecipeTermine();

  int id, idRecipes, idTermine, intervallTyp;
  String createdTimestamp;

  static final columns = ["id", "idRecipes", "idTermine", "intervallTyp", "createTimestamp"];

  Map<String, dynamic> toMap(){
    Map<String, dynamic> map = {
      "idRecipes": idRecipes,
      "idTermine": idTermine,
      "intervallTyp": intervallTyp,
      "createTimestamp": createdTimestamp
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
    recTer.intervallTyp = map["intervallTyp"];
    recTer.createdTimestamp = map["createTimestamp"];
  }
}