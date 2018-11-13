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

  List<String> selectedName = [];
  List<Color> selectedColor = [];
  List<String> selectedImage = [];
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
                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index){
                      return InkWell(
                        onTap: (){
                          ConvertColor convert = new ConvertColor();

                          selectedName.add(snapshot.data[index].name);
                          selectedColor.add(convert.convertToColor(snapshot.data[index].backgroundColor));
                          selectedImage.add(snapshot.data[index].image);

                          selectionActive = true;

                          setState(() {
                            searchController.text = "";
                            searchCondition = "";
                            fetchRecipes(false, null);
                          });

                          print("SelectedRecipe label: "+snapshot.data[index].name);
                        },
                        child: (selectedName.contains(snapshot.data[index].name)
                          ? Container()
                          : ListTile(
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
                        )
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: googleMaterialColors.primaryColor().withOpacity(0.9),
        child: Icon(Icons.arrow_forward, color: Colors.white),
        onPressed: (){
          //Move on to termin selection
          if(selectedName.length == 0) showBottomSnack("Sie haben noch kein Rezept ausgewählt", ToastGravity.BOTTOM);
        },

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
            searchController.text = "";
            searchCondition = "";
            searchActive = false;
            fetchRecipes(false, null);
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
        onChanged: (String text) => searchOperation(text),
      ),
    );
  }

  selectedAppBar(){
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      elevation: 0.5,
      title: Padding(
        padding: EdgeInsets.only(top: 4.0),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: selectedName.length,
          itemBuilder: (BuildContext context, int index){
            return returnRecipes(selectedName[index], selectedColor[index], selectedImage[index]);
          },
        ),
      ),
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
      }
    }

    wholeName = Row(
        children: letters
    );

    return wholeName;
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
          label: label
      ),
      onTap: (){
        setState(() {
          selectedName.remove(label);
          selectedColor.remove(backgroundColor);
          selectedImage.remove(imagePath);

          if(selectedName.isEmpty) {
            selectionActive = false;
          }
          searchController.text = "";
        });
      },
    );
  }
}
