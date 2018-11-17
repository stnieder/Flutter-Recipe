import 'dart:async';

import 'package:Time2Eat/model/Recipe_Shopping.dart';
import 'package:Time2Eat/model/Shopping.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import '../database/database.dart';
import '../interface/GoogleColors.dart';
import '../interface/HexToColor.dart';
import '../model/Ingredients.dart';
import '../model/Recipes.dart';
import '../model/StepDescription.dart';
import '../recipe/new_recipe.dart';


class RecipeDetails extends StatefulWidget{
  final String recipeName;
  RecipeDetails(this.recipeName);

  @override
    State<StatefulWidget> createState() {
      return new _RecipeDetails();
    }
}

class _RecipeDetails extends State<RecipeDetails>{
  GoogleMaterialColors googleMaterialColors = new GoogleMaterialColors();
  ConvertColor convertColor = new ConvertColor();

  int id;  
  String recipeName = "";
  String description;
  Duration duration;
  int peopleDB;
  int currentPeople = 1;
  String imagePath;
  Color backgroundColor;
  bool titleVisibility = false;  

  //Zutaten
  List<double> numberList = new List();
  List<String> measureList = new List();
  List<String> nameList = new List();

  //Zubereitung
  List<String> stepsList = new List();

  @override
    void initState() {
      super.initState();      
      recipeName = widget.recipeName;
    }

  @override
  Widget build(BuildContext context) {          
    return new Scaffold(
      appBar: AppBar(        
        actions: <Widget>[
          FutureBuilder(
            future: fetchRecipe(),
            builder: (BuildContext context, AsyncSnapshot snapshot){
              if(snapshot.hasData){

                int favorite = snapshot.data[0].favorite;

                return IconButton(
                  icon: ( favorite == 0
                    ? Icon(Icons.star_border, color: Colors.black54)
                    : Icon(Icons.star, color: Colors.black54)
                  ),
                  onPressed: (){
                    setState(() {
                      updateFavorite(favorite);
                    });
                  },
                );
              } else if(snapshot.hasError){

                return Text("");
              }
              return Icon(Icons.check_box_outline_blank, color: Colors.black54);
            },
          )
        ],
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0.0,        
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color:  Colors.black54),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        title: Opacity(
          opacity: (titleVisibility
            ? 0.0
            : 1.0
          ),
          child: Text(
            recipeName,
            style: TextStyle(
              color: Colors.black54
            ),
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          CircleAvatar(
            child: (imagePath == "no image"
                ? Container(
              decoration: new BoxDecoration(
                image: new DecorationImage(
                  colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.2), BlendMode.darken),
                  image: AssetImage(imagePath),
                  fit: BoxFit.cover,
                ),
                borderRadius: new BorderRadius.all(new Radius.circular(50.0)),
              ),
            )
                : Text(
                    recipeName[0].toUpperCase(),
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Google-Sans",
                        fontSize: 35.0,
                        fontWeight: FontWeight.w400
                    ),
                  )
            ),
            maxRadius: 40.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 30.0, left: 5.0),
                child: Text(
                  recipeName,
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: "Google-Sans",
                      fontSize: 30.0,
                      fontWeight: FontWeight.w300
                  ),
                ),
              )
            ],
          ),
          Divider(),
          Row(
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.remove),
                onPressed: (){
                  if(currentPeople > 1){
                    setState((){
                      currentPeople--;
                    });
                  }
                },
              ),
              Text(
                  currentPeople == 1
                  ? "1 Person"
                  : currentPeople.toString()+" Personen"
              ),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: (){
                  setState((){
                    currentPeople++;
                  });
                },
              )
            ],
          ),
          FutureBuilder(
            future: fetchIngredients(),
            initialData: [],
            builder: (BuildContext context, AsyncSnapshot snapshot){
              if(snapshot.hasData){
                List<Text> widget_numberList = new List();
                List<Text> widget_measureList = new List();
                List<Text> widget_nameList = new List();

                List<Widget> ingredients = new List();

                double peopleNumber = 1.0;
                fetchRecipe().then((list){
                  if(list[0].people == null) peopleNumber = 1;
                  else peopleNumber = double.parse(list[0].people);
                });

                for(int i=0; i < snapshot.data.length; i++){

                  //For this view
                  widget_numberList.add(Text(((double.parse(snapshot.data[i].number)/peopleNumber)*currentPeople).toString()));
                  widget_measureList.add(Text(snapshot.data[i].measure));
                  widget_nameList.add(Text(snapshot.data[i].name));

                  //For the edit view
                  nameList.add(snapshot.data[i].name);
                  numberList.add(double.parse(snapshot.data[i].number));
                  measureList.add(snapshot.data[i].measure);
                }
                
                for(int i=0; i< widget_numberList.length; i++){
                  ingredients.add(
                    Row(
                      children: <Widget>[
                        widget_numberList[i],
                        widget_measureList[i],
                        widget_nameList[i]
                      ],
                    )
                  );
                }
                
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: ingredients,
                );
                
              } else if(snapshot.hasError){
                return new Text("Keine Daten vorhanden.");
              }
              return new CircularProgressIndicator();
            },
          ),
          MaterialButton(
            onPressed: () => saveShopping(),
            child: Text("Zur Einkaufsliste hinzufügen"),
            animationDuration: Duration(milliseconds: 200),
          ),
          FutureBuilder(
            future: fetchSteps(),
            initialData: [],
            builder: (BuildContext context, AsyncSnapshot snapshot){
              if(snapshot.hasData){
                List<Text> widget_numberList = new List();
                List<Text> widget_descriptionList = new List();
                List<Widget> steps = new List();

                for(int i=0; i < snapshot.data.length; i++){
                  //For this view
                  widget_numberList.add(Text(snapshot.data[i].number.toString()));
                  widget_descriptionList.add(Text(snapshot.data[i].description));

                  //For edit view
                  stepsList.add(snapshot.data[i].description);
                }
                
                for(int i=0; i< widget_numberList.length; i++){
                  steps.add(
                    Row(
                      children: <Widget>[
                        widget_numberList[i],
                        widget_descriptionList[i]
                      ],
                    )
                  );
                }
                
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: steps,
                );
              } else if(snapshot.hasError){
                return new Text("Keine Daten vorhanden.");
              }
              return new CircularProgressIndicator();
            },
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: googleMaterialColors.primaryColor(),
        child: Icon(
          OMIcons.create
        ),
        onPressed: (){
          editRecipe();
        },
      ),
      
    );
  }

  Future saveRecShopping(int shoppingID, DBHelper dbHelper) async{

    RecipeShopping recipeShopping = new RecipeShopping();
    recipeShopping.idShopping = shoppingID;
    recipeShopping.idRecipes = id;

    recipeShopping = await dbHelper.insertRecipeShopping(recipeShopping);
  }

  Future saveShopping() async{
    DBHelper dbHelper = new DBHelper();
    await dbHelper.create();

    ShoppingDB shopping = new ShoppingDB();
    for(int i=0; i<nameList.length; i++){
      print("Failed at item");
      shopping.item = nameList[i];
      shopping.number = numberList[i].toString();
      shopping.measure = measureList[i];
      shopping.checked = 0; // 0 means false
      shopping.timestamp = DateTime.now().toString();
      shopping = await dbHelper.insertShopping(shopping);

      await saveRecShopping(shopping.id, dbHelper);
    }
    showBottomSnack("Zutaten wurden zur Einkaufsliste hinzugefügt", ToastGravity.BOTTOM);
  }

  Future<List<Recipes>> fetchRecipe() async{
    DBHelper dbHelper = new DBHelper();
    var parsedRecipe = await dbHelper.getSpecRecipe(recipeName);
    List<Recipes> recipe = List<Recipes>();
    for(int i=0; i < parsedRecipe.length; i++){
      recipe.add(parsedRecipe[i]);
      id = recipe[i].id;
      description = recipe[i].definition;
      duration = new Duration(minutes: int.parse(recipe[i].duration));
      if(recipe[i].people == null) peopleDB = 1;
      else peopleDB = int.parse(recipe[i].people);
      imagePath = recipe[i].image;
      backgroundColor = convertColor.convertToColor(recipe[i].backgroundColor);      
    }    
    return recipe;
  }

  Future<int> updateFavorite(int favorite)async{
    if(favorite == 0) favorite = 1;
    else if(favorite == 1) favorite = 0;
    print("Updated favorite("+favorite.toString()+")");
    DBHelper dbHelper = new DBHelper();
    int updated = await dbHelper.updateFavorite(recipeName, favorite);
    return updated;
  }

  Future<List<Ingredients>> fetchIngredients() async{
    DBHelper dbHelper = new DBHelper();
    var parsedIngredients = await dbHelper.getIngredients(recipeName);
    List<Ingredients> ingredients = List<Ingredients>();    
    for(int i=0; i< parsedIngredients.length; i++){
      ingredients.add(parsedIngredients[i]);
    }    
    print("Ingredients-Anzahl: "+ingredients.length.toString());
    return ingredients;
  }

  Future<List<Steps>> fetchSteps() async{
    DBHelper dbHelper = new DBHelper();
    await dbHelper.create();
    var parsedSteps = await dbHelper.getSteps(recipeName);
    List<Steps> steps = List<Steps>();
    for(int i=0; i < parsedSteps.length; i++){
      steps.add(parsedSteps[i]);
    }
    print("Steps-Anzahl: "+steps.length.toString());
    return steps;
  }

  Future editRecipe() async{
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => new NewRecipe(
          recipeID: id,
          name: recipeName,
          description: description,
          duration: duration,
          backgroundColor: backgroundColor,
          imagePath: imagePath,
          numberList: numberList,
          measureList: measureList,
          nameList: nameList,
          stepsList: stepsList,
        )
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
}