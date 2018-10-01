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
        "idRecipes real, "+
        "idIngredients real "+
      ")"
    );

    //Create table between recipes and descriptions
    await db.execute(
        "CREATE TABLE recipeSteps(" +
          "id integer primary key AUTOINCREMENT, " +
          "idRecipes real, "+
          "idSteps real "+
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
    var count = Sqflite.firstIntValue(await _db.rawQuery("SELECT COUNT(*) FROM recipeIngredients WHERE idRecipes = ?", [recIngre.idRecipes]));
    if(count == 0){
      recIngre.id = await _db.insert("recipeIngredients", recIngre.toMap());
    } else {
      await _db.update("recipeIngredients", recIngre.toMap(), where: "id = ?", whereArgs: [recIngre.id]);
    }
    return recIngre;
  }

  Future<RecipeSteps> insertRecipeSteps(RecipeSteps recSteps) async{
    var count = Sqflite.firstIntValue(await _db.rawQuery("SELECT COUNT(*) FROM recipeSteps WHERE idRecipes = ?", [recSteps.idRecipes]));
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
      recipes.add(new Recipes(list[i]["id"], list[i]["name"], list[i]["definition"], list[i]["duration"], list[i]["favorite"], list[i]["timestamp"], list[i]["image"], list[i]["backgroundColor"]));      
    }
    print("------------------------------------------Anzahl Rezepte: "+recipes.length.toString());
    return recipes;
  }

  //Get Specific Recipe
  Future<List<Recipes>> getSpecRecipe(String recipeName) async{
    List<Map> list = await _db.query("recipes", columns: RecipesDB.columns, where: "name", whereArgs: [recipeName]);
    List<Recipes> recipes = new List();
    if(list.length > 1){
      recipes.add(new Recipes(list[0]["id"],list[0]["name"], list[0]["definition"], list[0]["duration"], list[0]["favorite"], list[0]["timestamp"], list[0]["image"], list[0]["backgroundColor"]));
    } 
    else if(list.length == 1){ 
      for(int i =0; i < list.length; i++){
        recipes.add(new Recipes(list[i]["id"], list[i]["name"], list[i]["definition"], list[i]["duration"], list[i]["favorite"], list[i]["timestamp"], list[i]["image"], list[i]["backgroundColor"]));      
      }
    }    
    return recipes;
  }

  //Get Ingredients of specific recipe
  Future<List<Ingredients>> getIngredients(int recipesID) async{
    List<Map> results = await _db.query("ingredients", columns: RecipesDB.columns);
    String sql = "SELECT * FROM ingredients WHERE recipes.id = ? AND recipeIngredients.idIngredients = ? AND recipes.id = ?";
    var rowNumber = Sqflite.firstIntValue(await _db.rawQuery(sql,["recipeIngredients.idRecipes", "ingredients.id", recipesID]));
    var count = rowNumber;
    List<Ingredients> ingredients = new List();

    for(int i=0; i<=count; i++){
      ingredients.add(new Ingredients(results[i]["id"], results[i]["name"], results[i]["number"], results[i]["measure"]));
    }

    return ingredients;
  }

  //Get Steps of specific recipe
  Future<List<Steps>> getSteps(int recipesID) async{
    List<Map> results= await _db.query("steps", columns: RecipesDB.columns);
    String sql = "SELECT * FROM steps WHERE recipes.id = ? AND recipeSteps.idSteps = ? AND recipes.id";
    var rowNumber = Sqflite.firstIntValue(await _db.rawQuery(sql, ["recipeSteps.idRecipes", "steps.id", recipesID]));
    var count = rowNumber;

    List<Steps> steps;
    for(int i=0; i<=count; i++){
      steps.add(new Steps(results[i]["id"], results[i]["number"], results[i]["description"]));
    }

    return steps;
  }
}