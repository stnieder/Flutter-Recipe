import 'package:Time2Eat/database/database.dart';
import 'package:Time2Eat/interface/GoogleColors.dart';
import 'package:Time2Eat/interface/HexToColor.dart';
import 'package:Time2Eat/interface/SelectedRecipe.dart';
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


class RecipeSelection extends StatefulWidget {
  @override
  _RecipeSelection createState() => _RecipeSelection();
}

class _RecipeSelection extends State<RecipeSelection> with TickerProviderStateMixin{
  GoogleMaterialColors googleMaterialColors = new GoogleMaterialColors();
  ConvertColor convert = new ConvertColor();

  bool searchActive = false;
  bool searchPerformed = false;
  String searchCondition = "";
  TextEditingController searchController = new TextEditingController();

  List<String> name = new List();
  List<Color> color = new List();
  List<String> image = new List();
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
          (!selectionActive
            ? Container()
            : selectedAppBar()
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
                  return Container(
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Colors.grey[300], style: BorderStyle.solid)
                      )
                    ),
                    child: ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index){
                          return InkWell(
                            onTap: (){
                              if(!name.contains(snapshot.data[index].name)){
                                ConvertColor convert = new ConvertColor();

                                name.add(snapshot.data[index].name);
                                color.add(convert.convertToColor(snapshot.data[index].backgroundColor));
                                image.add(snapshot.data[index].image);

                                selectionActive = true;

                                setState(() {
                                  searchController.text = "";
                                  searchCondition = "";
                                  fetchRecipes(false, null);
                                });
                              }
                            },
                            child: ListTile(
                                leading: (name.contains(snapshot.data[index].name)
                                  ? returnCheckedRecipes("", convert.convertToColor(snapshot.data[index].backgroundColor), snapshot.data[index].image)
                                  : (snapshot.data[index].image != "no image"
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
                                      : CircleAvatar(
                                    child: Text(
                                      snapshot.data[index].name[0].toUpperCase(),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 21.0,
                                          fontWeight: FontWeight.w400
                                      ),
                                    ),
                                    backgroundColor: convert.convertToColor(snapshot.data[index].backgroundColor),
                                  ))
                                ),
                                  title: Padding(
                                    padding: EdgeInsets.only(top: 0.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        ( searchController.text.isEmpty
                                            ? Text(snapshot.data[index].name)
                                            : recipeName(searchCondition, snapshot.data[index].name)
                                        )
                                      ],
                                    ),
                                  ),
                                )                        
                          );
                        },
                      ),
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: googleMaterialColors.primaryColor().withOpacity(0.9),
        child: Icon(Icons.arrow_forward, color: Colors.white),
        onPressed: (){
          //Move on to termin selection
          if(name.length == 0) showBottomSnack("Sie haben noch kein Rezept ausgewählt", ToastGravity.BOTTOM);
          else {
            Navigator.pop(context, name);
          }
        },

      ),
    );
  }


  changeBool() {
    setState(() {
      if(name.length == 0){
        selectionActive = false;
      } else if(name.length > 0){
        selectionActive = true;
      }
    });
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
      backgroundColor: Colors.white,
      centerTitle: false,
      elevation: 6.0,
      leading: IconButton(
        onPressed: (){
          setState(() {
            searchController.text = "";
            searchCondition = "";
            searchActive = false;
            fetchRecipes(false, null);
          });
        },
        icon: Icon(Icons.arrow_back, color: Colors.black45),
      ),
      title: TextField(
        cursorColor: Colors.white,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintStyle: TextStyle(
              color: Colors.black45
          ),
          hintText: "Rezepte suchen",
        ),
        onChanged: (String text) => searchOperation(text),
      ),
    );
  }

  selectedAppBar(){
    return Container(
      child: Padding(
        padding: EdgeInsets.only(top: 4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Flexible(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: name.length,
                itemBuilder: (BuildContext context, int index){
                  return returnRecipes(name[index], color[index], image[index]);
                },
              ),
            )
          ],
        ),
      ),
      height: 78.0,
      width: MediaQuery.of(context).size.width,
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
              color: googleMaterialColors.primaryColor(),
              fontWeight: FontWeight.bold,
            )
        );
        letters.add(searchedFor);

        Text endPart = Text(
            oldName.substring(end, name.length)
        );
        letters.add(endPart);
      } else {
        Text firstPart = Text(
          oldName[0],
          style: TextStyle(
            fontWeight: FontWeight.bold,
          )
        );
        letters.add(firstPart);

        Text middlePart = Text(
          oldName.substring(1, end),
          style: TextStyle(
            fontWeight: FontWeight.bold,
          )
        );
        letters.add(middlePart);

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

  returnCheckedRecipes(String label, Color backgroundColor, String imagePath){
    return GestureDetector(
      child: SelectedRecipe(
          hasImage: (imagePath != "no image"),
          backgroundImage: (imagePath == null
              ? null
              : AssetImage(imagePath)
          ),
          backgroundColor: (backgroundColor == null
              ? null
              : backgroundColor
          ),
          label: label,
          littleIcon: Container(
            decoration: BoxDecoration(                          
                color: Colors.white,
                shape: BoxShape.circle
            ),
            child: Padding(
              padding: EdgeInsets.only(top: 2.0),
              child: Icon(
                Icons.check_circle,
                size: 18.0,
                color: Colors.green,
              ),
            ),
          ),
          height: 45.0,
          width: 45.0,
      ),
      onTap: (){
          searchController.text = "";
          changeBool();
      },      
    );
  }

  returnRecipes(String label, Color backgroundColor, String imagePath){
    return GestureDetector(
      child: SelectedRecipe(
          hasImage: (imagePath != "no image"),
          backgroundImage: (imagePath == null
              ? null
              : AssetImage(imagePath)
          ),
          backgroundColor: (backgroundColor == null
              ? null
              : backgroundColor
          ),
          label: label.split(" ")[0],
          littleIcon: RotationTransition(
            turns: new AlwaysStoppedAnimation(45 / 360),
            child: Container(
              decoration: BoxDecoration(                          
                  color: Colors.white,
                  shape: BoxShape.circle
              ),
              child: Icon(
                Icons.add_circle,
                size: 18.0,
              ),
            ),
          ),
      ),
      onTap: (){
        if(name.contains(label)){
          int index = name.indexOf(label);
          name.removeAt(index);
          color.removeAt(index);
          image.removeAt(index);
          searchController.text = "";
          changeBool();
        }
      },
    );
  }
}