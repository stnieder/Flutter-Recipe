class RecIngre{
  RecIngre();

  int id, idRecipes, idIngredients;

  static final columns = ["id", "idRecipes", "idIngredients"];

  Map<String, dynamic> toMap(){
    Map<String, dynamic> map = {
      "idRecipes": idRecipes,
      "idIngredients": idIngredients
    };

    if(id != null){
      map["id"] = id;
    }

    return map;
  }

  static fromMap(Map map){
    RecIngre recIngre = new RecIngre();

    recIngre.id = map["id"];
    recIngre.idRecipes = map["idRecipes"];
    recIngre.idIngredients = map["idIngredients"];
  }
}