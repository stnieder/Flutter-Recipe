import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


import 'package:recipe/Constants.dart';

import 'package:recipe/database/database.dart';

import 'package:recipe/interface/Custom_SideHeaderListView.dart';
import 'package:recipe/interface/GoogleColors.dart';
import 'package:recipe/interface/HexToColor.dart';
import 'package:recipe/interface/SelectableItems.dart';

import 'package:recipe/model/Recipes.dart';



Future<List<Recipes>> fetchRecipes(bool searched, String recipeName) async{
  var dbHelper = DBHelper();
  await dbHelper.create();
  Future<List<Recipes>> recipes;
  if(searched) recipes = dbHelper.filterRecipes(recipeName);
  else recipes = dbHelper.getRecipes();
  
  return recipes;
}


class Lists extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _List();
  }
}

class _List extends State<Lists>{
  DBHelper db = new DBHelper();
  Constants variablen = new Constants();
  GoogleMaterialColors googleMaterialColors = new GoogleMaterialColors();
  Random random = new Random(); 
  ConvertColor convertColor = new ConvertColor();  
  Color usedColor; 

  bool longPressFlag = false;
  List<String> indexList = new List();
  
  bool searchPerformed = false;
  String searchCondition;
  TextEditingController searchController = new TextEditingController();

  final GlobalKey<ScaffoldState> _drawerKey = new GlobalKey<ScaffoldState>();
  Color listTileColor;

  @override
    void initState() {
      super.initState();
      listTileColor = googleMaterialColors.primaryColor().withOpacity(0.2);
    }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(  
      appBar: (longPressFlag
        ? longPressedAppBar()
        : defaultAppBar()
      ),          
      resizeToAvoidBottomPadding: true,
      body: new Container(
        child: new FutureBuilder<List<Recipes>>(
          initialData: [],            
          future: fetchRecipes(searchPerformed, searchCondition),
          builder: (context, snapshot) {   
            if (snapshot.hasData) {
              return SideHeaderListView(                  
                hasSameHeader: (int a, int b){
                  return snapshot.data[a].name[0] == snapshot.data[b].name[0];
                },
                itemCount: snapshot.data.length,
                headerBuilder: (BuildContext context, int index){
                  return new Padding(
                    padding: EdgeInsets.only(top: 30.0, left: 20.0, right: 25.0),
                    child: Container(
                      width: 10.0,
                      child: Text(
                        snapshot.data[index].name[0].toUpperCase(),
                        style: TextStyle(
                          color: googleMaterialColors.primaryColor().withGreen(120),                        
                          fontFamily: "Google-Sans",
                          fontSize: 15.0,
                          fontWeight: FontWeight.w600
                        ),
                      ),
                    ),
                  );
                },
                itemExtend: 70.0,
                itemBuilder: (BuildContext context, int index){
                                      
                  Color usedColor = convertColor.convertToColor(snapshot.data[index].backgroundColor);                    
                  String image = snapshot.data[index].image;
                  print("Image: "+image);
                  return CustomWidget(
                    color: usedColor,
                    name: snapshot.data[index].name,
                    index: index,
                    image: image,
                    longPressEnabled: longPressFlag,                                            
                    callback: () {
                      if (indexList.contains(snapshot.data[index].name)) {
                        indexList.remove(snapshot.data[index].name);
                      } else {
                        indexList.add(snapshot.data[index].name);
                      }

                      longPress();
                    },
                  );
                },
              );
            } else if(!snapshot.hasData) {
              return Center(
                child: Text("Keine Daten vorhanden"),                  
              );
            } else if (snapshot.hasError) {
              return new Text("${snapshot.error}");
            }                 
            return new Container(alignment: AlignmentDirectional.center,child: new CircularProgressIndicator(),);
          },
        ),
      ),   
      drawer: Drawer(        
        child: ListView(
          children: <Widget>[
            GestureDetector(
              onPanDown: (DragDownDetails dragdown){
                setState(() {
                  listTileColor = googleMaterialColors.primaryColor().withOpacity(0.05);
                });
              },
              onPanCancel: (){
                setState(() {
                  listTileColor = googleMaterialColors.primaryColor().withOpacity(0.2);
                });
              },
              child: Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Container(                
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 1.0, left: 15.0),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.memory, 
                          color: googleMaterialColors.primaryColor()
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 20.0),
                          child: Text(
                            "Just text",
                            style: TextStyle(
                              color: googleMaterialColors.primaryColor(),
                              fontWeight: FontWeight.w600
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(32.0),
                      topLeft: Radius.circular(32.0)
                    ),
                    color: listTileColor,                  
                  ),
                  height: 40.0,
                  width: 150.0,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: googleMaterialColors.primaryColor(),
        elevation: 4.0,
        child: Icon(Icons.add),
        onPressed: (){
          Navigator.pushNamed(context, '/add_recipe');
        },
      ),
      key: _drawerKey,
    );
  }

  void showBottomSnack(String value, ToastGravity toastGravity){
    Fluttertoast.showToast(
      msg: value,
      toastLength: Toast.LENGTH_SHORT,
      gravity: toastGravity,
      timeInSecForIos: 2,            
    );
  }

  void longPress() {
    setState(() {
      if (indexList.isEmpty) {
        longPressFlag = false;
      } else {
        longPressFlag = true;
      }
    });
  }

  void searchOperation(String searchText) async{    
    if(searchText != null && searchText != ""){
      setState(() {
        searchCondition = searchText;
        searchController.text = searchCondition;
        fetchRecipes(true, searchText);
        searchPerformed = true;
      });
    }
  }

  Widget defaultAppBar(){
    return AppBar(
      backgroundColor: Colors.white.withOpacity(0.0),
      elevation: 0.0,
      centerTitle: true,
      leading: IconButton(
        icon: Icon(
          Icons.menu,
          color: Colors.black54,
        ),
        onPressed: (){
          _drawerKey.currentState.openDrawer();
        },
      ),
      title: Text(
        "Rezeptbuch",
        style: TextStyle(
          fontFamily: "Google-Sans"
        ),
      ),
    );
  }

  Widget longPressedAppBar(){
    return AppBar(
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.delete_outline),
          onPressed: (){
            print("Deleted pressed");
          },
        ),
        IconButton(
          icon: Icon(Icons.label_outline),
          onPressed: (){
            print("Labeled pressed");
          },
        )
      ],
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: Icon(
          Icons.close, 
          color: Colors.black54
        ),
        onPressed: (){
          setState(() {
            indexList.clear();
            longPressFlag = false;
            longPress();                 

            searchController = new TextEditingController();
          });
        },
      ),
      title: (indexList.isEmpty
        ? Text(
            indexList.length.toString()
          )
        : Text(
            "Rezepte auswählen",
            style: TextStyle(
              fontFamily: "Google-Sans",
              fontSize: 16.0
            ),
          )
      ),
    );
  }

  popUpMenu(String text){
    if(text == Constants.listPopUp[2]){
      setState(() {
        longPressFlag = true;
      });
    }
  }
}