import 'dart:async';
import 'dart:io';
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
        "backgroundColor text "+
      ")"
    );

    //Create ingredients table
    await db.execute(
      "CREATE TABLE ingredients(" +
        "id integer primary key AUTOINCREMENT, " +
        "name varchar, "+
        "measure varchar, "+
        "number real "+
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
  * Delete latest record
  */
  Future deleteLatest() async{    
    await _db.rawQuery("DELETE FROM recipes WHERE id = (SELECT MAX(id) FROM recipes)");
    print("Latest record deleted!");
  }


  /*
  * Insert values into the database
  */

  Future<RecipesDB> insertRecipe(RecipesDB recipe) async{
    var count = Sqflite.firstIntValue(await _db.rawQuery("SELECT COUNT(*) FROM recipes WHERE id = ?", [recipe.id]));    
    if(count == 0){
      recipe.id = await _db.insert("recipes", recipe.toMap());
    } else {
      await _db.update("recipes", recipe.toMap(), where: "id = ?", whereArgs: [recipe.id]);
    }    
    return recipe;
  }

  Future<IngredientsDB> insertIngre(IngredientsDB ingre) async{
    var count = Sqflite.firstIntValue(await _db.rawQuery("SELECT COUNT(*) FROM ingredients, recipes, recipeIngredients WHERE ingredients.id = ? AND ingredients.id = recipeIngredients.idIngredients AND recipeIngredients.idRecipes = recipes.id", [ingre.id]));    
    if(count == 0){
      ingre.id = await _db.insert("ingredients", ingre.toMap());
    } else {
      await _db.update("ingredients", ingre.toMap(), where: "id = ?", whereArgs: [ingre.id]);
    }
    return ingre;
  }

  Future<StepsDB> insertSteps(StepsDB steps) async{
    var count = Sqflite.firstIntValue(await _db.rawQuery("SELECT COUNT(*) FROM steps, recipes, recipeSteps WHERE steps.id = ? AND steps.id = recipeSteps.idSteps AND recipeSteps.idRecipes = recipes.id"));
    if(count == 0){
      steps.id = await _db.insert("steps", steps.toMap());
    } else {
      await _db.update("steps", steps.toMap(), where: "id = ?", whereArgs: [steps.id]);
    }
    return steps;
  }

  Future<RecIngre> insertRecIngre(RecIngre recIngre) async{
    var count = Sqflite.firstIntValue(await _db.rawQuery("SELECT COUNT(*) FROM recipeIngredients WHERE id = ?", [recIngre.id]));
    if(count == 0){
      recIngre.id = await _db.insert("recipeIngredients", recIngre.toMap());
    } else {
      await _db.update("recipeIngredients", recIngre.toMap(), where: "id = ?", whereArgs: [recIngre.id]);
    }
    return recIngre;
  }

  Future<RecipeSteps> insertRecipeSteps(RecipeSteps recSteps) async{
    var count = Sqflite.firstIntValue(await _db.rawQuery("SELECT COUNT(*) FROM recipeSteps WHERE id = ?", [recSteps.id]));
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
      recipes.add(new Recipes(id: list[i]["id"],name: list[i]["name"],definition: list[i]["definition"],duration:  list[i]["duration"], favorite:  list[i]["favorite"], timestamp: list[i]["timestamp"], image: list[i]["image"],backgroundColor: list[i]["backgroundColor"]));
    }
    return recipes;
  }  

  //Get Specific Recipe
  Future<List<Recipes>> getSpecRecipe(String recipeName) async{
    List<Map> list = await _db.rawQuery("SELECT * FROM recipes WHERE name = ?", [recipeName]);
    print("Length SpecRecipe: "+list.length.toString());
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


  //Update favorite recipe
  Future<int> updateFavorite(String recipeName, int newFavorite) async{
    String sql = "UPDATE recipes SET favorite = ? WHERE name = ?";
    return await _db.rawUpdate(
      sql,
      [newFavorite, recipeName]
    );
  }
}