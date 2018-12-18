import 'package:Time2Eat/Splashscreen.dart';
import 'package:Time2Eat/database/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:simple_permissions/simple_permissions.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'recipe/recipebook.dart';
import 'recipe/new_recipe.dart';


var flutterLocalNotifcations;


void main() async{
  flutterLocalNotifcations = new FlutterLocalNotificationsPlugin();
  runApp(new Recipe());
}

class Recipe extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    setPrefs();
    return new MaterialApp(    
      builder: (context, child) => MediaQuery(data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true), child: child),  
      title: 'Rezeptbuch',
      theme: new ThemeData(        
        backgroundColor: Colors.white,
        canvasColor: Colors.white,
        primarySwatch: Colors.blue,
        iconTheme: IconThemeData(
          color: Colors.black54          
        ),
        textTheme: TextTheme(
          body1: TextStyle(
            color: Colors.black,
            fontFamily: "Noto-Sans"
          )
        )
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => Splashscreen(),
        '/add_recipe': (context) => NewRecipe()
      },
    );
  }

  setPrefs() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String list = prefs.getString("currentList");
    if(list == null || list == "") {
      prefs.setString("currentList", "Einkaufsliste");
    }
  }
}
