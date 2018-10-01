class RecIngre{
  RecIngre();

  int id, id_recipes, id_ingredients;

  static final columns = ["id", "id_ingredients", "id_ingredients"];

  Map<String, dynamic> toMap(){
    Map<String, dynamic> map = {
      "id_recipes": id_recipes,
      "id_ingredients": id_ingredients
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