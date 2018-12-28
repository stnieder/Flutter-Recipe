import 'dart:convert';
import 'dart:io';

import 'package:Time2Eat/DialogInterfaces/Dialogs.dart';
import 'package:Time2Eat/Export_Import/recipes.dart';
import 'package:Time2Eat/database/database.dart';
import 'package:Time2Eat/databaseModel/Ingredients.dart';
import 'package:Time2Eat/databaseModel/Recipes.dart';
import 'package:Time2Eat/databaseModel/StepDescription.dart';
import 'package:archive/archive_io.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_extend/share_extend.dart';
import 'package:simple_permissions/simple_permissions.dart';

class MultipleRecipes{

  static const String authorities = "com.vendetta.recipe.fileprovider";
  static const String fileExtension = ".recipe";

  Directory directory;
  String zipDirectory;
  String currentName;
  File jsonFile;
  var createZip;

  RecipesModel currentRecipe;
  List<ZutatenModel> currentIngredients;
  List<ZubereitungModel> currentSteps;
  
  MultipleRecipes();

  exportToZip(List<String> names, bool share, BuildContext context) async{
    var permissions = await getPermission(context);
    if(permissions){
      createZip = new ZipFileEncoder();
      if(Platform.isAndroid) {
        await getExternalStorageDirectory().then((dir){
          zipDirectory = dir.path;
        });
      } else if(Platform.isIOS){
        await getApplicationDocumentsDirectory().then((dir){
          zipDirectory = dir.path;
        });
      }

      createZip.create(zipDirectory+"/Recipes.zip");

      for (var i = 0; i < names.length; i++) {
        await applicationDocumentsDirectory(names[i]);

        await getRecipeDetails(names[i]);

        await addFileToZip(names[i], createZip);
      }
      createZip.close();

      if(share && Platform.isAndroid) await ShareExtend.share(createZip.zip_path, "file", authorities);
      else showBottomSnack("Die komprimierte Datei wurde nach ${createZip.zip_path} exportiert", ToastGravity.BOTTOM, context);
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
  }  


  getRecipeDetails(String recipe) async{
    DBHelper db = new DBHelper();
    await db.create();
    List<Recipes> recipeDetails = await db.getSpecRecipe(recipe);

    await getZutaten(recipe);
    await getSchritte(recipe);

    this.currentRecipe = new RecipesModel(
      currentName, 
      recipeDetails[0].image, 
      recipeDetails[0].definition, 
      recipeDetails[0].timestamp, 
      recipeDetails[0].pre_duration, 
      recipeDetails[0].cre_duration, 
      recipeDetails[0].resting_time, 
      recipeDetails[0].people, 
      recipeDetails[0].backgroundColor, 
      recipeDetails[0].favorite, 
      currentIngredients, 
      currentSteps
    );
  }

  getZutaten(String recipe) async{
    DBHelper db = new DBHelper();
    await db.create();

    List<Ingredients> ingredients = await db.getIngredients(recipe);
    currentIngredients = new List();
    for (var i = 0; i < ingredients.length; i++) {
      this.currentIngredients.add(new ZutatenModel(
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
    currentSteps = new List();
    for (var i = 0; i < steps.length; i++) {
      this.currentSteps.add(new ZubereitungModel(
        steps[i].number.toString(),
        steps[i].description
      ));
    }
  }


  addFileToZip(String recipe, ZipFileEncoder createZip) async{
    recipe = recipe.split(" ")[0];
    this.jsonFile = new File(directory.path+"/"+recipe);
    if(this.currentRecipe != null) {
      final jsonString = this.currentRecipe.toJson();
      await this.jsonFile.create();
      this.jsonFile.writeAsString(json.encode(jsonString));
    } 
    createZip.addFile(jsonFile);
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