import 'dart:async';
import 'dart:io';
import 'package:Time2Eat/model/ListTitle.dart';
import 'package:Time2Eat/model/RecipeTerminCombi.dart';
import 'package:Time2Eat/model/Recipe_Shopping.dart';
import 'package:Time2Eat/model/Recipe_Termine.dart';
import 'package:Time2Eat/model/Shopping.dart';
import 'package:Time2Eat/model/Shopping_Title.dart';
import 'package:Time2Eat/model/Termine.dart';
import 'package:path/path.dart';
import '../model/Recipe_Steps.dart';
import '../model/StepDescription.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

import '../model/Recipes.dart';
import '../model/Ingredients.dart';
import '../model/Recipe_Ingredient.dart';

class DBHelper{
  static Database _db;


  /*
  * Create the database
  * */
  Future create() async{
    Sqflite.setDebugModeOn(true);
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "recipebook.db");
    _db = await openDatabase(path, version: 1, onCreate: this._create);
  }


  /*
  * Create tables in the database
  * */
  Future _create(Database db, int version) async{
    await db.transaction((txn) async{
      //Create recipes table
        await txn.execute(
          "CREATE TABLE recipes(" +
            "id integer primary key AUTOINCREMENT, " +
            "name varchar, " +
            "definition text, "+
            "duration varchar, " +
            "people integer default 2, " +
            "favorite integer default 0, "+
            "timestamp text, "+
            "image real, "+
            "backgroundColor text "+
            "PRIMARY KEY(id) " + 
          ")"
        );

        //Create ingredients table
        await txn.execute(
          "CREATE TABLE ingredients(" +
            "id integer primary key AUTOINCREMENT, " +
            "name varchar, "+
            "measure varchar, "+
            "number real "+
            "PRIMARY KEY(id) " + 
          ")"
        );

        //Create steps table
        await txn.execute(
          "CREATE TABLE steps(" +
            "id integer primary key AUTOINCREMENT, " +
            "number integer, " +
            "description text "+
            "PRIMARY KEY(id) " + 
          ")"
        );

        //create termin table
        await txn.execute(
          "CREATE TABLE termine("+
            "id integer primary key AUTOINCREMENT, " +
            "termin text " +
            "PRIMARY KEY(id) " + 
          ")"
        );

        //create shopping table
        await txn.execute(
          "CREATE TABLE shopping("+
            "id integer primary key AUTOINCREMENT, " +
            "item text, "+
            "measure varchar, "+
            "number real, " +
            "checked integer, " +
            "timestamp real " +
            "PRIMARY KEY(id) " + 
          ")"
        );

        //create shopping list titles
        await txn.execute(
          "CREATE TABLE listTitles("+
            "id integer primary key AUTOINCREMENT, "+
            "titleName varchar "+
            "PRIMARY KEY(id) " + 
          ")"
        );


        //Create table between recipes and ingredients
        await txn.execute(
          "CREATE TABLE recipeIngredients(" +
            "id integer primary key AUTOINCREMENT, " +
            "idRecipes real, "+
            "idIngredients real "+
            "PRIMARY KEY(id), " + 
            "FOREIGN KEY(idRecipes) references recipes(id) ON DELETE RESTRICT ON UPDATE CASCADE, "+
            "FOREIGN KEY(idIngredients) references ingredients(id) ON DELETE RESTRICT ON UPDATE CASCADE "
          ")"
        );

        //Create table between recipes and descriptions
        await txn.execute(
            "CREATE TABLE recipeSteps(" +
              "id integer primary key AUTOINCREMENT, " +
              "idRecipes real, "+
              "idSteps real "+
              "PRIMARY KEY(id), " + 
              "FOREIGN KEY(idRecipes) references recipes(id) ON DELETE RESTRICT ON UPDATE CASCADE, "+
              "FOREIGN KEY(idSteps) references steps(id) ON DELETE RESTRICT ON UPDATE CASCADE "+
            ")"
        );

        //Create table between recipes and termine
        await txn.execute(
          "CREATE TABLE recipeTermine(" +
            "id integer primary key AUTOINCREMENT, "+
            "idRecipes real, "+
            "idTermine real "+
            "PRIMARY KEY(id), " + 
            "FOREIGN KEY(idRecipes) references recipes(id) ON DELETE RESTRICT ON UPDATE CASCADE, "+
            "FOREIGN KEY(idTermine) references termine(id) ON DELETE RESTRICT ON UPDATE CASCADE "+
          ")"
        );

        //Create table between recipes and termine
        await txn.execute(
          "CREATE TABLE recipeShopping(" +
            "id integer primary key AUTOINCREMENT, "+
            "idRecipes real, "+
            "idShopping real "+
            "PRIMARY KEY(id), " + 
            "FOREIGN KEY(idRecipes) references recipes(id) ON DELETE RESTRICT ON UPDATE CASCADE, "+
            "FOREIGN KEY(idShopping) references shopping(id) ON DELETE RESTRICT ON UPDATE CASCADE "+
          ")"
        );

        //Create table between shopping and listTitles
        await txn.execute(
          "CREATE TABLE shoppingTitles("+
            "id integer primary key AUTOINCREMENT, "+
            "idShopping real, "+
            "idTitles real "+
            "PRIMARY KEY(id), " + 
            "FOREIGN KEY(idShopping) references shopping(id) ON DELETE RESTRICT ON UPDATE CASCADE "+
            "FOREIGN KEY(idTitles) references listTitles(id) ON DELETE RESTRICT ON UPDATE CASCADE "+
          ")"
        );

        //Insert first default shopping table
        int insert = await txn.rawInsert(
          "INSERT INTO listTitles(titleName) VALUES(?)",
          ["Einkaufsliste"]
        );
        print("inserted1:$insert");

    });
    print("Created all tables");
  }


  /*
  * Delete latest record
  */
  Future deleteLatest() async{    
    await _db.rawQuery("DELETE FROM recipes WHERE id = (SELECT MAX(id) FROM recipes)");
    print("Latest record deleted!");
  }

  Future deleteListTitle(String title) async{
    await _db.transaction((txn) async{
      int listID = Sqflite.firstIntValue(
        await txn.rawQuery(
          "SELECT id FROM listTitles WHERE listTitles.titleName = ? ", 
          [title]
        )
      );

      String sql = "DELETE FROM shoppingTitles WHERE shoppingTitles.idTitles = ? ";
      await txn.rawQuery(
        sql,
        [listID]
      );

      sql = "DELETE FROM listTitles WHERE listTitles.titleName = ?";
      await txn.rawQuery(
        sql,
        [title]
      );

      print("ListTile deleted");

    });
  }

  /*
  * Check values 
  */

  Future<int> checkRecipe(String recipeName) async{
    int count = Sqflite.firstIntValue(await _db.rawQuery("SELECT COUNT(*) FROM recipes WHERE name = ?", [recipeName]));
    return count;
  }

  Future<int> checkTermine(String date) async{
    int count = Sqflite.firstIntValue(await _db.rawQuery("SELECT COUNT(*) FROM termine WHERE name = ?", [date]));
    return count;
  }

  Future<int> checkListTitle(String title) async{
    int count;
    if(title != "") Sqflite.firstIntValue(await _db.rawQuery("SELECT COUNT(*) FROM listTitles WHERE titleName = ?", [title]));
    else Sqflite.firstIntValue(await _db.rawQuery("SELECT COUNT(*) FROM listTitles"));
    return count;
  }

  Future<int> checkShoppingItems(String listName) async{
    String sql = "SELECT COUNT(*) FROM listTitles, shoppingTitles WHERE listTitles.id = shoppingTitles.idTitles AND listTitles.titleName = ?";
    int count = Sqflite.firstIntValue(await _db.rawQuery(sql, [listName]));
    return count;
  }


  /*
  * Insert values into the database
  */  

  Future<RecipesDB> insertRecipe(RecipesDB recipe) async{
    var count;
    if(recipe.id == null) count = 0;
    else count = Sqflite.firstIntValue(await _db.rawQuery("SELECT COUNT(*) FROM recipes WHERE id = ?", [recipe.id]));
    if(count == 0){
      recipe.id = await _db.insert("recipes", recipe.toMap());
    } else {
      await _db.update("recipes", recipe.toMap(), where: "id = ?", whereArgs: [recipe.id]);
    }    
    return recipe;
  }

  Future<IngredientsDB> insertIngre(IngredientsDB ingre) async{
    var count;
    if(ingre.id == null) count = 0;
    else count = Sqflite.firstIntValue(await _db.rawQuery("SELECT COUNT(*) FROM ingredients, recipes, recipeIngredients WHERE ingredients.id = ? AND ingredients.id = recipeIngredients.idIngredients AND recipeIngredients.idRecipes = recipes.id", [ingre.id]));    
    if(count == 0){
      ingre.id = await _db.insert("ingredients", ingre.toMap());
    } else {
      await _db.update("ingredients", ingre.toMap(), where: "id = ?", whereArgs: [ingre.id]);
    }
    return ingre;
  }

  Future<StepsDB> insertSteps(StepsDB steps) async{
    var count;
    if(steps.id == null) count = 0;
    else count = Sqflite.firstIntValue(await _db.rawQuery("SELECT COUNT(*) FROM steps, recipes, recipeSteps WHERE steps.id = ? AND steps.id = recipeSteps.idSteps AND recipeSteps.idRecipes = recipes.id"));
    if(count == 0){
      steps.id = await _db.insert("steps", steps.toMap());
    } else {
      await _db.update("steps", steps.toMap(), where: "id = ?", whereArgs: [steps.id]);
    }
    return steps;
  }
  
  Future<ShoppingDB> insertShopping(ShoppingDB shopping, [String titleName]) async{
    int nextID = Sqflite.firstIntValue(await _db.rawQuery("SELECT MAX(id) AS max_id FROM shopping"));
    var count = Sqflite.firstIntValue(await _db.rawQuery("SELECT COUNT(*) FROM shopping, shoppingTitles, listTitles WHERE shopping.item = ? AND shoppingTitles.idShopping = ? AND shoppingTitles.idTitles = listTitles.id AND listTitles.titleName = ?", [shopping.item, nextID, titleName]));
    if(count == 0){
      shopping.id = await _db.insert("shopping", shopping.toMap());
    } else {
      shopping.id = await _db.rawUpdate("UPDATE shopping SET number = number + ?, checked = 0 WHERE item = ?", [shopping.number, shopping.item]);
    }
    return shopping;
  }

  Future<TermineDB> insertTermine(TermineDB termine) async{
    var count;
    if(termine.id == null) count = 0;
    else count = Sqflite.firstIntValue(await _db.rawQuery("SELECT COUNT(*) FROM termine WHERE termin = ?", [termine.termin]));
    print("Termine Count: "+count.toString());
    if(count == 0){
      termine.id = await _db.insert("termine", termine.toMap());
    } else {
      termine.id = await _db.update("termine", termine.toMap(), where: "id = ?", whereArgs: [termine.id]);
    }
    return termine;
  }

  Future<ListTitleDB> insertList(ListTitleDB titles) async{
    var count;
    if(titles.id == null) count = 0;
    else count = Sqflite.firstIntValue(await _db.rawQuery("SELECT COUNT(*) FROM listTitles WHERE titleName = ?", [titles.titleName]));
    if(count == 0){
      titles.id = await _db.insert("listTitles", titles.toMap());
    } else {
      titles.id = await _db.update("listTitles", titles.toMap(), where: "id = ?", whereArgs: [titles.id]);
    }
    return titles;
  }  

  Future<RecIngre> insertRecIngre(RecIngre recIngre) async{
    var count;
    if(recIngre.id == null) count = 0;
    else count = Sqflite.firstIntValue(await _db.rawQuery("SELECT COUNT(*) FROM recipeIngredients WHERE id = ?", [recIngre.id])); 
    if(count == 0){
      recIngre.id = await _db.insert("recipeIngredients", recIngre.toMap());
    } else {
      recIngre.id = await _db.update("recipeIngredients", recIngre.toMap(), where: "id = ?", whereArgs: [recIngre.id]);
    }
    return recIngre;
  }

  Future<RecipeSteps> insertRecipeSteps(RecipeSteps recSteps) async{
    var count;
    if(recSteps.id == null) count = 0;
    else count = Sqflite.firstIntValue(await _db.rawQuery("SELECT COUNT(*) FROM recipeSteps WHERE id = ?", [recSteps.id])); 
    if(count == 0){
      recSteps.id = await _db.insert("recipeSteps", recSteps.toMap());   
    } else {
      recSteps.id = await _db.update("recipeSteps", recSteps.toMap(), where: "id = ?", whereArgs: [recSteps.id]);
    }    
    return recSteps;
  }

  Future<RecipeTermine> insertRecipeTermine(RecipeTermine recTermine) async{
    var count;
    if(recTermine.id == null) count = 0;
    else count = Sqflite.firstIntValue(await _db.rawQuery("SELECT COUNT(*) FROM recipeTermine WHERE id = ?", [recTermine.id]));
    if(count == 0){
      recTermine.id = await _db.insert("recipeTermine", recTermine.toMap());
    } else {
      recTermine.id = await _db.update("recipeTermine", recTermine.toMap(), where:  "id = ?", whereArgs: [recTermine.id]);
    }
    return recTermine;
  }

  Future<RecipeShopping> insertRecipeShopping(RecipeShopping recShop) async{
    var count;
    if(recShop.id == null) count = 0;
    else count = Sqflite.firstIntValue(await _db.rawQuery("SELECT COUNT(*) FROM recipeShopping WHERE id = ?", [recShop.id]));
    if(count == 0){
      recShop.id = await _db.insert("recipeShopping", recShop.toMap());
    } else {
      recShop.id = await _db.update("recipeTermine", recShop.toMap(), where:  "id = ?", whereArgs: [recShop.id]);
    }
    return recShop;
  }

  Future<ShoppingTitlesDB> insertShoppingTitles(ShoppingTitlesDB shopTitles) async{
    var count;
    if(shopTitles.id == null) count = 0;
    else count = Sqflite.firstIntValue(await _db.rawQuery("SELECT COUNT(*) FROM shoppingTitles WHERE id = ?", [shopTitles.id]));
    if(count == 0){
      shopTitles.id = await _db.insert("shoppingTitles", shopTitles.toMap());
    } else {
      shopTitles.id = await _db.update("shoppingTitles", shopTitles.toMap(), where:  "id = ?", whereArgs: [shopTitles.id]);
    }
    return shopTitles;
  }


  //Get all Recipes
  Future<List<Recipes>> getRecipes() async{
    List<Map> list = await _db.rawQuery("SELECT * FROM recipes ORDER BY name DESC");
    List<Recipes> recipes = new List();
    for(int i =0; i < list.length; i++){
      recipes.add(new Recipes(id: list[i]["id"],name: list[i]["name"],definition: list[i]["definition"],duration:  list[i]["duration"], favorite:  list[i]["favorite"], timestamp: list[i]["timestamp"], image: list[i]["image"],backgroundColor: list[i]["backgroundColor"]));
    }
    return recipes;
  }  

  //Get Specific Recipe
  Future<List<Recipes>> getSpecRecipe(String recipeName) async{
    List<Map> list = await _db.rawQuery("SELECT * FROM recipes WHERE name = ?", [recipeName]);
    List<Recipes> recipes = new List();
    for(int i =0; i < list.length; i++){
      recipes.add(new Recipes(id: list[i]["id"],name: list[i]["name"],definition: list[i]["definition"],duration:  list[i]["duration"], favorite:  list[i]["favorite"], timestamp: list[i]["timestamp"], image: list[i]["image"],backgroundColor: list[i]["backgroundColor"]));
    }   
    return recipes;
  }

  Future<int> countRecipes() async{
    List<Map> list = await _db.rawQuery("SELECT * FROM recipes");
    return list.length;
  }

  //Get Ingredients of specific recipe
  Future<List<Ingredients>> getIngredients(String recipeName) async{
    String sql = "SELECT ingredients.name, ingredients.number, ingredients.measure FROM ingredients, recipes, recipeIngredients WHERE recipes.name = '"+recipeName+"' AND recipes.id = recipeIngredients.idRecipes AND recipeIngredients.idIngredients = ingredients.id";
    List<Map> list = await _db.rawQuery(sql);
    List<Ingredients> ingredients = new List();
    for(int i =0; i<list.length; i++){
      print("IngredientName: "+list[i]["name"]);
      ingredients.add(new Ingredients(list[i]["id"], list[i]["name"], list[i]["number"].toString(), list[i]["measure"]));
    }
    return ingredients;
  }

  //Get Steps of specific recipe
  Future<List<Steps>> getSteps(String recipeName) async{
    String sql = "SELECT steps.number, steps.description FROM steps, recipes, recipeSteps WHERE recipes.name = '"+recipeName+"' AND recipes.id = recipeSteps.idRecipes AND recipeSteps.idSteps = steps.id";
    List<Map> list = await _db.rawQuery(sql);
    List<Steps> steps = new List();
    for(int i =0; i<list.length; i++){
      steps.add(new Steps(list[i]["id"], list[i]["number"], list[i]["description"]));
    }
    return steps;
  }

  //Get Shopping list
  Future<List<Shopping>> getShopping(String order, String title) async{
    if(order == "abc") order = "item ASC";
    String sql = 
    "SELECT shopping.item, shopping.measure, shopping.number, shopping.checked, shopping.timestamp, recipes.name " + 
    "FROM shopping, recipes, recipeShopping, shoppingTitles, listTitles " + 
    "WHERE recipes.id = recipeShopping.idRecipes "+ 
    "AND recipeShopping.idShopping = shopping.id "+
    "AND shopping.id = shoppingTitles.idShopping "+
    "AND shoppingTitles.idTitles = listTitles.id "+
    "AND listTitles.titleName = ? "+
    "ORDER BY shopping.checked, shopping."+order;

    List<Map> list = await _db.rawQuery(sql, [title]);
    List<Shopping> shopping = new List();
    for(int i=0; i<list.length; i++){
      shopping.add(new Shopping(list[i]["id"], list[i]["item"], list[i]["number"].toString(), list[i]["measure"], list[i]["checked"], list[i]["timestamp"]));
    }
    return shopping;
  }

  //Get checked shopping items
  Future<int> countCheckedItems(String order, String title) async{
    if(order == "abc") order = "item ASC";
    String sql = 
    "SELECT COUNT(*) " + 
    "FROM shopping, recipes, recipeShopping, shoppingTitles, listTitles " + 
    "WHERE recipes.id = recipeShopping.idRecipes "+ 
    "AND recipeShopping.idShopping = shopping.id "+
    "AND shopping.id = shoppingTitles.idShopping "+
    "AND shoppingTitles.idTitles = listTitles.id "+
    "AND listTitles.titleName = ? "+
    "AND shopping.checked = ? "+
    "ORDER BY shopping.checked, shopping."+order;

    int count = Sqflite.firstIntValue(await _db.rawQuery(sql, [title, 1]));
    print("CountTitles: "+count.toString());
    return count;
  }

  //Get Termine of specific date
  Future<List> getTermine(String date) async{
    String sql = "SELECT termine.termin, recipes.name, recipes.image FROM termine, recipeTermine, recipes WHERE termine.termin = '"+date+"' AND termine.id = recipeTermine.idTermine AND recipeTermine.idRecipes = recipes.id";
    List<Map> list = await _db.rawQuery(sql);
    List termine = new List();
    for (int i=0; i<list.length; i++) {
      termine.add(new RecipeTerminCombi(list[i]["termin"], list[i]["name"], list[i]["image"]));
    }
    print("TerminAnzahl: "+termine.length.toString());
    return termine;
  }

  //Get all List titles
  Future<List<ListTitle>> getListTitles() async{
    String sql = "SELECT * FROM listTitles";
    List<Map> list = await _db.rawQuery(sql);
    List<ListTitle> titles = new List();
    for(int i=0; i<list.length; i++){
      titles.add(new ListTitle(list[i]["id"], list[i]["titleName"]));
    }
    return titles;
  }

  //Count list titles
  Future<int> countTitles(String title) async{
    String sql;
    List<Map> list = new List();
    if(title != "") {
      sql = "SELECT COUNT(*) FROM listTitles WHERE listTitles.titleName = ?";
      list = await _db.rawQuery(sql, [title]);
    }
    else {
      sql = "SELECT COUNT(*) FROM listTitles";
      list = await _db.rawQuery(sql);      
    }
    
    return list.length;
  }

  //Update list title
  Future<int> updateTitle(String newTitle, String oldTitle) async{
    String sql = "UPDATE listTitles SET titleName = ? WHERE titleName = ?";
    int count = await _db.rawUpdate(sql, [newTitle, oldTitle]);
    return count;
  }

  /*
  * Filter with specific parameter
  */

  //Filter with recipe name
  Future<List<Recipes>> filterRecipes(String recipe) async{
    String sql = "SELECT * FROM recipes WHERE name LIKE '%"+recipe+"%'";
    List<Map> list = await _db.rawQuery(sql);
    List<Recipes> recipes = new List();
    for(int i =0; i < list.length; i++){
      recipes.add(new Recipes(id: list[i]["id"],name: list[i]["name"],definition: list[i]["definition"],duration:  list[i]["duration"], favorite:  list[i]["favorite"], timestamp: list[i]["timestamp"], image: list[i]["image"],backgroundColor: list[i]["backgroundColor"]));
    }
    return recipes;
  }

  //Get only list title
  Future<List<String>> filterListTitle() async{
    String sql = "SELECT titleName FROM listTitles";
    List<Map> list = await _db.rawQuery(sql);
    List<String> titles = new List();
    for(int i=0; i < list.length; i++){
      titles.add(list[i]["titleName"]);
    }

    return titles;
  }

  //Get ListTitle ID
  Future<int> getTitleID(String title) async{
    String sql = "SELECT id FROM listTitles WHERE titleName = ?";
    List<Map> list = await _db.rawQuery(sql, [title]);
    int id = list[0]["id"];
    return id;    
  }



  //Update favorite recipe
  Future<int> updateFavorite(String recipeName, int newFavorite) async{
    String sql = "UPDATE recipes SET favorite = ? WHERE name = ?";
    return await _db.rawUpdate(
      sql,
      [newFavorite, recipeName]
    );
  }

  //Update shopping item
  Future<int> updateShopItem(String item, String timestamp, int checked) async{
    String sql = "UPDATE shopping SET checked = ?, timestamp = ? WHERE item = ? AND timestamp = ?";
    int count = await _db.rawUpdate(sql, [checked.toString(), DateTime.now().toString(), item, timestamp]);
    return count;
  }
}