class RecipeShopping{
  RecipeShopping();

  int id, idRecipes, idShopping;

  static final columns = ["id", "idRecipes", "idShopping"];

  Map<String, dynamic> toMap(){
    Map<String, dynamic> map = {
      "idRecipes": idRecipes,
      "idShopping": idShopping
    };

    if(id != null){
      map["id"] = id;
    }

    return map;
  }

  static fromMap(Map map){
    RecipeShopping recShop = new RecipeShopping();

    recShop.id = map["id"];
    recShop.idRecipes = map["idRecipes"];
    recShop.idShopping = map["idShopping"];
  }
}