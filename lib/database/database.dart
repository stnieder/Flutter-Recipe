import 'dart:async';
import 'dart:io';
import 'package:Time2Eat/databaseModel/ListTitle.dart';
import 'package:Time2Eat/databaseModel/RecipeTerminCombi.dart';
import 'package:Time2Eat/databaseModel/Recipe_Shopping.dart';
import 'package:Time2Eat/databaseModel/Recipe_Termine.dart';
import 'package:Time2Eat/databaseModel/Shopping.dart';
import 'package:Time2Eat/databaseModel/Shopping_Title.dart';
import 'package:Time2Eat/databaseModel/Termine.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../databaseModel/Recipe_Steps.dart';
import '../databaseModel/StepDescription.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

import '../databaseModel/Recipes.dart';
import '../databaseModel/Ingredients.dart';
import '../databaseModel/Recipe_Ingredient.dart';

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
            "pre_duration varchar, " +
            "cre_duration varchar, " + 
            "resting_time varchar, " +
            "people integer default 2, " +
            "favorite integer default 0, "+
            "timestamp text, "+
            "image real, "+
            "backgroundColor text "+
          ")"
        );

        //Create ingredients table
        await txn.execute(
          "CREATE TABLE ingredients(" +
            "id integer primary key AUTOINCREMENT, " +
            "name varchar, "+
            "measure varchar, "+
            "number real "+
          ")"
        );

        //Create steps table
        await txn.execute(
          "CREATE TABLE steps(" +
            "id integer primary key AUTOINCREMENT, " +
            "number integer, " +
            "description text "+
          ")"
        );

        //create termin table
        await txn.execute(
          "CREATE TABLE termine("+
            "id integer primary key AUTOINCREMENT, " +
            "terminDate text, " +            
            "notificationID text, " + 
            "terminIntervall real " + //id von "intervallTyp"
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
            "timestamp real, " +
            "order_id integer "+
          ")"
        );

        //create shopping list titles
        await txn.execute(
          "CREATE TABLE listTitles("+
            "id integer primary key AUTOINCREMENT, "+
            "titleName varchar "+
          ")"
        );

        await txn.execute(
          "CREATE TABLE intervallTyp("+
            "id integer primary key AUTOINCREMENT, "+
            "intervallName varchar "+
          ")"
        );


        //Create table between recipes and ingredients
        await txn.execute(
          "CREATE TABLE recipeIngredients(" +
            "id integer primary key AUTOINCREMENT, " +
            "idRecipes real, "+
            "idIngredients real "+
          ")"
        );

        //Create table between recipes and descriptions
        await txn.execute(
            "CREATE TABLE recipeSteps(" +
              "id integer primary key AUTOINCREMENT, " +
              "idRecipes real, "+
              "idSteps real "+
            ")"
        );

        //Create table between recipes and termine
        await txn.execute(
          "CREATE TABLE recipeTermine(" +
            "id integer primary key AUTOINCREMENT, "+
            "idRecipes real, "+
            "idTermine real, "+
            "intervallTyp real, " + //id von "intervallTyp"
            "createTimestamp real " + //when the termin was created
          ")"
        );

        //Create table between recipes and termine
        await txn.execute(
          "CREATE TABLE recipeShopping(" +
            "id integer primary key AUTOINCREMENT, "+
            "idRecipes real, "+
            "idShopping real "+
          ")"
        );

        //Create table between shopping and listTitles
        await txn.execute(
          "CREATE TABLE shoppingTitles("+
            "id integer primary key AUTOINCREMENT, "+
            "idShopping real, "+
            "idTitles real "+
          ")"
        );

        //Insert first default shopping table
        int insertshopping = await txn.rawInsert(
          "INSERT INTO listTitles(titleName) VALUES(?)",
          ["Einkaufsliste"]
        );

        await txn.rawInsert(
          "INSERT INTO intervallTyp(intervallName) VALUES(?)",
          ["onetime"]
        );

        await txn.rawInsert(
          "INSERT INTO intervallTyp(intervallName) VALUES(?)",
          ["daily"]
        );

        await txn.rawInsert(
          "INSERT INTO intervallTyp(intervallName) VALUES(?)",
          ["weekly"]
        );
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

  //Delete a recipe
  Future<int> deleteRecipe(String recipeName) async{
    String sql = "DELETE FROM recipes WHERE name = ?";
    int count = await _db.rawDelete(sql, [recipeName]);
    return count;
  }

  //Delete a list
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

  //Delete checked items
  Future deleteCheckedItems(String listName) async{
    await _db.transaction((txn) async{
      String sqlCount, sql;
      int count;


      sql = 
        "SELECT shopping.item AS item "+
        "FROM shopping, shoppingTitles, listTitles "+
        "WHERE shopping.id = shoppingTitles.idShopping "+
        "AND shoppingTitles.idTitles = listTitles.id "+
        "AND listTitles.titleName = ?";
      List<Map> list = await txn.rawQuery(sql, [listName]);
      List<String> items = new List();

      for (var i = 0; i < list.length; i++) {
        items.add(list[i]["item"]);
      }

      sql = "DELETE FROM shoppingTitles "+
            "WHERE idShopping IN ("+
              "SELECT shoppingTitles.idShopping "+
              "FROM shoppingTitles, shopping, listTitles "+ 
              "WHERE shopping.id = shoppingTitles.idShopping "+
              "AND shoppingTitles.idTitles = listTitles.id "+
              "AND shopping.checked = 1 "+
              "AND listTitles.titleName = ? "+
            ")";

      await txn.rawDelete(sql, [listName]);


      sqlCount = 
        "SELECT COUNT(*) FROM shoppingTitles, shopping "+
        "WHERE shoppingTitles.idShopping = shopping.id "+
        "AND shopping.item = ?";      

      sql = 
        "DELETE FROM shopping "+
        "WHERE item = ?";

      for (var i = 0; i < items.length; i++) {
        count = Sqflite.firstIntValue(await txn.rawQuery(sqlCount, [items[i]]));
        if(count == 0){
          await txn.rawDelete(sql, [items[i]]);
        }
      }
    });
  }

  //Delete termin
  Future deleteTermin(int recipeID, String date, int intervallID, String timestamp) async{
    String sql;

    await _db.transaction((txn) async{

      sql = 
        "SELECT termine.id as termin_id "+
        "FROM recipeTermine, recipes, termine "+
        "WHERE recipes.id = recipeTermine.idRecipes "+
        "AND recipeTermine.idTermine = termine.id "+
        "AND termine.terminDate = ? " +
        "AND termine.terminIntervall = ? "+
        "AND termine.terminIntervall = recipeTermine.intervallTyp " + 
        "AND recipes.id = ? " +
        "AND recipeTermine.createTimestamp = ?";

      List<Map> list = await txn.rawQuery(sql, [date, intervallID, recipeID, timestamp]);
      List<String> items = new List();
      for (var i = 0; i < list.length; i++) {
        items.add(list[i]["termin_id"].toString());
      }

      sql = 
        "SELECT termine.notificationID as notificationID "+
        "FROM termine WHERE id = ?";
      FlutterLocalNotificationsPlugin localNotification = FlutterLocalNotificationsPlugin();
      List<Map> notifications = new List();
      String notificationID;

      for (var i = 0; i < items.length; i++) {
        notifications = await txn.rawQuery(sql, [items[i]]);
        notificationID = notifications[i]["notificationID"];
        
        localNotification.cancel(int.parse(notificationID));
      }


      sql = 
        "DELETE FROM recipeTermine "+
        "WHERE idTermine IN ("+
          "SELECT recipeTermine.idTermine "+
          "FROM recipeTermine, recipes, termine "+
          "WHERE  recipes.id = recipeTermine.idRecipes "+
          "AND recipeTermine.idTermine = termine.id "+
          "AND termine.terminDate = ? " +
          "AND termine.terminIntervall = ? "+
          "AND recipeTermine.intervallTyp = ? "+
          "AND recipes.id = ? " + 
          "AND recipeTermine.createTimestamp = ?"
        ")";
      await txn.rawDelete(sql, [date, intervallID, intervallID, recipeID, timestamp]);


      sql = "DELETE FROM termine WHERE id = ?";
      for (var i = 0; i < items.length; i++) {
        await txn.rawDelete(sql, [items[i]]);
      }          
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
    if(title != "") count = Sqflite.firstIntValue(await _db.rawQuery("SELECT COUNT(*) FROM listTitles WHERE titleName = ?", [title]));
    else count = Sqflite.firstIntValue(await _db.rawQuery("SELECT COUNT(*) FROM listTitles"));
    return count;
  }

  Future<int> checkItem(String itemName) async{
    String sql = "SELECT COUNT(*) FROM shopping WHERE item = ?";
    int count = Sqflite.firstIntValue(await _db.rawQuery(sql, [itemName]));
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

  Future<RecipesDB> updateRecipe(RecipesDB recipe, String oldName) async{
    await _db.update("recipes", recipe.toMap(), where: "name = ?", whereArgs: [oldName]);
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

  Future<int> deleteIngre(String recipe) async{
    int count;
    await _db.transaction((txn)async{
      String sql = 
        "SELECT ingredients.id FROM ingredients, recipeIngredients, recipes "+
        "WHERE ingredients.id = recipeIngredients.idIngredients "+
        "AND recipeIngredients.idRecipes = recipes.id "+
        "AND recipes.name = ?";
      List<Map> list = await txn.rawQuery(sql, [recipe]);
      List<String> items = new List();
      for (var i = 0; i < list.length; i++) {
        items.add(list[i]["id"].toString());
      }

      sql = 
        "SELECT recipeIngredients.id FROM ingredients, recipeIngredients, recipes "+
        "WHERE ingredients.id = recipeIngredients.idIngredients "+
        "AND recipeIngredients.idRecipes = recipes.id "+
        "AND recipes.name = ?";
      List<Map> listZwischen = await txn.rawQuery(sql, [recipe]);
      List<String> zwischenTabelle = new List();
      for (var i = 0; i < list.length; i++) {
        zwischenTabelle.add(listZwischen[i]["id"].toString());
      }
      

      sql = 
        "DELETE FROM ingredients "+
        "WHERE id = ?";
      for (var i = 0; i < items.length; i++) {
        await txn.rawDelete(sql, [items[i]]);
      }

      sql = 
        "DELETE FROM recipeIngredients "+
        "WHERE id = ?";
      for (var i = 0; i < zwischenTabelle.length; i++) {
        await txn.rawDelete(sql, [zwischenTabelle[i]]);
      }
      count = items.length + zwischenTabelle.length;
      print("Items deleted: $count");
    });    
    return count;
  }

  Future<StepsDB> insertSteps(StepsDB steps) async{
    var count = Sqflite.firstIntValue(await _db.rawQuery("SELECT COUNT(*) FROM steps, recipes, recipeSteps WHERE steps.id = ? AND steps.id = recipeSteps.idSteps AND recipeSteps.idRecipes = recipes.id AND steps.description = ?", [steps.description]));
    if(count == 0){
      steps.id = await _db.insert("steps", steps.toMap());
    } else {
      await _db.update("steps", steps.toMap(), where: "id = ?", whereArgs: [steps.id]);
    }
    return steps;
  }

  Future<int> deleteSteps(recipe) async{
    int count;
    await _db.transaction((txn)async{
      String sql = 
        "SELECT steps.id FROM steps, recipeSteps, recipes "+
        "WHERE steps.id = recipeSteps.idSteps "+
        "AND recipeSteps.idRecipes = recipes.id "+
        "AND recipes.name = ?";
      List<Map> list = await txn.rawQuery(sql, [recipe]);
      List<String> items = new List();
      for (var i = 0; i < list.length; i++) {
        items.add(list[i]["id"].toString());
      }

      sql = 
        "SELECT recipeSteps.id FROM steps, recipeSteps, recipes "+
        "WHERE steps.id = recipeSteps.idSteps "+
        "AND recipeSteps.idRecipes = recipes.id "+
        "AND recipes.name = ?";
      List<Map> listZwischen = await txn.rawQuery(sql, [recipe]);
      List<String> zwischenTabelle = new List();
      for (var i = 0; i < list.length; i++) {
        zwischenTabelle.add(listZwischen[i]["id"].toString());
      }
      

      sql = 
        "DELETE FROM steps "+
        "WHERE id = ?";
      for (var i = 0; i < items.length; i++) {
        await txn.rawDelete(sql, [items[i]]);
      }

      sql = 
        "DELETE FROM recipeSteps "+
        "WHERE id = ?";
      for (var i = 0; i < zwischenTabelle.length; i++) {
        await txn.rawDelete(sql, [zwischenTabelle[i]]);
      }
      count = items.length + zwischenTabelle.length;
      print("Items deleted: $count");
    });    
    return count;
  }

  
  Future<ShoppingDB> newShoppingItem(ShoppingDB shopping, [String title]) async{
    SharedPreferences prefs  = await SharedPreferences.getInstance();

    int count = Sqflite.firstIntValue(
      await _db.rawQuery(
        "SELECT COUNT(*) FROM shopping WHERE shopping.item = ? AND shopping.measure = ?",
        [shopping.item, shopping.measure]
      )
    );
    
    String sql = 
      "UPDATE shopping "+
      "SET number = number + ? "+
      "WHERE id = ( "+
        "SELECT shoppingTitles.idShopping "+
        "FROM shoppingTitles, listTitles "+
        "WHERE shoppingTitles.idTitles = listTitles.id "+
        "AND listTitles.titleName = ? "+
      ") "+
      "AND item = ?";

    if(count == 0){
      shopping.id = await _db.insert("shopping", shopping.toMap());
    } else {
      if(title == null)shopping.id = await _db.rawUpdate(sql, [shopping.number, prefs.getString("currentList")]);
      else shopping.id = await _db.rawUpdate(sql, [shopping.number, title]);      
    }
    
    return shopping;
  }

  Future<ShoppingDB> linkShoppingTitles(ShoppingDB shopping, String titlename) async{
    String countSQL =
      "SELECT COUNT(*) "+
        "FROM shopping, shoppingTitles, listTitles "+
        "WHERE shopping.item = ? "+
        "AND shopping.id = shoppingTitles.idShopping "+
        "AND shoppingTitles.idTitles = listTitles.id "+
        "AND listTitles.titleName = ? ";
    int count = Sqflite.firstIntValue(await _db.rawQuery(countSQL, [shopping.item, titlename]));

    String updateSQL = 
      "UPDATE shopping "+
      "SET number = number + ? "+
      "WHERE id = ( "+
        "SELECT shoppingTitles.idShopping "+
        "FROM shoppingTitles, listTitles "+
        "WHERE shoppingTitles.idTitles = listTitles.id "+
        "AND listTitles.titleName = ? "+
      ") "+
      "AND item = ?";

    String insertSQL = 
      "INSERT INTO shopping ("+
        "item, measure, number, checked, timestamp "+
      ") "+
      "VALUES ("+
        "?, ?, ?, ?, ? "+
      ")";
    
    if(count == 0){
      shopping.id = await _db.rawInsert(insertSQL, [shopping.item, shopping.measure, shopping.number, shopping.checked, shopping.timestamp]);
    } else {
      shopping.id = await _db.rawUpdate(updateSQL, [shopping.number, titlename, shopping.item]);
    }

    return shopping;
  }

  Future<bool> checkItems(String item, String titleName) async{
    bool value = false;

    var count = Sqflite.firstIntValue(
      await _db.rawQuery(
        "SELECT COUNT(*) "+
        "FROM shopping, shoppingTitles, listTitles "+
        "WHERE shopping.item = ? "+
        "AND shopping.id = shoppingTitles.idShopping "+
        "AND shoppingTitles.idTitles = listTitles.id "+
        "AND listTitles.titleName = ? ",
        [item, titleName]
      )
    );

    if(count > 0) value = true; //a shopping item is in this list


    return value;
  }

  Future<TermineDB> insertTermine(TermineDB termine) async{
    var count;
    if(termine.id == null) count = 0;
    else count = Sqflite.firstIntValue(await _db.rawQuery("SELECT COUNT(*) FROM termine WHERE terminDate = ?", [termine.terminDate]));
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
      recShop.id = await _db.update("recipeShopping", recShop.toMap(), where:  "id = ?", whereArgs: [recShop.id]);
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
      recipes.add(new Recipes(id: list[i]["id"],name: list[i]["name"],definition: list[i]["definition"], pre_duration: list[i]["pre_duration"], cre_duration: list[i]["cre_duration"], resting_time: list[i]["resting_time"], people: list[i]["people"].toString(), favorite:  list[i]["favorite"], timestamp: list[i]["timestamp"], image: list[i]["image"],backgroundColor: list[i]["backgroundColor"]));
    }
    return recipes;
  }  

  //Get Specific Recipe
  Future<List<Recipes>> getSpecRecipe(String recipeName) async{
    List<Map> list = await _db.rawQuery("SELECT * FROM recipes WHERE name = ?", [recipeName]);
    List<Recipes> recipes = new List();
    for(int i =0; i < list.length; i++){
      recipes.add(new Recipes(id: list[i]["id"],name: list[i]["name"],definition: list[i]["definition"], pre_duration: list[i]["pre_duration"], cre_duration: list[i]["cre_duration"], resting_time: list[i]["resting_time"], people: list[i]["people"].toString(), favorite:  list[i]["favorite"], timestamp: list[i]["timestamp"], image: list[i]["image"],backgroundColor: list[i]["backgroundColor"]));
    }   
    return recipes;
  }

  Future<int> countRecipes() async{
    int count = Sqflite.firstIntValue(await _db.rawQuery("SELECT COUNT(*) FROM recipes"));
    return count;
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

  //Get Step description
  Future<List<String>> getStepDescription(String recipeName) async{
    String sql = "SELECT steps.description FROM steps, recipes, recipeSteps WHERE recipes.name = '"+recipeName+"' AND recipes.id = recipeSteps.idRecipes AND recipeSteps.idSteps = steps.id";
    List<Map> list = await _db.rawQuery(sql);
    List<String> steps = new List();
    for(int i =0; i<list.length; i++){
      steps.add(list[i]["description"]);
    }
    return steps;
  }

  //Get Shopping list
  Future<List<Shopping>> getShopping(String order, String title) async{
    if(order == "abc") order = "item ASC";
    String sql = 
    "SELECT shopping.item, shopping.measure, shopping.number, shopping.checked, shopping.timestamp " + 
    "FROM shopping, shoppingTitles, listTitles " + 
    "WHERE shopping.id = shoppingTitles.idShopping "+
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

  Future<int> getTerminID(String recipe, int intervallID, String timestamp, String date) async{
    String sql =
      "SELECT termine.id "+
      "FROM termine, recipeTermine, recipes "+
      "WHERE termine.id = recipeTermine.idTermine "+
      "AND recipeTermine.idRecipes = recipes.id "+
      "AND recipes.name = ? "+
      "AND recipeTermine.intervallTyp = ? "+
      "AND recipeTermine.createTimestamp = ? "
      "AND termine.terminIntervall = ? "+
      "AND termine.terminDate = ? ";

    int id = Sqflite.firstIntValue(await _db.rawQuery(sql, [recipe, intervallID, timestamp, intervallID, date]));
    return id;
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
    String sql = "SELECT recipes.id as id, termine.terminDate as termin, recipes.name  as name, recipes.image  as image, recipeTermine.createTimestamp as timestamp,recipes.backgroundColor as backgroundColor FROM termine, recipeTermine, recipes WHERE termine.terminDate = '"+date+"' AND termine.id = recipeTermine.idTermine AND recipeTermine.idRecipes = recipes.id";
    List<Map> list = await _db.rawQuery(sql);
    List termine = new List();
    for (int i=0; i<list.length; i++) {
      termine.add(new RecipeTerminCombi(list[i]["id"].toString(), list[i]["termin"], list[i]["name"], list[i]["image"], list[i]["timestamp"], list[i]["backgroundColor"]));
    }
    print("TerminAnzahl: "+termine.length.toString());
    return termine;
  }

  //Get all List titles
  Future<List<ListTitle>> getListTitles([int number]) async{
    String sql = "SELECT * FROM listTitles";
    List<Map> list = await _db.rawQuery(sql);
    List<ListTitle> titles = new List();
    for(int i=0; i<list.length; i++){
      titles.add(new ListTitle(list[i]["id"], list[i]["titleName"]));
    }
    return titles;
  }

  //Get first list title
  Future<String> getFirstTitle() async{
    String sql = "SELECT titleName FROM listTitles";
    List<Map> list = await _db.rawQuery(sql);
    String title = list[0]["titleName"];
    return title;
  }

  //Count list titles
  Future<int> countTitles(String title) async{
    String sql; 
    int count;

    sql = 
        "SELECT COUNT(*) "+
        "FROM listTitles, shopping, shoppingTitles "+
        "WHERE listTitles.id = shoppingTitles.idTitles "+
        "AND shoppingTitles.idShopping = shopping.id "+
        "AND listTitles.titleName = ?";
    count = Sqflite.firstIntValue(await _db.rawQuery(sql, [title]));
    
    return count;
  }

  //Count all titles
  Future<int> countAllTitles() async{
    String sql = 
    "SELECT COUNT(*) FROM listTitles, shopping, shoppingTitles "+
    "WHERE listTitles.id = shoppingTitles.idTitles "+
    "AND shoppingTitles.idShopping = shopping.id ";

    int count = Sqflite.firstIntValue(await _db.rawQuery(sql));
    return count;
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
      recipes.add(new Recipes(id: list[i]["id"],name: list[i]["name"],definition: list[i]["definition"], pre_duration: list[i]["pre_duration"], cre_duration: list[i]["cre_duration"], resting_time: list[i]["resting_time"], people: list[i]["people"].toString(), favorite:  list[i]["favorite"], timestamp: list[i]["timestamp"], image: list[i]["image"],backgroundColor: list[i]["backgroundColor"]));
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

  //Get Shopping item ID
  Future<int> getItemID(String item) async{
    String sql = "SELECT id FROM shopping WHERE item = ?";
    List<Map> list = await _db.rawQuery(sql, [item]);
    int id = list[0]["id"];
    return id;
  }

  //Get next shopping item ID
  Future<int> getNextItemID() async{
    String sql = "SELECT MAX(id) AS _ID FROM shopping";
    int id = Sqflite.firstIntValue(await _db.rawQuery(sql));
    return id;
  }

  //Get recipe ID
  Future<int> getRecipeID(String recipe)async{
    String sql = "SELECT id FROM recipes WHERE name = ?";
    int id = Sqflite.firstIntValue(await _db.rawQuery(sql, [recipe]));
    return id;
  }

  //Get intervall ID
  Future<int> getIntervallID(String interval) async{
    String sql = "SELECT id FROM intervallTyp WHERE intervallName = ?";
    int id = Sqflite.firstIntValue(await _db.rawQuery(sql,[interval]));
    return id;
  }

  //Get intervall
  Future<int> getIntervall(int recipeID, String date, String timestamp) async{
    String sql = 
      "SELECT recipeTermine.intervallTyp as intervall_id "+ 
      "FROM recipeTermine, recipes, termine "+
      "WHERE recipeTermine.idRecipes = recipes.id "+
      "AND recipeTermine.idTermine = termine.id " + 
      "AND recipes.id = ? " +
      "AND termine.terminDate = ? " +
      "AND recipeTermine.createTimestamp = ?";

    List<Map> list = await _db.rawQuery(sql, [recipeID, date, timestamp]);
    int id = list[0]["intervall_id"].round();

    //int id = Sqflite.firstIntValue(await _db.rawQuery(sql, [recipeID, date, timestamp]));
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


  //Update notification id
  Future<int> updateNotification(int terminID, int notificationID, int intervallID, String timestamp) async{
    String sql_one = 
      "UPDATE termine "+
      "SET notificationID = ?, terminIntervall = ? "+
      "WHERE id = ("+
        "SELECT idTermine FROM recipeTermine "+
        "WHERE createTimestamp = ?"+
      ") "+
      "AND id = ?";

    String sql_two = 
      "UPDATE recipeTermine "+
      "SET intervallTyp = ? "+
      "WHERE id = ("+
        "SELECT id FROM termine "+
        "WHERE id = ? "+
      ") "+
      "AND createTimestamp = ?";

    await _db.transaction((txn) async{
      await txn.rawQuery(sql_one, [notificationID, intervallID, timestamp, terminID]);

      await txn.rawQuery(sql_two, [intervallID, terminID, timestamp]);
    });

    return 1;
  }
}