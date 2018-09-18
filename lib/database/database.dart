import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

import 'package:recipe/model/Recipes.dart';
import 'package:recipe/model/Ingredients.dart';
import 'package:recipe/model/Recipe_Ingredient.dart';

class DBHelper{
  static Database _db;


  /*
  * Create the database
  * */
  Future create() async{
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "recipebook.db");
    _db = await openDatabase(path, version: 1, onCreate: this._create);
  }


  /*
  * Create tables in the database
  * */
  Future _create(Database db, int version) async{
    //Create recipes table
    await db.execute(
      "CREATE TABLE recipes(" +
        "id integer primary key AUTOINCREMENT, " +
        "name varchar, " +
        "definition text, "+
        "favorite integer default 0, "+
        "timestamp text"+
      ")"
    );

    //Create ingredients table
    await db.execute(
      "CREATE TABLE ingredients(" +
        "id integer primary key AUTOINCREMENT, " +
        "name varchar, "+
        "measure varchar, "+
        "number integer "+
      ")"
    );

    //Create table between recipes and ingredients
    await db.execute(
      "CREATE TABLE recipeIngredients(" +
        "id integer primary key AUTOINCREMENT, " +
        "id_recipes real, "+
        "id_ingredients real "+
      ")"
    );

    print("Created all tables");
  }


  /*
  * Insert values into the database
  */

  Future<RecipesDB> insertRecipe(RecipesDB recipe) async{
    var count = Sqflite.firstIntValue(await _db.rawQuery("SELECT COUNT(*) FROM recipes WHERE name = ?", [recipe.name]));
    if(count == 0){
      recipe.id = await _db.insert("recipes", recipe.toMap());
    } else {
      await _db.update("recipes", recipe.toMap(), where: "id = ?", whereArgs: [recipe.id]);
    }
    return recipe;
  }

  Future<IngredientsDB> insertIngre(IngredientsDB ingre) async{
    var count = Sqflite.firstIntValue(await _db.rawQuery("SELECT COUNT(*) FROM ingredients WHERE name = ?", [ingre.name]));
    if(count == 0){
      ingre.id = await _db.insert("ingredients", ingre.toMap());
    } else {
      await _db.update("ingredients", ingre.toMap(), where: "id = ?", whereArgs: [ingre.id]);
    }
    return ingre;
  }

  Future<RecIngre> insertIngreRec(RecIngre recIngre) async{
    var count = Sqflite.firstIntValue(await _db.rawQuery("SELECT COUNT(*) FROM recipeIngredients WHERE id_recipes = ?", [recIngre.id_recipes]));
    if(count == 0){
      recIngre.id = await _db.insert("recipes", recIngre.toMap());
    } else {
      await _db.update("recipeIngredients", recIngre.toMap(), where: "id = ?", whereArgs: [recIngre.id]);
    }
    return recIngre;
  }

  //Get all Recipes
  Future<RecipesDB> get_AllRecipes() async{
    List<Map> results = await _db.query("recipes", columns: RecipesDB.columns);
    var rowNumber = Sqflite.firstIntValue(await _db.rawQuery("SELECT COUNT(*) FROM recipes"));
    var count = rowNumber;
    RecipesDB recipes;

    for(int i=0; i<=count; i++){
      recipes = RecipesDB.fromMap(results[i]);
    }

    return recipes;
  }

  //Get Ingredients of specific recipe
  Future<IngredientsDB> get_AllIngredients(int id) async{
    List<Map> results = await _db.query("ingredients", columns: RecipesDB.columns);
    String sql = "SELECT COUNT(*) FROM ingredients WHERE ingredients.id = ? AND recipeIngredients.id_recipes = ?";
    var rowNumber = Sqflite.firstIntValue(await _db.rawQuery(sql,['recipeIngredients.id_ingredients', 'recipes.id']));
    var count = rowNumber;
    IngredientsDB ingredients;

    for(int i=0; i<=count; i++){
      ingredients = IngredientsDB.fromMap(results[i]);
    }

    return ingredients;
  }




}