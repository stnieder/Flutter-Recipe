import 'dart:async';
import 'dart:core';
import 'dart:io';
import 'dart:math';
import 'package:dragable_flutter_list/dragable_flutter_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../database/database.dart';
import 'package:path_provider/path_provider.dart';

import '../interface/DurationDialog.dart'; //made by Chris Harris https://pub.dartlang.org/packages/flutter_duration_picker

import '../interface/CircularImage.dart';
import '../interface/GoogleColors.dart';

import '../Dialogs.dart';

import '../model/Ingredients.dart';
import '../model/Recipe_Ingredient.dart';
import '../model/Recipe_Steps.dart';
import '../model/Recipes.dart';
import '../model/StepDescription.dart';

class NewRecipe extends StatefulWidget{
  //Main
  final int recipeID;
  final String name;
  final String description;
  final Duration duration;
  final String imagePath;
  final Color backgroundColor;

  //Zutaten
  final List<double> numberList;
  final List<String> measureList;
  final List<String> nameList;

  //Zubereitung
  final List<String> stepsList;

  NewRecipe(
    {
       this.recipeID,
       this.name,
       this.description,
       this.duration,
       this.imagePath,
       this.backgroundColor,
       this.numberList,
       this.measureList,
       this.nameList,
       this.stepsList
    }
  );

  @override
  State<StatefulWidget> createState() => _NewRecipe();
}

class _NewRecipe extends State<NewRecipe>{
  Dialogs dialogs = new Dialogs();
  DBHelper db = new DBHelper();
  GoogleMaterialColors materialColors = new GoogleMaterialColors();
  Color usedColor;
  bool edit = false;

  //MainPage
  bool personenError = false;
  bool durationError = false;
  bool zutatenError = false;
  bool zubError = false;
  Duration setDuration;
  String _image;  
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  int personenAnzahl;  

  //Allgemein
  final TextEditingController recipeName = new TextEditingController();
  final TextEditingController recipeDescription = new TextEditingController();

  //Zutaten
  double ingredientHeight = 0.0;
  final TextEditingController zNumberController = new TextEditingController();
  final TextEditingController zNamenController = new TextEditingController();
  List<String> masses = ["Stk.", "kg", "g", "l", "mg", "TL", "EL"];
  List<double> zNumber = [];
  List<String> zMass = [];
  List<String> zNamen = [];
  String selectedMass;  
  Color numberIngredientColor = Colors.blueAccent;

  final GlobalKey<FormFieldState> numberIngredientKey = new GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> nameIngredientKey = new GlobalKey<FormFieldState>();

  //Zubereitung
  double descriptionHeight = 0.0;
  final TextEditingController stepDescriptionController = new TextEditingController();
  GlobalKey<FormState> stepDescriptionKey = new GlobalKey<FormState>();  
  int descriptionCounter = 0;
  List<String> stepDescription = [];


  @override
  void initState(){
    super.initState();

    if(widget.name == null){
      Random random = new Random();
      usedColor = materialColors.getLightColor(random.nextInt(5));
    } else if(widget.name != null){
      recipeName.text = widget.name;
      recipeDescription.text = widget.description;
      setDuration = widget.duration;
      _image = widget.imagePath;
      usedColor = widget.backgroundColor;
      ingredientHeight = 56.0 * widget.numberList.length;
      zNumber = widget.numberList;
      zMass = widget.measureList;
      zNamen = widget.nameList;
      stepDescription = widget.stepsList;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            onPressed: () async{              
              await saveRecipe();
            },
            icon: Icon(
              Icons.check,
              color: Colors.green[400],
            ),
          ),
        ],
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () async{
            var result = await dialogs.closeDialog(context);
            if(result == "verwerfen") Navigator.pop(context);
          },
          icon: Icon(
            Icons.close,
            color: Colors.grey[500],
          ),
        ),
        title: Text(
          "Rezept erstellen",
          style: TextStyle(
              color: Colors.black,
              fontFamily: "Google-Sans",
              fontWeight: FontWeight.normal,
              fontSize: 17.0
          ),
        ),
      ),
      body: ListView(

        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 10.0, bottom: 20.0, left: 179.0, right: 179.0),
            child: GestureDetector(
              child: Container(
                child: (_image == null
                    ? CircleAvatar(child: Icon(OMIcons.addAPhoto))
                    : CircularImage(_image)
                ),
                height: 52.0,
                width: 50.0,
              ),
              onTap: () async{
                String takePhoto = await dialogs.takePhoto(context);
                if(takePhoto == "take") getImage(ImageSource.camera);
                else if(takePhoto == "pick") getImage(ImageSource.gallery);
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 20.0),
              ),
              Container(
                height: 40.0,
                width: 40.0,
                child: InkWell(
                  borderRadius: BorderRadius.circular(10.0),
                  onTap: () async{
                    personenAnzahl = await dialogs.personenAnzahl(context);   
                    if(personenAnzahl == null) personenError = true;
                    setState((){});
                  },
                  child: Column(                                    
                    children: <Widget>[
                      Icon(
                        OMIcons.group,
                        color: (personenError
                          ? materialColors.getLightColor(2)//Red
                          : Colors.black54
                        ),
                      ),
                      Center(child: 
                        Text(
                          (personenAnzahl == null
                            ? "-"
                            : personenAnzahl.toString()),
                          style: new TextStyle(
                            color: (personenError
                              ? materialColors.getLightColor(2)//Red
                              : Colors.black54
                            )
                          ),
                        )
                      )
                    ],
                  ),
                ),
              ),   
              Container(
                decoration: BoxDecoration(
                  color: (durationError
                    ? materialColors.getLightColor(2).withOpacity(0.8)//Red
                    : null
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  shape: BoxShape.rectangle
                ),
                height: 40.0,
                width: 40.0,
                child: InkWell(
                  borderRadius: BorderRadius.circular(10.0),
                  onTap: () async{
                    setDuration = await showDurationPicker(
                        context: context,
                        initialTime: new Duration(minutes: 20)
                    );
                    if(setDuration == null) durationError = true;
                    setState(() {});
                  },
                  child: Column(
                    children: <Widget>[
                      Icon(OMIcons.avTimer),
                      Center(
                        child: Text(setDuration == null
                          ? "-"
                          : setDuration.inMinutes.toString() + "min"
                        ),
                      )
                    ],
                  ),
                ),
              ),            
              
              Padding(
                padding: EdgeInsets.only(right: 20.0),
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.only(left: 20.0, right: 20.0),
            child: Divider(),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(top: 10.0, left: 10.0, bottom: 0.0),
                  child: Text(
                    "Allgemein",
                    style: TextStyle(
                        fontFamily: "Google-Sans",
                        fontWeight: FontWeight.w500,
                        fontSize: 13.0,
                        color: Colors.grey[500]
                    ),
                  )
              ),
              Column(
                children: <Widget>[
                  ListTile(
                    leading: Padding(
                      padding: EdgeInsets.only(bottom: 20.0),
                      child: Icon(OMIcons.fastfood),
                    ),
                    title: TextFormField(
                        autocorrect: true,
                        autovalidate: true,
                        controller: recipeName,
                        decoration: InputDecoration(
                          hintText: "Name",
                        ),
                        maxLength: 30,
                        maxLengthEnforced: true,
                        validator: (value) => checkRecipe(value) ? "Recipe already taken" : null,
                    ),
                  ),
                  ListTile(
                    leading: Padding(
                      padding: EdgeInsets.only(bottom: 20.0),
                      child: Icon(OMIcons.subject),
                    ),
                    title: TextFormField(
                      controller: recipeDescription,
                      decoration: InputDecoration(
                          hintText: "Beschreibe dein Rezept..."
                      ),
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      maxLength: 75,
                      validator: (String text){},
                    ),
                  )
                ],
              ),
              Divider()
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(top: 10.0, left: 10.0, bottom: 0.0),
                  child: Text(
                    "Zutaten",
                    style: TextStyle(
                        fontFamily: "Google-Sans",
                        fontWeight: FontWeight.w500,
                        fontSize: 13.0,
                        color: Colors.grey[500]
                    ),
                  )
              ),
              Column(
                children: <Widget>[
                  ListTile(
                    leading: IconButton(
                      icon: Icon(Icons.close),
                      onPressed: (){
                        changeIngredient("c", 0);
                      },
                      tooltip: "leeren",
                    ),
                    title: Row(
                      children: <Widget>[
                        Container(
                            width: 50.0,
                            child: Padding(
                              padding: EdgeInsets.only(top: 8.0, right: 5.0),
                              child: TextFormField(
                                controller: zNumberController,
                                decoration: InputDecoration(
                                    border: UnderlineInputBorder(                                      
                                      borderRadius: BorderRadius.all(Radius.circular(2.0)),
                                    ),
                                    contentPadding: EdgeInsets.only(bottom: 5.0),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide( 
                                        color: Colors.blue,
                                        style: BorderStyle.solid
                                      ),
                                    ),
                                    hintText: "2.0",                                    
                                ),
                                inputFormatters: [
                                  new BlacklistingTextInputFormatter(new RegExp('[\\,]')),
                                ],
                                key: numberIngredientKey,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                validator: (String text){
                                  if(text.trim().isEmpty) errorMessage("zN");
                                }                                
                              ),
                            )
                        ),
                        Container(
                          child: new DropdownButton(
                            items: masses.map((String value){
                              return new DropdownMenuItem<String>(
                                value: value,
                                child: new Text(
                                    value
                                ),
                              );
                            }).toList(),
                            hint: Text("Maß"),
                            onChanged: (String newValue){
                              setState(() {
                                selectedMass = newValue;
                              });
                            },
                            value: selectedMass,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10.0, top: 8.0),
                          child: Container(
                            width: 100.0,
                            child: TextFormField(
                              controller: zNamenController,
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(bottom: 5.0),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black12, style: BorderStyle.solid),
                                  ),
                                  hintText: "Bezeichnung"
                              ),
                              key: nameIngredientKey,
                              keyboardType: TextInputType.text,                              
                              validator: (String text){
                                if(text.trim().length == 0) errorMessage("zN");
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                    trailing: IconButton(
                      tooltip: "hinzufügen",
                      icon: Icon(Icons.check),
                      onPressed: (){                        
                        if(zNamenController.text.trim().length != 0 && zNumberController.text.trim().length != 0 && selectedMass != null) addIngredients();
                        else errorMessage("zN");
                      },
                    ),
                  ),
                  Container(
                    height: ingredientHeight,
                    child:ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: zNamen.length,
                      itemBuilder: (BuildContext ctxt, int index){
                        final name = zNamen[index];
                        final number = zNumber[index];
                        final mass = zMass[index];

                        return Dismissible(
                          background: Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.only(left: 20.0),
                            color: Colors.redAccent,
                            child: Icon(OMIcons.delete, color: Colors.white),
                          ),
                          secondaryBackground: Container(
                            alignment: Alignment.centerRight,
                            padding: EdgeInsets.only(right: 20.0),
                            color: Colors.orangeAccent,
                            child: Icon(OMIcons.edit, color: Colors.white),
                          ),
                          key: Key(name),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              ListTile(
                                leading: IconButton(
                                  icon: Icon(Icons.remove),
                                  onPressed: (){
                                    changeIngreNumber("m", index);
                                  },
                                ),
                                title: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                        number.toString()+mass+" "+name
                                    )
                                  ],
                                ),
                                trailing: IconButton(
                                    icon: Icon(Icons.add),
                                    onPressed: (){
                                      changeIngreNumber("m", index);
                                    }
                                ),
                              ),
                            ],
                          ),
                          direction: (zNamenController.text.isEmpty
                              ? DismissDirection.horizontal
                              : DismissDirection.startToEnd
                          ),
                          onDismissed: (direction){
                            if(direction == DismissDirection.startToEnd){
                              changeIngredient("d", index);
                            } else if(direction == DismissDirection.endToStart){
                              changeIngredient("e", index);
                            }
                          },
                        );
                      },
                    ),
                  ),
                  Divider(),
                ],
              ),
            ],
          ),
          Column(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(top: 10.0, left: 10.0, bottom: 0.0),
                      child: Text(
                        "Zubereitung",
                        style: TextStyle(
                            fontFamily: "Google-Sans",
                            fontWeight: FontWeight.w500,
                            fontSize: 13.0,
                            color: Colors.grey[500]
                        ),
                      )
                  ),
                  Column(
                    children: <Widget>[
                      Form(
                        child: ListTile(
                          leading: IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: (){},
                          ),
                          title: TextFormField(
                            controller: stepDescriptionController,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Ein Schritt nach dem Anderen"
                            ),
                            validator: (value){
                              if(value.trim().isEmpty){
                                errorMessage("s");
                              } 
                            },
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.check),
                            onPressed: (){
                              if(stepDescriptionController.text.trim().length != 0){
                                changeDescription("a", 0);
                              } else {
                                errorMessage("s");
                              }
                            },
                          ),
                        ),
                        key: stepDescriptionKey,
                      ),
                      Container(
                        height: descriptionHeight,
                        child: DragAndDropList(
                          stepDescription.length,
                          itemBuilder: (BuildContext ctxt, item){
                            return new SizedBox(                                 
                              child: new Dismissible(
                                key: Key(item.toString()),
                                background: Container(
                                  alignment: Alignment.centerLeft,
                                  padding: EdgeInsets.only(left: 20.0),
                                  color: Colors.redAccent,
                                  child: Icon(OMIcons.delete, color: Colors.white),
                                ),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: usedColor.withOpacity(0.3),
                                    child: Text(
                                      (item+1).toString(),
                                      style: TextStyle(
                                        color: usedColor.withGreen(160).withAlpha(1000)
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    stepDescription[item].toString()
                                  ),
                                ),
                                direction: (recipeDescription.text.isEmpty
                                  ? DismissDirection.horizontal
                                  : DismissDirection.startToEnd
                                ),
                                onDismissed: (direction){
                                  if(direction == DismissDirection.startToEnd){
                                    changeDescription("d", item);
                                  } else if(direction == DismissDirection.endToStart){
                                    changeDescription("e", item);
                                  }
                                },
                                secondaryBackground: Container(
                                  alignment: Alignment.centerRight,
                                  padding: EdgeInsets.only(right: 20.0),
                                  color: Colors.orangeAccent,
                                  child: Icon(OMIcons.edit, color: Colors.white),
                                ),
                              ),
                            );
                          },
                          onDragFinish: (before, after){
                            String data = stepDescription[before];
                            stepDescription.removeAt(before);
                            stepDescription.insert(after, data);
                            setState(() {});
                          },
                          canBeDraggedTo: (stepDescription.length > 1
                            ? (one, two) => false
                            : (one, two) => true
                          ),
                          dragElevation: 6.0,
                        ),
                      )
                    ],
                  ),
                  Divider()
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  Future getImage(ImageSource imageSource) async{
    File newImage = await ImagePicker.pickImage(source: imageSource);

    setState(() {
      _image = newImage.path;
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

  void changeDescription(String status, int index){
    if(status == "d"){ //delete
      showBottomSnack("Removed "+stepDescription[index], ToastGravity.BOTTOM);
      descriptionHeight-=56.0;
      stepDescription.removeAt(index);      
    } else if(status == "e"){ //edit
      stepDescriptionController.text = stepDescription[index];
      stepDescription.removeAt(index);
    } else if(status == "a"){ //add      
      stepDescription.add(stepDescriptionController.text.toString());
      descriptionHeight += 56.0;
      stepDescriptionController.clear();
    }

    setState(() {});
  }

  void changeIngreNumber(String status,int index){
    if(status == "p") { //plus 1
      zNumber[index]++;
    } else if(status == "m"){ //minus 1
      if(zNumber[index] > 0.0){
        zNumber[index]--;
      } else if(zNumber[index] == 0.0){
        changeIngredient("d", index);
      }
    }

    setState(() {});
  }


  void addIngredients(){
    if(zNamenController.text.trim().isEmpty || zNumberController.text.toString().trim().isEmpty || selectedMass == null){
      errorMessage("zN");
    } else {
      ingredientHeight += 56.0;
      zNumber.add(double.parse(zNumberController.text));
      zNumberController.clear();

      zMass.add(selectedMass);
      selectedMass = null;

      print("Name der Zutate: "+zNamenController.text);
      zNamen.add(zNamenController.text);
      zNamenController.clear();
    }    
  }


  void changeIngredient(String status, int index){
    if(status == "d"){ //delete

      ingredientHeight -= 56.0;
      zNamen.removeAt(index);
      zMass.removeAt(index);
      zNumber.removeAt(index);
    } else if(status == "e"){ //edit
      if(zNamenController.text.isEmpty){
        zNamenController.text = zNamen[index];
        zNumberController.text = zNumber[index].toString();
        selectedMass = zMass[index];

        zNamen.removeAt(index);
        zMass.removeAt(index);
        zNumber.removeAt(index);
      }    
    } else if(status == "c"){ //clear controller
      zNumberController.clear();
      selectedMass = null;
      zNamenController.clear();
    } else if(status == "a"){ //add
      ingredientHeight += 56.0;
      zNumber.add(double.parse(zNumberController.text));
      zNumberController.clear();

      zMass.add(selectedMass);
      selectedMass = null;

      zNamen.add(zNamenController.text);
      zNamenController.clear();
    }

    setState(() {});
  }

  errorMessage(String input){
    if(input == "p"){ //personenAnzahl is empty
      personenError = true;
    } else if(input == "d"){ //duration is empty
      durationError = true;
    } else if(input == "zN"){
      showBottomSnack("Zutat kann nicht leer sein.", ToastGravity.CENTER);
    } else if(input == "s"){
      showBottomSnack("Zubereitung darf nicht leer sein.", ToastGravity.CENTER);
    }
    setState(() {});
  }

  controlInput() async{
    bool returnValue = true; //true --> Rezept speichern
    if(personenAnzahl == null) {
      returnValue = false;
      await errorMessage("p");
    }
    if(setDuration == null) {
      returnValue = false;
      await errorMessage("d");
    }
    if(zNamen.length == 0) {
      returnValue = false;
      await errorMessage("zN");
    }
    if(stepDescription.length == 0) {
      returnValue = false;
      await errorMessage("s");
    }    
    return returnValue;
  }

  Future saveRecStepsIDs(int recipeID, int stepsID) async{
    RecipeSteps ids = new RecipeSteps();
    ids.idRecipes = recipeID;
    ids.idSteps = stepsID;

    ids = await db.insertRecipeSteps(ids);
  }

  Future saveSteps(int recipeID, int i) async{
    StepsDB steps = new StepsDB();
    steps.number = (i + 1);
    steps.description = stepDescription[i];
    steps = await db.insertSteps(steps);

    await saveRecStepsIDs(recipeID, steps.id);
  }

  Future saveRecIngreIDs(int recipeID, int ingredientID) async{
    RecIngre ids = new RecIngre();
    ids.idRecipes = recipeID;
    ids.idIngredients = ingredientID;

    await db.insertRecIngre(ids);
  }


  Future saveIngredients(int recipeID, int i) async{
    IngredientsDB ingredients = new IngredientsDB();
    ingredients.name = zNamen[i];
    ingredients.number = zNumber[i].toString();
    ingredients.measure = zMass[i];

    print("IngreName: "+ingredients.name);

    ingredients = await db.insertIngre(ingredients);

    await saveRecIngreIDs(recipeID, ingredients.id);
  }

  Future saveRecipe() async{
    if(controlInput() == false){
      showBottomSnack("Bitte alle nötigen Parameter ausfüllen", ToastGravity.CENTER);
    } else {

      await db.create();
      RecipesDB recipe = new RecipesDB();
      recipe.name = recipeName.text;
      recipe.definition = recipeDescription.text;
      recipe.duration = setDuration.inMinutes.toString();
      recipe.timestamp = DateTime.now().toString();
      recipe.favorite = 0;      
      
      if(_image != null){
        Directory directory = await getApplicationDocumentsDirectory();
        String path = directory.path;
        await File(_image).copy('$path/${recipeName.text}.png');
        recipe.image = '$path/${recipeName.text}.png';
      } else {
        recipe.image = "no image";
      }

      recipe.backgroundColor = usedColor.toString();

      recipe = await db.insertRecipe(recipe);

      if(recipe.id == null) await db.deleteLatest();
      else {
        for(int i=0; i < zNamen.length; i++){
          await saveIngredients(recipe.id, i);
        }        

        for(int i=0; i < stepDescription.length; i++){
          await saveSteps(recipe.id, i);
        }        
        
        Navigator.pop(context, "saved");
        showBottomSnack("Rezept erfolgreich gespeichert", ToastGravity.BOTTOM);
      }      
    }    
  }

  bool _recExist = false;
  checkRecipe<bool>(String name) {
    db.create().then((nothing){
      db.checkRecipe(name).then((val){
        if(val > 0) {
          setState(() {
            _recExist = true;
          });
        } else {          
          setState(() {
            _recExist = false;
          });
        }
      });
    });
    return _recExist;
  }
}