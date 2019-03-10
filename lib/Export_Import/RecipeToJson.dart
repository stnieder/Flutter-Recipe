


import 'package:TimeEater/Export_Import/MultipleRecipes.dart';
import 'package:TimeEater/Export_Import/OneRecipe.dart';
import 'package:flutter/material.dart';

class ExportRecipe {
  
  ExportRecipe();

  exportToZip(List<String> recipeNames, bool share, BuildContext context){
    MultipleRecipes multiple = new MultipleRecipes();
    multiple.exportToZip(recipeNames, share, context);
  } 

  exportOneRecipe(String recipe, bool share, BuildContext context){
    OneRecipe one = new OneRecipe();
    one.exportToJson(recipe, share, context);
  }    
}