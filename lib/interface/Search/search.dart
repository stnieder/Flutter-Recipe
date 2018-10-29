import 'dart:async';

import 'package:flutter/material.dart';
import 'package:recipe/database/database.dart';

import 'package:recipe/interface/GoogleDivider.dart';
import 'package:recipe/model/Recipes.dart';
import 'package:recipe/model/SearchHistory.dart';
import 'SearchBox.dart';

Future<List<History>> fetchSearchHistory() async{
  var dbHelper = DBHelper();
  await dbHelper.create();
  Future<List<History>> history = dbHelper.getHistory();
  return history;
}

Future<int> countRecipes() async{
  var dbHelper = DBHelper();
  await dbHelper.create();
  Future<int> recipes = dbHelper.countRecipes();  
  return recipes;
}



class SearchPage extends StatefulWidget{
  @override
    State<StatefulWidget> createState() {
      return _SearchPage();
    }
}

class _SearchPage extends State<SearchPage> with TickerProviderStateMixin{

  TextEditingController searchController = new TextEditingController();

  AnimationController iconController;
  Animation<double> changeAnimation;
  bool changedIcon = false;

  int recipeCount;

  @override
    void initState() {
      super.initState();

      iconController = new AnimationController(vsync: this, duration: Duration(milliseconds: 200))..addListener((){setState(() {});})..addStatusListener((status){
        if(status == AnimationStatus.completed){
          iconController.reverse();
          changedIcon = !changedIcon;
        }
      });

      changeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(CurvedAnimation(parent: iconController, curve: Curves.linear));
      iconController.forward();

      ()async{
        recipeCount = await countRecipes();
        print("Anzahl Rezepte: "+recipeCount.toString());
      };
    }

  @override
    void dispose() {
      super.dispose();
    }

  @override
    Widget build(BuildContext context) {
      return Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxisScrolled){
            return <Widget>[
              SliverAppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Color(0xFFfafafa),
                bottom: PreferredSize(
                  child: Padding(
                    padding: EdgeInsets.only(left: 23.0, right: 5.0),
                    child: GoogleDivider(),
                  ),
                  preferredSize: Size(450.0, 0.5),
                ),
                centerTitle: false,
                expandedHeight: 56.0,
                floating: false,
                pinned: true,
                title: Padding(
                  padding: EdgeInsets.only(top: 3.0, right: 2.0, left: 4.0),
                  child: SearchBox(
                    backgroundColor: Colors.transparent,
                    autofocus: true,
                    addBorder: false,
                    elevation: 0.0,
                    height: 56.0,
                    hintText: "Rezepte suchen",
                    leadingButton: InkWell(
                      onTap: () {
                        if(searchController.text != null){
                          Navigator.pop(context, searchController.text);
                        }
                      },
                      child: FadeTransition(
                        opacity: changeAnimation,
                        child: Padding(
                          padding: EdgeInsets.only(left: 4.0, right: 17.0, bottom: 2.0),
                          child: (changedIcon
                            ? Icon(
                                Icons.arrow_back,
                                color: Colors.black45,
                              )
                            : Icon(
                                Icons.search,
                                color: Colors.black45,
                              )
                          ),
                        ),
                      ),
                    ),
                    width: 450.0,
                  ),
                ),
              )
            ];
          },
          body: Padding(
            padding: EdgeInsets.only(left: 29.0,top: 15.0),
            child: Column(
              children: <Widget>[
                FutureBuilder(
                  future: fetchSearchHistory(),
                  builder: (BuildContext context, AsyncSnapshot snapshot){
                    if(snapshot.hasData){
                      if(snapshot.data.length == 0){
                        return Padding(
                            padding: EdgeInsets.only(top: 20.0),
                            child: InkWell(
                              child: Row(
                                children: <Widget>[
                                  Icon(Icons.report_problem, color: Colors.black45),
                                  Padding(
                                    padding: EdgeInsets.only(left: 15.5),
                                    child: Text(
                                      "Keine Suche durchgeführt",
                                      style: TextStyle(
                                        fontSize: 14.0
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                      }
                      return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index){
                          return Padding(
                            padding: EdgeInsets.only(top: 20.0),
                            child: InkWell(
                              child: Row(
                                children: <Widget>[
                                  Icon(Icons.history, color: Colors.black45),
                                  Padding(
                                    padding: EdgeInsets.only(left: 15.5),
                                    child: Text(
                                      "${snapshot.data[index].searchedFor}",
                                      style: TextStyle(
                                        fontSize: 14.0
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    } else if(snapshot.hasError){
                      Text("${snapshot.error}");
                    }
                    return CircularProgressIndicator();
                  },
                )
              ],
            ),
          ),
        ),
      );
    }
}