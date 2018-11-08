import 'package:Time2Eat/interface/ActiveDrawer.dart';
import 'package:Time2Eat/recipe/new_recipe.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:outline_material_icons/outline_material_icons.dart';

import '../Constants.dart';
import '../database/database.dart';
import '../interface/Calendar/flutter_calendar.dart';
import '../interface/CustomListTile.dart';
import '../interface/Custom_SideHeaderListView.dart';
import '../interface/GoogleColors.dart';
import '../interface/HexToColor.dart';
import '../interface/SelectableItems.dart';
import '../model/Recipes.dart';
import '../pages/calendar_view.dart';
import '../pages/list.dart';
import '../pages/shopping_list.dart';


class Recipebook extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _Recipebook();
  }
}

class _Recipebook extends State<Recipebook> with TickerProviderStateMixin{
  var dbHelper = new DBHelper();
  var googleMaterialColors = new GoogleMaterialColors();
  final GlobalKey<ScaffoldState> _drawerKey = new GlobalKey<ScaffoldState>();

  //Rezeptbuch page
  bool longPressFlag = false;
  List<String> indexList = new List();
  bool searchActive = false;
  TextEditingController searchController = new TextEditingController();
  bool searchPerformed = false;  
  FocusNode searchFocus = new FocusNode();
  String searchCondition;
  ConvertColor convertColor = new ConvertColor();  

  int _currentTab = 0;

  final List<String> _tabTitle =  [
    "Rezeptbuch",
    "Terminübersicht",
    "Einkaufsliste"
  ];

  List<FloatingActionButton> _fabs = new List();

  

  @override
    void initState() {
      super.initState();
      dbHelper.create();
      setState(() {});
    }

  @override
  Widget build(BuildContext context) {
    _fabs = [
        FloatingActionButton(
          onPressed: (){
            Navigator.push(
              context, 
              MaterialPageRoute(builder: (context)=> NewRecipe())
            );
          },
          child: Icon(
            Icons.add
          ),
        ),
        FloatingActionButton(
          //Add recipe
          onPressed: (){},
          child: Icon(
            Icons.add
          ),
        ),
        FloatingActionButton(
          //Add some ingredients
          onPressed: (){},
          child: Icon(
            Icons.add
          ),
        )
      ];

    return Scaffold(
      appBar: (longPressFlag
        ? longPressedAppBar()
        : (searchActive
          ? searchAppBar()
          : defaultAppBar()
        )
      ),
      key: _drawerKey,
      body: pageView(_currentTab),
      bottomNavigationBar: BottomNavigationBar(
          onTap: onTabTapped,
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentTab,
          fixedColor: Colors.blue[600],
          items: [
            BottomNavigationBarItem(
                icon: Icon(OMIcons.book),
                title: const Text(
                  'Rezeptbuch',
                  style: TextStyle(
                      fontFamily: 'Google-Sans', fontWeight: FontWeight.w600),
                )
            ),
            BottomNavigationBarItem(
                icon: Icon(OMIcons.calendarToday),
                title: const Text(
                  'Kalender',
                  style: TextStyle(
                      fontFamily: 'Google-Sans', fontWeight: FontWeight.w600),
                )
            ),
            BottomNavigationBarItem(
                icon: Icon(OMIcons.shoppingBasket),
                title: const Text(
                  'Einkaufsliste',
                  style: TextStyle(
                      fontFamily: 'Google-Sans', fontWeight: FontWeight.w600),
                )
            )
          ],
      ),
      floatingActionButton: _fabs[_currentTab],
    );
  }


  /*
    Different functions
  */

  void onTabTapped(int index){
    setState(() {
      _currentTab = index;
    });
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

  popUpMenu(String text){
    if(text == Constants.listPopUp[2]){
      setState(() {
        longPressFlag = true;
      });
    }
  }



  /*
    Different important widgets
  */
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

  List<Widget> actionList(int currentPage){
    List<Widget> iconButtons = new List();
    if(currentPage == 0){
      iconButtons = [
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
      ];
    } else if(currentPage == 1){
      iconButtons = [
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
      ];
    } else if(currentPage == 2){
      iconButtons = [
        IconButton(
          icon: Icon(Icons.check_box_outline_blank, color: Colors.black54),
          onPressed: (){},
        ) 
      ];
    }
    return iconButtons; 
  }

  Widget defaultAppBar(){ 
    return AppBar(
      actions: actionList(_currentTab),
      backgroundColor: Color(0xFFfafafa),
      elevation: 0.0,
      title: Padding(
        padding: EdgeInsets.only(left: 120.0),
        child: Text(
          _tabTitle[_currentTab],
          style: TextStyle(
            color: Colors.black54,
            fontFamily: "Google-Sans",
            fontSize: 17.0
          ),
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
          icon: Icon(
            Icons.delete_outline,
            color: Colors.black54,
          ),
          onPressed: (){
            print("Deleted pressed");
          },
        ),
        IconButton(
          icon: Icon(
            Icons.label_outline,
            color: Colors.black54,
          ),
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

  Widget pageView(int currentPage){
    switch (currentPage) {
      case 0:
          return new Container(
            child: new FutureBuilder<List<Recipes>>(
              initialData: [],            
              future: fetchRecipes(searchPerformed, searchCondition),
              builder: (context, snapshot) {   
                if (snapshot.hasData) {
                  if(snapshot.data.length == 0){
                    return Center(
                      child:Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            child: Text("Ich habe deine Rezepte gesucht"),
                            width: 200.0,
                          ),
                          Container(
                            width: 200.0,
                            height: 200.0,
                            child: Image.asset("images/emptyState.jpg"),
                          ),
                          Container(                            
                            child: Padding(
                              padding: EdgeInsets.only(left: 75.0),
                              child: Text("Habe leider keine gefunden."),
                            ),
                            width: 300.0,
                          )
                        ],
                      )
                    );
                  }
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
                        title: (searchController.text.isEmpty
                          ? Text(snapshot.data[index].name)
                          : recipeName(searchCondition, snapshot.data[index].name)
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
          );        
        break;
      case 1:
          return Calendar();
        break;

      case 2:
          return Center(
            child: Text("Shopping List"),
          );
        break;
    }
  }
}