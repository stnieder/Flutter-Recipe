import 'dart:convert';
import 'dart:io';

import 'package:Time2Eat/DialogInterfaces/Dialogs.dart';
import 'package:Time2Eat/Export_Import/recipes.dart';
import 'package:Time2Eat/database/database.dart';
import 'package:Time2Eat/databaseModel/Ingredients.dart';
import 'package:Time2Eat/databaseModel/Recipes.dart';
import 'package:Time2Eat/databaseModel/StepDescription.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_extend/share_extend.dart';
import 'package:simple_permissions/simple_permissions.dart';

class OneRecipe {

  static const String authorities = "com.vendetta.recipe.fileprovider";
  static const String fileExtension = ".recipe";

  Directory directory;
  File jsonFile;

  String name;
  RecipesModel recipesModel;
  List<ZutatenModel> zutaten = [];
  List<ZubereitungModel> zubereitung = [];

  OneRecipe();

  exportToJson(String recipeName, bool share, BuildContext context) async{
    this.name = recipeName;
    var permissions = await getPermission(context);

    if(permissions){

      await applicationDocumentsDirectory(recipeName);

      await getRecipeDetails();

      File newFile = await createFile();
      if(share && Platform.isAndroid) await ShareExtend.share(newFile.path, "file", authorities);
      else showBottomSnack("Die Datei wurde nach ${newFile.path} exportiert.", ToastGravity.BOTTOM, context);
    }
  }


  getPermission(BuildContext context) async{
    var getPermissionString = await SimplePermissions.checkPermission(Permission.WriteExternalStorage);

    if(getPermissionString == false) {
      var request = await Dialogs().authorizeWriting(context);
      if(request == PermissionStatus.authorized) {
        getPermission(context);
        return true;
      } else {
        return false;
      }
    } else {
      return true;
    }
  }

  applicationDocumentsDirectory(String recipe) async{
    this.directory = await getApplicationDocumentsDirectory();
    this.jsonFile = new File(directory.path+"/"+recipe+fileExtension);
  }  


  getRecipeDetails() async{
    DBHelper db = new DBHelper();
    await db.create();
    List<Recipes> recipeDetails = await db.getSpecRecipe(name);

    await getZutaten(this.name);
    await getSchritte(this.name);

    this.recipesModel = new RecipesModel(
      name, 
      recipeDetails[0].image, 
      recipeDetails[0].definition, 
      recipeDetails[0].timestamp, 
      recipeDetails[0].pre_duration, 
      recipeDetails[0].cre_duration, 
      recipeDetails[0].resting_time, 
      recipeDetails[0].people, 
      recipeDetails[0].backgroundColor, 
      recipeDetails[0].favorite, 
      zutaten, 
      zubereitung
    );
  }

  getZutaten(String recipe) async{
    DBHelper db = new DBHelper();
    await db.create();

    List<Ingredients> ingredients = await db.getIngredients(recipe);
    for (var i = 0; i < ingredients.length; i++) {
      this.zutaten.add(new ZutatenModel(
        ingredients[i].name,
        ingredients[i].number,
        ingredients[i].measure
      ));
    }
  }

  getSchritte(String recipe) async{
    DBHelper db = new DBHelper();
    await db.create();

    List<Steps> steps = await db.getSteps(recipe);
    for (var i = 0; i < steps.length; i++) {
      this.zubereitung.add(new ZubereitungModel(
        steps[i].number.toString(),
        steps[i].description
      ));
    }
  }

  Future<File> createFile() async{
    if(this.recipesModel != null) {
      final jsonString = this.recipesModel.toJson();
      await jsonFile.create();
      jsonFile.writeAsString(json.encode(jsonString));
    }  
    return jsonFile;  
  }

  showBottomSnack(String value, ToastGravity toastGravity, BuildContext context){
    Fluttertoast.showToast(
      msg: value,
      toastLength: Toast.LENGTH_SHORT,
      gravity: toastGravity,
      timeInSecForIos: 2,            
    );
  }
}