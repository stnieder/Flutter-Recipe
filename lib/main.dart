import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';

import 'recipe/recipebook.dart';
import 'recipe/new_recipe.dart';

void main() => runApp(new Recipe());

class Recipe extends StatelessWidget {

  @override
  Widget build(BuildContext context) {  
    //changeStatusColor(); 
    return new MaterialApp(      
      title: 'Rezeptbuch',
      theme: new ThemeData(        
        backgroundColor: Colors.white,
        primarySwatch: Colors.blue,        
        iconTheme: IconThemeData(
          color: Colors.black54          
        )
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => Recipebook(),
        '/add_recipe': (context) => NewRecipe()
      },
    );
  }

  changeStatusColor() async{
    try {
      await FlutterStatusbarcolor.setStatusBarColor(Colors.white);
      FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
      FlutterStatusbarcolor.setNavigationBarWhiteForeground(false);
    } on PlatformException catch (e) {
      debugPrint(e.toString());
    }
  }
}
