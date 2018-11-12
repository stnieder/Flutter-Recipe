import 'package:Time2Eat/database/database.dart';
import 'package:Time2Eat/interface/Custom_SideHeaderListView.dart';
import 'package:Time2Eat/interface/GoogleColors.dart';
import 'package:Time2Eat/interface/HexToColor.dart';
import 'package:Time2Eat/interface/SelectedRecipe.dart';
import 'package:Time2Eat/model/Recipes.dart';
import 'package:flutter/material.dart';
import 'dart:math';


Future<List<Recipes>> fetchRecipes(bool searched, String recipeName) async{
  var dbHelper = DBHelper();
  await dbHelper.create();
  Future<List<Recipes>> recipes;
  if(searched) recipes = dbHelper.filterRecipes(recipeName);
  else recipes = dbHelper.getRecipes();

  return recipes;
}



class RecipeSelection extends StatefulWidget {
  @override
  _RecipeSelection createState() => _RecipeSelection();
}

class _RecipeSelection extends State<RecipeSelection> with TickerProviderStateMixin{
  GoogleMaterialColors googleMaterialColors = new GoogleMaterialColors();

  bool searchActive = false;
  bool searchPerformed = false;
  String searchCondition = "";
  TextEditingController searchController = new TextEditingController();

  List<Widget> selectedRecipes = [];
  List<String> controlSelection = new List();
  bool selectionActive;

  @override
  void initState() {
    super.initState();
    selectionActive = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (searchActive
        ? searchAppBar()
        : defaultAppBar()
      ),
      body: Column(
        children: <Widget>[
          (selectedRecipes.length == 0
            ?Container()
            : AppBar(
            title: Row(
            children: selectedRecipes,
      ),
    )
          ),
          Flexible(
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
                            width: 200.0,
                            height: 200.0,
                            child: Text("hier kommt ein bild hinein")//Image.asset("images/nothingFound.png"),
                          ),
                          Container(
                            child: Padding(
                              padding: EdgeInsets.only(left: 75.0),
                              child: Text("Es wurden keine Rezepte gefunden."),
                            ),
                            width: 300.0,
                          )
                        ],
                      )
                    );
                  }
                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index){
                      return InkWell(
                        onTap: (){
                          String backgroundImage;
                          Color backgroundColor;
                          ConvertColor convert = new ConvertColor();

                          if(snapshot.data[index].image != "no image") {
                            backgroundImage = snapshot.data[index].image;
                            backgroundColor = null;
                          }
                          else {
                            backgroundColor = convert.convertToColor(snapshot.data[index].backgroundColor);
                            backgroundImage = null;
                          }

                          var selected = GestureDetector(
                            child: SelectedRecipe(
                                hasImage: (snapshot.data[index].image != "no image"),
                                backgroundImage: AssetImage(backgroundImage),
                                backgroundColor: backgroundColor,
                                label: snapshot.data[index].name
                            ),
                            onTap: (){
                              setState(() {
                                controlSelection.remove(snapshot.data[index].name);
                                if(controlSelection.isEmpty) selectionActive = false;
                              });
                            },
                          );
                          setState(() {
                            selectedRecipes.add(selected);
                            print("Added. Counting now: "+selectedRecipes.length.toString());
                            selectionActive = true;
                            controlSelection.add(snapshot.data[index].name);
                          });
                        },
                        child: (selectionActive == false && !controlSelection.contains(snapshot.data[index].name)
                          ? ListTile(
                            leading: snapshot.data[index].image != "no image"
                                ? Container(
                              width: 40.0,
                              height: 40.0,
                              decoration: new BoxDecoration(
                                image: new DecorationImage(
                                  colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.2), BlendMode.darken),
                                  image: AssetImage(snapshot.data[index].image),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: new BorderRadius.all(new Radius.circular(50.0)),
                              ),
                            )
                                : Text(
                              snapshot.data[index].name[0].toUpperCase(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 21.0,
                                  fontWeight: FontWeight.w400
                              ),
                            ),
                            title: Padding(
                              padding: EdgeInsets.only(top: 0.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(snapshot.data[index].name)
                                ],
                              ),
                            ),
                          )
                          : Container()
                        ),
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
          )
        ],
      ),
    );
  }


  defaultAppBar(){
    return AppBar(
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.search,
            color: Colors.black45,
          ),
          onPressed: () {
            setState(() {
              searchActive = true;
            });
          },
        )
      ],
      backgroundColor: Colors.white,
      elevation: 2.0,
      leading: IconButton(
        icon: Icon(Icons.close, color: Colors.black45),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        "Rezept auswählen...",
        style: TextStyle(
            color: Colors.black,
            fontFamily: "Google-Sans",
            fontSize: 18,
            fontWeight: FontWeight.w400
        ),
      ),
    );
  }

  searchAppBar(){
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: googleMaterialColors.primaryColor().withOpacity(0.7),
      centerTitle: false,
      elevation: 6.0,
      leading: IconButton(
        onPressed: (){
          setState(() {
            searchActive = false;
          });
        },
        icon: Icon(Icons.arrow_back, color: Colors.white),
      ),
      title: TextField(
        cursorColor: Colors.white,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintStyle: TextStyle(
            color: Colors.white.withOpacity(0.7)
          ),
          hintText: "Suchen..."
        ),
      ),
    );
  }
}
