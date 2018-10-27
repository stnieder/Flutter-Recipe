import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:recipe/database/database.dart';
import 'package:recipe/interface/GoogleColors.dart';
import 'package:recipe/interface/SideHeaderViewList.dart';
import 'package:recipe/interface/HexToColor.dart';
import 'package:recipe/interface/Search/SearchBox.dart';
import 'package:recipe/interface/Search/search.dart';
import 'package:recipe/model/Recipes.dart';
import 'package:side_header_list_view/side_header_list_view.dart';


Future<List<Recipes>> fetchRecipes() async{
  var dbHelper = DBHelper();
  await dbHelper.create();
  Future<List<Recipes>> recipes = dbHelper.getRecipes();
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
  GoogleMaterialColors googleMaterialColors = new GoogleMaterialColors();
  Random random = new Random(); 
  ConvertColor convertColor = new ConvertColor();  
  Color usedColor; 

  bool longPressFlag = false;
  bool anythingSelected = false;
  List<String> indexList = new List();

  List<String> recipeNames = new List();

  @override
    void initState() {
      super.initState();
    }

  @override
    void dispose() {
      super.dispose();
    }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
        body: NestedScrollView(          
          headerSliverBuilder: (BuildContext context, bool innerBoxisScrolled){
            return <Widget>[
              SliverAppBar(
                backgroundColor: Colors.white.withOpacity(0.0),
                elevation: 0.0,
                centerTitle: false,
                expandedHeight: 56.0,
                floating: false,
                pinned: true,
                title: SearchBox(
                  autofocus: false,
                  addBorder: true,
                  elevation: 4.0,
                  height: 40.0,
                  onChanged: (String text){
                    print(text);
                  },
                  width: 450.0,
                  hintText: "Rezepte suchen",
                  leadingButton: IconButton(
                    icon: Icon(
                      Icons.search,
                      color: Colors.black45,
                    ),
                    onPressed: (){},
                  ),
                  navigateToPage: SearchPage(),
                  trailingButton: [
                    IconButton(
                      icon: Icon(
                        Icons.more_vert,
                        color: Colors.black45
                      ),
                      onPressed: (){},
                    )
                  ]
                ),
              )
            ];
          },
          body: new Container(
            alignment: Alignment.topLeft,
            child: new FutureBuilder<List<Recipes>>(
              future: fetchRecipes(),
              builder: (context, snapshot) {                                
                if (snapshot.hasData) {
                  return SideHeaderListView(
                    hasSameHeader: (int a, int b){
                      return snapshot.data[b].name[0] == snapshot.data[a].name[0];
                    },
                    itemCount: snapshot.data.length,
                    headerBuilder: (BuildContext context, int index){
                      return new Padding(
                        padding: EdgeInsets.only(top: 25.0, right: 35.0),
                        child: Container(
                          width: 10.0,
                          child: Text(
                            snapshot.data[index].name[0],
                            style: TextStyle(
                              color: Color(0xFF0F9D58),                        
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
                      recipeNames.add(snapshot.data[index].name); //for search bar
                              
                      return CustomWidget(
                        avatarColor: usedColor,
                        name: snapshot.data[index].name,
                        index: index,
                        longPressEnabled: longPressFlag,
                        callback: () {
                          if (indexList.contains(index)) {
                            indexList.remove(index);
                          } else {
                            indexList.add(snapshot.data[index].name);
                          }

                          longPress();
                        },
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return new Text("Zurzeit sind keine Daten vorhanden.");
                }                 
                return new Container(alignment: AlignmentDirectional.center,child: new CircularProgressIndicator(),);
              },
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color(0xFF0F9D58),
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

  void searchOperation(String searchText){
    
  }
}