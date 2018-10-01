import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:recipe/model/Recipe_Steps.dart';
import 'package:recipe/model/StepDescription.dart';
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
    await Sqflite.devSetDebugModeOn(true);
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
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
        "duration varchar, " +
        "favorite integer default 0, "+
        "timestamp text, "+
        "image real, "+
        "backgroundColor integer "+
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

    //Create steps table
    await db.execute(
      "CREATE TABLE steps(" +
        "id integer primary key AUTOINCREMENT, " +
        "number integer, "
        "description text "+
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

    //Create table between recipes and descriptions
    await db.execute(
        "CREATE TABLE recipeSteps(" +
          "id integer primary key AUTOINCREMENT, " +
          "id_recipes real, "+
          "id_steps real "+
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

  Future<StepsDB> insertSteps(StepsDB steps) async{
    var count = Sqflite.firstIntValue(await _db.rawQuery("SELECT COUNT(*) FROM steps WHERE description = ?", [steps.description]));
    if(count == 0){
      steps.id = await _db.insert("steps", steps.toMap());
    } else {
      await _db.update("steps", steps.toMap(), where:  "id = ?", whereArgs: [steps.id]);
    }
    return steps;
  }

  Future<RecIngre> insertRecIngre(RecIngre recIngre) async{
    var count = Sqflite.firstIntValue(await _db.rawQuery("SELECT COUNT(*) FROM recipeIngredients WHERE id_recipes = ?", [recIngre.id_recipes]));
    if(count == 0){
      recIngre.id = await _db.insert("recipeIngredients", recIngre.toMap());
    } else {
      await _db.update("recipeIngredients", recIngre.toMap(), where: "id = ?", whereArgs: [recIngre.id]);
    }
    return recIngre;
  }

  Future<RecipeSteps> insertRecipeSteps(RecipeSteps recSteps) async{
    var count = Sqflite.firstIntValue(await _db.rawQuery("SELECT COUNT(*) FROM recipeSteps WHERE id_recipes = ?", [recSteps.id_recipes]));
    if(count == 0){
      recSteps.id = await _db.insert("recipeSteps", recSteps.toMap());
    } else {
      await _db.update("recipeSteps", recSteps.toMap(), where: "id = ?", whereArgs: [recSteps.id]);
    }
    return recSteps;
  }

  //Get all Recipes
  Future<List<Recipes>> getRecipes() async{
    List<Map> list = await _db.rawQuery("SELECT * FROM recipes");
    List<Recipes> recipes = new List();
    for(int i =0; i < list.length; i++){
      recipes.add(new Recipes(list[i]["name"], list[i]["definition"], list[i]["duration"], list[i]["favorite"], list[i]["timestamp"], list[i]["image"], list[i]["backgroundColor"]));      
    }
    print("------------------------------------------Anzahl Rezepte: "+recipes.length.toString());
    return recipes;
  }

  //Get Ingredients of specific recipe
  Future<IngredientsDB> getIngredients(int recipesID) async{
    List<Map> results = await _db.query("ingredients", columns: RecipesDB.columns);
    String sql = "SELECT * FROM ingredients WHERE ingredients.id = ? AND recipeIngredients.id_recipes = ?";
    var rowNumber = Sqflite.firstIntValue(await _db.rawQuery(sql,['recipeIngredients.id_ingredients', recipesID]));
    var count = rowNumber;
    IngredientsDB ingredients;

    for(int i=0; i<=count; i++){
      ingredients = IngredientsDB.fromMap(results[i]);
    }

    return ingredients;
  }

  //Get Steps of specific recipe
  Future<StepsDB> getSteps(int recipesID) async{
    List<Map> results= await _db.query("steps", columns: RecipesDB.columns);
    String sql = "SELECT * FROM steps WHERE steps.id = ? AND recipes.id = ?";
    var rowNumber = Sqflite.firstIntValue(await _db.rawQuery(sql, ["recipeSteps.id_steps", recipesID]));
    var count = rowNumber;

    StepsDB steps;
    for(int i=0; i<=count; i++){
      steps = StepsDB.fromMap(results[i]);
    }

    return steps;
  }
}