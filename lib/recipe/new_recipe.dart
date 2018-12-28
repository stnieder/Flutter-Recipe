import 'dart:async';
import 'dart:core';
import 'dart:io';
import 'dart:math';
import 'package:Time2Eat/customizedWidgets/RadialMinutes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:dragable_flutter_list/dragable_flutter_list.dart';

import '../database/database.dart';
import 'package:path_provider/path_provider.dart';

import '../customizedWidgets/DurationDialog.dart'; //made by Chris Harris https://pub.dartlang.org/packages/flutter_duration_picker

import '../customizedWidgets/CircularImage.dart';
import '../customizedWidgets/GoogleColors.dart';

import '../DialogInterfaces/Dialogs.dart';

import '../databaseModel/Ingredients.dart';
import '../databaseModel/Recipe_Ingredient.dart';
import '../databaseModel/Recipe_Steps.dart';
import '../databaseModel/Recipes.dart';
import '../databaseModel/StepDescription.dart';

class NewRecipe extends StatefulWidget{
  
  //Main
  final int recipeID;
  final String name;
  final String description;
  final Duration preperation_duration;
  final Duration creation_duration;
  final Duration resting_duration;
  final String imagePath;
  final Color backgroundColor;
  final int personenAnzahl;

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
       this.preperation_duration,
       this.creation_duration,
       this.resting_duration,
       this.imagePath,
       this.backgroundColor,
       this.numberList,
       this.measureList,
       this.nameList,
       this.stepsList,
       this.personenAnzahl
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
  String oldRecipe;

  //MainPage
  bool personenError = false;
  bool prepError = false;
  bool creaError = false;
  bool restError = false;
  bool zutatenError = false;
  bool zubError = false;
  bool recipeTaken = false;
  Duration prepDuration;
  Duration creaDuration;
  Duration restDuration;
  double prep_percentage = 0.0;
  double crea_percentage = 0.0;
  double rest_percentage = 0.0;
  int preperation_minutes = 0;
  int creation_minutes = 0;
  int resting_minutes = 0;
  String _image;  
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  int personenAnzahl;  

  //Allgemein
  final TextEditingController recipeName = new TextEditingController();
  final TextEditingController recipeDescription = new TextEditingController();  
  FocusNode nameFocus = new FocusNode();
  final ScrollController bodyScroll = new ScrollController();
  double appBarElevation = 0.0;
  final GlobalKey<State<AppBar>> appBarKey = new GlobalKey<State<AppBar>>();

  //Zutaten
  double ingredientHeight = 0.0;
  final TextEditingController zNumberController = new TextEditingController();
  final TextEditingController zNamenController = new TextEditingController();
  List<String> masses = ["Stk.", "Handvoll", "Prise" "kg", "g", "l", "mg", "TL", "EL"];
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
  List<String> stepDescription;


  @override
  void initState(){
    super.initState();

    if(widget.name == null){
      Random random = new Random();
      usedColor = materialColors.getLightColor(random.nextInt(5));
      stepDescription = new List();
    } else if(widget.name != null){
      oldRecipe = widget.name;

      recipeName.text = widget.name;
      recipeDescription.text = widget.description;
      prepDuration = widget.preperation_duration;
      prep_percentage = (prepDuration.inMinutes / 60) * 100;
      preperation_minutes = widget.preperation_duration.inMinutes;
      creaDuration = widget.creation_duration;
      crea_percentage = (creaDuration.inMinutes / 60) * 100;
      creation_minutes = widget.preperation_duration.inMinutes;
      restDuration = widget.resting_duration;
      rest_percentage = (restDuration.inMinutes / 60) * 100;
      resting_minutes =  widget.resting_duration.inMinutes;
      _image = widget.imagePath;
      usedColor = widget.backgroundColor;
      ingredientHeight = 56.0 * widget.numberList.length;
      zNumber = widget.numberList;
      zMass = widget.measureList;
      zNamen = widget.nameList;      
      stepDescription = widget.stepsList; 
      descriptionHeight = 56.0 * stepDescription.length;
      personenAnzahl = widget.personenAnzahl;
      edit = true;
    }    

    bodyScroll.addListener(_scrollListener);
  }

  _scrollListener(){
    if(bodyScroll.offset > bodyScroll.initialScrollOffset){
      appBarKey.currentState.setState((){
        appBarElevation = 4.0;
      });
    } else {
      appBarKey.currentState.setState((){
        appBarElevation = 0.0;
      });
    }
  }

  @override
  Widget build(BuildContext context) { 
    return Scaffold(      
      key: _scaffoldKey,
      appBar: PreferredSize(
        preferredSize: Size(MediaQuery.of(context).size.width, 56.0),
        child: StatefulBuilder(
          key: appBarKey,
          builder: (context, update){
            return AppBar(
              actions: <Widget>[
                IconButton(
                  onPressed: () async{              
                    await saveRecipe(update);
                  },
                  icon: Icon(
                    Icons.check,
                    color: Colors.green[400],
                  ),
                ),
              ],
              backgroundColor: Colors.white,
              elevation: appBarElevation,
              leading: IconButton(
                onPressed: () async{
                  String title;
                  if(edit) title = "Deine Änderungen werden nicht gespeichert.";
                  else title = "Dein Rezept wird nicht gespeichert";
                  var result = await dialogs.closeDialog(context, title);
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
            );
          },
        ),
      ),
      body: ListView(
        controller: bodyScroll,
        children: <Widget>[
          StatefulBuilder(
            builder: (BuildContext context, StateSetter update){
              return Padding(
                padding: EdgeInsets.only(top: 10.0, bottom: 20.0, left: 179.0, right: 179.0),
                child: GestureDetector(
                  child: Container(
                    child: ((_image == "no image" || _image == null)
                        ? CircleAvatar(child: Icon(OMIcons.addAPhoto))
                        : CircularImage(_image)
                    ),
                    height: 52.0,
                    width: 50.0,
                  ),
                  onTap: () async{
                    String takePhoto = await dialogs.takePhoto(context);
                    if(takePhoto == "take") getImage(ImageSource.camera, update);
                    else if(takePhoto == "pick") getImage(ImageSource.gallery, update);
                  },
                ),
              );
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left:5.0),
              ),
              StatefulBuilder(
                builder: (BuildContext context, StateSetter update){
                  return Container(
                    height: 43.0,
                    width: 40.0,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10.0),
                      onTap: () async{
                        int oldAnzahl = personenAnzahl;
                        personenAnzahl = await dialogs.personenAnzahl(context);   
                        if(personenAnzahl == null && oldAnzahl == null){
                          update(() {
                            personenError = true;
                          });
                        } else {
                          update(() {
                            personenError = false;
                          });
                        }
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
                  );
                },
              ),
              StatefulBuilder(
                builder: (context, update){
                  return InkWell(
                    onTap: () async{
                      prepDuration = await showDurationPicker(
                          context: context,
                          initialTime: new Duration(minutes: 20)
                      );
                      if(prepDuration == null && preperation_minutes == null) prepError = true;
                      else {
                        prepError = false;
                        preperation_minutes = prepDuration.inMinutes;
                        prep_percentage = (preperation_minutes / 60)*100;
                      }
                      update((){});
                    },
                    child: Column(
                      children: <Widget>[
                        RadialMinutes(
                          minutes: double.parse(preperation_minutes.toString()),
                          radius: 65.0,
                          center:Text(
                            (preperation_minutes == 0.0 || preperation_minutes == null
                              ? "-"
                              : preperation_minutes.toString()+" Min."
                            ),
                            style: TextStyle(
                              fontFamily: "Google-Sans",
                              fontSize: 15.0,
                              fontWeight: FontWeight.w500
                            ),
                          ),
                          lineColor: (prepError
                            ? Colors.red
                            : Colors.grey[400]
                          ),
                          completeColor: Colors.amber
                        ),
                        _radialText("Zubereitung")
                      ],
                    ),
                  );
                },
              ),
              StatefulBuilder(
                builder: (context, update){
                  return InkWell(
                    onTap: () async{
                      creaDuration = await showDurationPicker(
                          context: context,
                          initialTime: new Duration(minutes: 20)
                      );
                      if(creaDuration == null && creation_minutes == null) creaError = true;
                      else {
                        creaError = false;
                        creation_minutes = creaDuration.inMinutes;
                        crea_percentage = (creation_minutes / 60)*100;
                      }
                      update((){});
                    },
                    child: Column(
                      children: <Widget>[
                        RadialMinutes(
                          minutes: double.parse(creation_minutes.toString()),
                          radius: 65.0,
                          center: Text(
                            (creation_minutes == 0.0 || creation_minutes == null
                              ? "-"
                              : creation_minutes.toString()+" Min."
                            ),
                            style: TextStyle(
                              fontFamily: "Google-Sans",
                              fontSize: 15.0,
                              fontWeight: FontWeight.w500
                            ),
                          ),
                          lineColor: (creaError
                            ? Colors.red
                            : Colors.grey[400]
                          ),
                          completeColor: Colors.amber
                        ),
                        _radialText("Kochzeit")
                      ],
                    ),
                  );
                },
              ),   
              StatefulBuilder(
                builder: (context, update){
                  return InkWell(
                    onTap: () async{
                      restDuration = await showDurationPicker(
                          context: context,
                          initialTime: new Duration(minutes: 20)
                      );
                      if(restDuration == null && resting_minutes == null) restError = true;
                      else {
                        restError = false;
                        resting_minutes = restDuration.inMinutes;
                        rest_percentage = (resting_minutes / 60)*100;
                      }
                      update(() {});
                    },
                    child: Column(
                      children: <Widget>[
                        RadialMinutes(
                          minutes: double.parse(resting_minutes.toString()),
                          radius: 65.0,
                          center:Text(
                            (resting_minutes == 0.0 || resting_minutes == null
                              ? "-"
                              : resting_minutes.toString()+" Min."
                            ),
                            style: TextStyle(
                              fontFamily: "Google-Sans",
                              fontSize: 15.0,
                              fontWeight: FontWeight.w500
                            ),
                          ),
                          lineColor: (restError
                            ? Colors.red
                            : Colors.grey[400]
                          ),
                          completeColor: Colors.amber
                        ),
                        _radialText("Ruhezeit")
                      ],
                    ),
                  );
                },
              ),
              Padding(
                padding: EdgeInsets.only(right: 5.0),
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
              StatefulBuilder(
                builder: (context, update){
                  return Column(
                    children: <Widget>[
                      ListTile(
                        leading: Padding(
                          padding: EdgeInsets.only(bottom: 20.0),
                          child: Icon(OMIcons.fastfood),
                        ),
                        title: TextFormField(
                            autocorrect: nameFocus.hasFocus,
                            autovalidate: nameFocus.hasFocus,
                            controller: recipeName,
                            decoration: InputDecoration(
                              hintText: "* Name",
                            ),
                            focusNode: nameFocus,
                            maxLength: 50,
                            maxLengthEnforced: true,
                            validator: (value) => checkRecipe(value, update) 
                              ? (edit ? null : "Dieser Name ist schon vergeben")
                              : null
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
                          maxLength: 150
                        ),
                      )
                    ],
                  );
                },
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
                    "* Zutaten",
                    style: TextStyle(
                        fontFamily: "Google-Sans",
                        fontWeight: FontWeight.w500,
                        fontSize: 13.0,
                        color: (zutatenError == false || (zNumberController.text.length != 0 && selectedMass != null && zNamenController.text.length != 0)
                          ? Colors.grey[500]
                          : Colors.red
                        )
                    ),
                  )
              ),
              Column(
                children: <Widget>[
                  StatefulBuilder(
                    builder: (context, update){
                      return ListTile(
                        leading: IconButton(
                          icon: Icon(Icons.close),
                          onPressed: (){
                            changeIngredient("c", 0, update);
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
                                      if(text.trim().isEmpty) errorMessage("zN", update);
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
                                  update(() {
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
                                        borderSide: BorderSide(
                                          color: Colors.black12, style: BorderStyle.solid
                                        ),
                                      ),
                                      hintText: "Bezeichnung"
                                  ),
                                  key: nameIngredientKey,
                                  keyboardType: TextInputType.text,                              
                                  validator: (String text){
                                    if(text.trim().length == 0) errorMessage("zN", update);
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
                            if(zNamenController.text.trim().length != 0 && zNumberController.text.trim().length != 0 && selectedMass != null) addIngredients(update);
                            else errorMessage("zN", update);
                          },
                        ),
                      );
                    },
                  ),
                  StatefulBuilder(
                    builder: (BuildContext context, update){
                      return Container(
                        height: ingredientHeight,
                        child:ListView.builder(
                          physics: (zNamen.length == 1
                            ? NeverScrollableScrollPhysics()
                            : ScrollPhysics()
                          ),
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
                                        changeIngreNumber("m", index, update);
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
                                          changeIngreNumber("m", index, update);
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
                                  changeIngredient("d", index, update);
                                } else if(direction == DismissDirection.endToStart){
                                  changeIngredient("e", index, update);
                                }
                              },
                            );
                          },
                        ),
                      );
                    },
                  ),
                  Divider(),
                ],
              ),
            ],
          ),
          Column(
            children: <Widget>[
              StatefulBuilder(
                builder: (context, update){
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(top: 10.0, left: 10.0, bottom: 0.0),
                          child: Text(
                            "* Zubereitung",
                            style: TextStyle(
                                fontFamily: "Google-Sans",
                                fontWeight: FontWeight.w500,
                                fontSize: 13.0,
                                color: (zubError == false || stepDescriptionController.text.length != 0
                                  ? Colors.grey[500]
                                  : Colors.red
                                )
                            ),
                          )
                      ),
                      Column(
                        children: <Widget>[
                          Form(
                            child: ListTile(
                              leading: IconButton(
                                icon: Icon(Icons.clear),
                                onPressed: (){
                                  update(() {
                                    stepDescriptionController.text = "";
                                  });
                                },
                              ),
                              title: TextFormField(
                                controller: stepDescriptionController,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Ein Schritt nach dem Anderen"
                                ),
                                validator: (value){
                                  if(value.trim().isEmpty){
                                    errorMessage("s", update);
                                  } 
                                },
                              ),
                              trailing: IconButton(
                                icon: Icon(Icons.check),
                                onPressed: (){
                                  if(stepDescriptionController.text.trim().length != 0){
                                    bool add = false;
                                    for (var i = 0; i < stepDescription.length; i++) {
                                      if(stepDescriptionController.text.trim() == stepDescription[i]) add = true;                                      
                                    }
                                    if(!add){
                                      changeDescription("a", 0, update);
                                      update(() {
                                        zubError = false;
                                      });
                                    } else {
                                      showBottomSnack("Dieser Schritt ist schon vorhanden", ToastGravity.BOTTOM);
                                    }
                                  } else {                                
                                    errorMessage("s", update);
                                    update(() {
                                      zubError = true;
                                    });
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
                              itemBuilder: (BuildContext context, index){
                                final step = stepDescription[index];
                                return new Container( 
                                  decoration: BoxDecoration(
                                    color: Colors.white,                                    
                                    border: Border(                                      
                                      top: BorderSide(
                                        width: .08,
                                        color: (index == 0
                                          ? Colors.white
                                          : Colors.black54
                                        )
                                      ),
                                      bottom: BorderSide(
                                        width: .08,
                                        color: (index == stepDescription.length-1
                                          ? Colors.white
                                          : Colors.black54
                                        )
                                      )
                                    )
                                  ),                                      
                                  child: new Dismissible(
                                    key: Key(index.toString()),
                                    background: Container(
                                      alignment: Alignment.centerLeft,
                                      padding: EdgeInsets.only(left: 20.0),
                                      color: Colors.redAccent,
                                      child: Icon(OMIcons.delete, color: Colors.white),
                                    ),
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        backgroundColor: usedColor.withOpacity(0.8),
                                        child: Text(
                                          (index+1).toString(),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold
                                          ),
                                        ),
                                      ),
                                      title: Text(
                                        step
                                      ),
                                    ),
                                    direction: (stepDescriptionController.text.isEmpty
                                      ? DismissDirection.horizontal
                                      : DismissDirection.startToEnd
                                    ),
                                    onDismissed: (direction){
                                      if(direction == DismissDirection.startToEnd){
                                        changeDescription("d", index, update);
                                      } else if(direction == DismissDirection.endToStart){
                                        changeDescription("e", index, update);
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
                              },
                              canDrag: (index){
                                return true;
                              },
                              canBeDraggedTo: (one, two) => true,
                              dragElevation: 4.0,
                            ),
                          )
                        ],
                      ),
                      Divider()
                    ],
                  );
                },
              )
            ],
          )
        ],
      ),
    );
  }

  Future getImage(ImageSource imageSource, StateSetter update) async{
    File newImage = await ImagePicker.pickImage(source: imageSource);

    update(() {
      _image = (newImage.path);
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

  void changeDescription(String status, int index, StateSetter update){
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

    update(() {});
  }

  void changeIngreNumber(String status,int index, StateSetter update){
    if(status == "p") { //plus 1
      zNumber[index]++;
    } else if(status == "m"){ //minus 1
      if(zNumber[index] > 1.0){
        zNumber[index]--;
      } else if(zNumber[index] == 1.0){
        changeIngredient("d", index, update);
      }
    }

    update(() {});
  }


  void addIngredients(StateSetter update){
    if(zNamenController.text.trim().isEmpty || zNumberController.text.toString().trim().isEmpty || selectedMass == null){
      errorMessage("zN", update);
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


  void changeIngredient(String status, int index, StateSetter update){
    if(status == "d"){ //delete

      ingredientHeight -= 56.0;
      zNamen.removeAt(index);
      zMass.removeAt(index);
      zNumber.removeAt(index);
    } else if(status == "e"){ //edit
      if(zNamenController.text.isEmpty){
        ingredientHeight -= 56.0;

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

    update(() {});
  }

  errorMessage(String input, StateSetter update){
    if(input == "p"){ //personenAnzahl is empty
      personenError = true;
    } else if(input == "prepD"){ //duration is empty
      prepError = true;
    } else if(input == "creaD"){ //duration is empty
      creaError = true;
    } else if(input == "restD"){ //duration is empty
      restError = true;
    } else if(input == "zN"){ // no ingredient
      zutatenError = true;
      showBottomSnack("Zutat kann nicht leer sein.", ToastGravity.BOTTOM);
    } else if(input == "s"){ // no steps
      zubError = true;
      showBottomSnack("Zubereitung darf nicht leer sein.", ToastGravity.BOTTOM);
    } else if(input == "t"){ //Recipe name already taken
      recipeTaken = true;
      showBottomSnack("Ein Rezept mit diesem Namen ist schon vorhanden.", ToastGravity.BOTTOM);
    }
    update(() {});
  }

  controlInput(StateSetter update) async{
    bool returnValue = true; //true --> Rezept speichern
    if(personenAnzahl == null) {
      returnValue = false;
      await errorMessage("p", update);
    }
    if(prepDuration == null) {
      returnValue = false;
      await errorMessage("prepD", update);
    }
    if(creaDuration == null){
      returnValue = false;
      await errorMessage("creaD", update);
    }
    if(creaDuration == null){
      returnValue = false;
      await errorMessage("restD", update);
    }
    if(zNamen.length == 0) {
      returnValue = false;
      await errorMessage("zN", update);
    }
    if(stepDescription.length == 0) {
      returnValue = false;
      await errorMessage("s", update);
    }  
    if(recipeTaken == true && edit != true)  {
      returnValue = false;
      await errorMessage("t", update);
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

  Future saveRecipe(StateSetter update) async{
    if(await controlInput(update) != false){

      await db.create();
      RecipesDB recipe = new RecipesDB();
      recipe.name = recipeName.text;
      if(recipeDescription.text.trim().isEmpty) recipe.definition = "nothing";
      else recipe.definition = recipeDescription.text;
      recipe.pre_duration = prepDuration.inMinutes.toString();
      recipe.cre_duration = creaDuration.inMinutes.toString();
      recipe.resting_time = restDuration.inMinutes.toString();
      recipe.people = personenAnzahl.toString();
      recipe.timestamp = DateTime.now().toString();
      recipe.favorite = 0;      
      
      if(_image != null){ 
        Directory directory = await getApplicationDocumentsDirectory();
        String path = directory.path.replaceAll(new RegExp(r"\s+\b|\b\s"), String.fromCharCode(95)); //95 from ASCII is '_'
        String image = (recipeName.text).replaceAll(new RegExp(r"\s+\b|\b\s"), String.fromCharCode(95));
        await File(_image).copy('$path/$image.png');
        recipe.image = '$path/$image.png';
      } else {
        recipe.image = "no image";
      }

      recipe.backgroundColor = usedColor.toString();

      if(edit) {
        recipe = await db.updateRecipe(recipe, oldRecipe);
        recipe.id = await db.getRecipeID(recipe.name);
        await db.deleteIngre(recipeName.text);
        await db.deleteSteps(recipeName.text);
      } else {
        recipe = await db.insertRecipe(recipe);
      }

      if(recipe.id == null && !edit) await db.deleteLatest();
      else {
        for(int i=0; i < zNamen.length; i++){
          await saveIngredients(recipe.id, i);
        }        

        for(int i=0; i < stepDescription.length; i++){
          await saveSteps(recipe.id, i);
        }        
        
        Navigator.pop(context, "saved");
        if(edit) showBottomSnack("Rezept erfolgreich geändert", ToastGravity.BOTTOM);
        else showBottomSnack("Rezept erfolgreich gespeichert", ToastGravity.BOTTOM);
      }
      
    }    
  }

  bool _recExist = false;
  checkRecipe<bool>(String name, StateSetter update) {
    db.create().then((nothing){
      db.checkRecipe(name).then((val){
        if(val > 0) {
          update(() {
            _recExist = true;
            recipeTaken = true;
          });
        } else {          
          update(() {
            _recExist = false;
            recipeTaken = false;
          });
        }
      });
    });
    return _recExist;
  }

  _radialText(String value){
    return Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: Text(
        "$value",
        style: TextStyle(
          fontFamily: "Google-Sans",
          fontSize: 14.0                        
        ),                      
      ),
    );
  }
}