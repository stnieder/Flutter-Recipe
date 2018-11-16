import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

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
    //changeStatusColor(); 
    return new MaterialApp(    
      builder: (context, child) => MediaQuery(data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true), child: child),  
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
