import 'dart:async';
import 'dart:math';

import 'package:Time2Eat/Constants.dart';
import 'package:Time2Eat/database/database.dart';
import 'package:Time2Eat/interface/CustomListTile.dart';
import 'package:Time2Eat/interface/Custom_SideHeaderListView.dart';
import 'package:Time2Eat/interface/GoogleColors.dart';
import 'package:Time2Eat/interface/HexToColor.dart';
import 'package:Time2Eat/interface/SelectableItems.dart';
import 'package:Time2Eat/model/Recipes.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';



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

  final GlobalKey<ScaffoldState> _drawerKey = new GlobalKey<ScaffoldState>();
  Color listTileColor;

  bool searchActive = false;
  TextEditingController searchController = new TextEditingController();
  bool searchPerformed = false;  
  FocusNode searchFocus = new FocusNode();
  String searchCondition;

  List<String> recipeNames = new List();
  

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
        : (searchActive
          ? searchAppBar()
          : defaultAppBar()
        )
      ),          
      resizeToAvoidBottomPadding: false,
      body: new Container(
        child: new FutureBuilder<List<Recipes>>(
          initialData: [],            
          future: fetchRecipes(searchPerformed, searchCondition),
          builder: (context, snapshot) {   
            if (snapshot.hasData) {
              if(snapshot.data.length == 0){
                return Center(
                  child: Text("Keine Daten gefunden"),
                );
              }
              return SideHeaderListView(                  
                hasSameHeader: (int a, int b){
                  if(searchController.text.isEmpty) return snapshot.data[a].name[0] == snapshot.data[b].name[0];                  
                },
                itemCount: snapshot.data.length,
                headerBuilder: (BuildContext context, int index){
                  if(searchActive == true){

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
                  }
                },
                itemExtend: 70.0,
                itemBuilder: (BuildContext context, int index){
                                      
                  Color usedColor = convertColor.convertToColor(snapshot.data[index].backgroundColor);                    
                  String image = snapshot.data[index].image;

                  return CustomWidget(
                    color: usedColor,
                    name: snapshot.data[index].name,
                    title: (searchController.text.isEmpty
                      ? recipeName(searchCondition, snapshot.data[index].name)
                      : Text(snapshot.data[index].name)
                    ),
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
            CustomListTile(
              textLabel: "Just",
              leading: Icons.memory,
              mainColor: googleMaterialColors.primaryColor(),
              trailing: "116",
            ),
          ],
        ),
      ),
      floatingActionButton: (searchActive
        ? Container()
        : FloatingActionButton(
            backgroundColor: googleMaterialColors.primaryColor(),
            elevation: 4.0,
            child: Icon(Icons.add),
            onPressed: (){
              Navigator.pushNamed(context, '/add_recipe');
            },
          )
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
    } else {
      setState((){
        searchCondition = "";
        searchController.text = "";
        fetchRecipes(false, null);
        searchPerformed = false;
        searchActive = false;
      });
    }
  }

  Widget recipeName(String searchCondition, String name){
    Widget wholeName;
    List<Widget> letters = [];

    //Save name
    String oldName = name;

    //Make the search case insensitive
    name = name.toUpperCase().trim();
    searchCondition = searchCondition.toUpperCase().trim();

    if(name.contains(searchCondition)){
      int start = name.indexOf(searchCondition);
      int end = start + searchCondition.length;

      if(start != 0){
        //undo the case insensitive        
        Text firstPart = Text(
          oldName.substring(0, start)
        );
        letters.add(firstPart);

        Text searchedFor = Text(
          oldName.substring(start,end),
          style: TextStyle(
            fontWeight: FontWeight.bold
          )
        );
        letters.add(searchedFor);

        Text endPart = Text(
          oldName.substring(end, name.length)
        );
        letters.add(endPart);
      }
    }
    
    wholeName = Row(
      children: letters
    );

    return wholeName;
  }

  Widget defaultAppBar(){
    return AppBar(
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.search, color: Colors.black54),
          onPressed: (){
            setState(() {
              searchActive = true;
            });
          },
        ),
        IconButton(
          icon: Icon(Icons.more_vert, color: Colors.black54),
          onPressed: (){},
        )        
      ],
      backgroundColor: Color(0xFFfafafa),
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
          color: Colors.black54,
          fontFamily: "Google-Sans",
          fontSize: 17.0
        ),
      ),
    );
  }

  Widget searchAppBar(){
    return AppBar(
      backgroundColor: Color(0xFFfafafa),
      elevation: 6.0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: Colors.black54,
        ),
        onPressed:(){
          setState(() {
            searchActive = false;
            searchOperation(null);
          }); 
        }
      ),
      title: TextField(        
        autofocus: true,
        cursorColor: googleMaterialColors.primaryColor(),
        cursorRadius: Radius.circular(16.0),
        cursorWidth: 2.0,
        textCapitalization: TextCapitalization.words,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Rezepte suchen",
          hintStyle: TextStyle(
            fontFamily: "Google-Sans"
          )
        ),
        onSubmitted: (String input){
          searchOperation(input);
        },
        style: TextStyle(
          color: Colors.black54,
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