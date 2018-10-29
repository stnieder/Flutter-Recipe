import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:side_header_list_view/side_header_list_view.dart';


import 'package:recipe/Constants.dart';

import 'package:recipe/database/database.dart';

import 'package:recipe/interface/GoogleColors.dart';
import 'package:recipe/interface/HexToColor.dart';
import 'package:recipe/interface/Search/SearchBox.dart';
import 'package:recipe/interface/Search/search.dart';
import 'package:recipe/interface/Search/SearchTransition.dart';
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

  final GlobalKey _menuKey = new GlobalKey();

  @override
    void initState() {
      super.initState();
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

      floatingActionButton: FloatingActionButton(
        backgroundColor: googleMaterialColors.primaryColor(),
        elevation: 4.0,
        child: Icon(Icons.add),
        onPressed: (){
          Navigator.pushNamed(context, '/add_recipe');
        },
      )
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

  void searchOperation() async{
    var searchText = await Navigator.push(
      context,
      SearchTransition(widget: SearchPage())
    );
    if(searchText != null){
      print(searchText);
    }
  }

  Widget defaultAppBar(){
    return AppBar(
      backgroundColor: Colors.white.withOpacity(0.0),
      elevation: 0.0,
      centerTitle: false,
      actions: <Widget>[],
      title: Padding(
        padding: EdgeInsets.only(bottom: 1.0),
        child: SearchBox(
          autofocus: false,
          addBorder: true,
          elevation: 4.0,
          height: 40.0,
          width: 450.0,
          hintText: (longPressFlag
            ? "LongPressEnabled"
            : "Rezepte suchen"
          ),
          leadingButton: IconButton(
            icon: (searchPerformed
              ? Icon(
                  Icons.arrow_back,
                  color: Colors.black45,
                )
              : Icon(
                  Icons.search,
                  color: Colors.black45,
                )
            ),
            onPressed: (){
              if(searchPerformed == true){
                setState(() {
                  searchPerformed = false;
                  searchController.text = "";
                });
              }
            },
          ),
          onTextFieldPressed: searchOperation,
          searchController: searchController,
          trailingButton: [ 
            new PopupMenuButton( 
              tooltip: "Weitere Optionen",                 
              child: Icon(Icons.more_vert, color: Colors.black45),
              key: _menuKey,

              itemBuilder: (_) => <PopupMenuItem<String>>[
                new PopupMenuItem<String>(                      
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(right: 15.0),
                        child: Icon(Icons.sync, size: 20.0, color: Colors.black45,),
                      ),
                      Text(
                        Constants.listPopUp[1],
                        style: TextStyle(
                          fontSize: 15.0
                        ),
                      ),
                    ],
                  ), 
                  value: Constants.listPopUp[1]
                ),
                new PopupMenuItem<String>(
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(right: 15.0),
                        child: Icon(Icons.check_circle_outline, size: 20.0, color: Colors.black45,),
                      ),
                      Text(
                        Constants.listPopUp[2],
                        style: TextStyle(
                          fontSize: 15.0
                        ),
                      ),
                    ],
                  ), 
                  value: Constants.listPopUp[2]
                )
              ],
              onSelected: (String text)=>popUpMenu(text)
            ) 
          ]
        )
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