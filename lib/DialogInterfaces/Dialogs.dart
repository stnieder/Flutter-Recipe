import 'dart:io';

import 'package:Time2Eat/DialogInterfaces/CreateNewList.dart';
import 'package:Time2Eat/DialogInterfaces/ListTitles.dart';
import 'package:Time2Eat/DialogInterfaces/ShoppingMenu.dart';
import 'package:Time2Eat/database/database.dart';
import 'package:Time2Eat/customizedWidgets/DynamicBottomSheet.dart';
import 'package:Time2Eat/customizedWidgets/GoogleColors.dart';
import 'package:Time2Eat/customizedWidgets/MyListTile.dart';
import 'package:Time2Eat/customizedWidgets/RoundedBottomSheet.dart';
import 'package:Time2Eat/recipe_details/recipeDetails.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_duration_picker/flutter_duration_picker.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_extend/share_extend.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_permissions/simple_permissions.dart';

import '../customizedWidgets/CustomShowDialog.dart' as custom;
import '../customizedWidgets/RoundedBackground.dart';
import 'NotificationDialog.dart';

double _kShoppingMenuHeight = 100.0;

class Dialogs{
  final personenAnzahlController = new TextEditingController();
  GoogleMaterialColors googleMaterialColors = new GoogleMaterialColors();


  showImage(BuildContext context, String asset, String recipeName) {
    const String authorities = "com.vendetta.recipe.fileprovider";

    sharePicture() async{
      var permissions = await SimplePermissions.checkPermission(Permission.WriteExternalStorage);
      if(permissions) {
        await ShareExtend.share(asset, "image", authorities);
        Navigator.pop(context);
      } else {
        var granted = await SimplePermissions.requestPermission(Permission.WriteExternalStorage);
        sharePicture();
      }
    }

    openRecipePage() async{
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(
          builder: (_) => RecipeDetails(recipeName)
        )
      );
    }

    return Dialog(                
      child: Material(
        child: Container(
          height: 225.0,
          width: 200.0,
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Hero(
                    tag: "picture",
                    child: Image.asset(asset),
                  ),
                  Container(
                    color: Colors.black.withOpacity(0.4),
                    child: Text(
                      recipeName,
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Google-Sans",
                        fontSize: 14.0
                      ),
                    ),
                  )
                ],
              ),
              Container(
                height: 35.0,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Colors.black45
                    )
                  )
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 50.0),
                      child: IconButton(
                        icon: Icon(
                          OMIcons.share,
                          color: googleMaterialColors.primaryColor(),
                        ),
                        tooltip: "Bild teilen",
                        onPressed: (){
                          //Share the recipe picture
                          sharePicture();
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 50.0),
                      child: IconButton(
                        icon: Icon(
                          OMIcons.info,
                          color: googleMaterialColors.primaryColor(),
                        ),
                        tooltip: "Rezept anzeigen",
                        onPressed: (){
                          //Open the recipe
                          openRecipePage();
                        },
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  closeDialog(BuildContext context, String title){
    return showDialog(
        context: context,
        builder: (BuildContext context){
          return custom.CustomAlertDialog(
            content: Container(
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.circular(5.0))
              ),
              child: Padding(
                padding: EdgeInsets.only(top: 15.0, left: 20.0, right: 10.0, bottom: 0.0),
                child: new Text(
                  title,
                  style: TextStyle(
                      fontSize: 14.0
                  ),
                ),
              ),
            ),
            contentPadding: EdgeInsets.only(bottom: 0.0),
            actions: <Widget>[
              new FlatButton(
                child: Text("Verwerfen"),
                onPressed: (){
                  Navigator.pop(context, 'verwerfen');
                },
              ),
              new FlatButton(
                child: Text("Speichern"),
                onPressed: (){
                  Navigator.pop(context, 'speichern');
                },
              )
            ],
          );
        }
    );
  }

  personenAnzahl(BuildContext context){
    int anzahl;

    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext ctxt){
        return custom.CustomAlertDialog(
          title: Text("Portionen"),
          content: Container(
            height: 78.0,
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(1.0)
            ),
            child: TextField(
              controller: personenAnzahlController,
              onChanged: (text){
                anzahl = int.parse(text);
              },
              keyboardType: TextInputType.number,
            )
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                "Abbrechen",
                style: TextStyle(
                  color: googleMaterialColors.getLightColor(2),
                  fontFamily: "Google-Sans",
                  fontSize: 14.0
                ),
              ),
              highlightColor: googleMaterialColors.getLightColor(2).withOpacity(0.2),
              onPressed: ()=>Navigator.pop(ctxt),
              shape: new RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
              splashColor: Colors.transparent
            ),
            FlatButton(
              child: Text(
                "Speichern",
                style: TextStyle(
                    color: (anzahl == null
                      ? Color(0xFFAAAFB4)
                      : googleMaterialColors.getLightColor(7)
                    ),
                    fontFamily: "Google-Sans",
                    fontSize: 14.0
                ),
              ),
              highlightColor: (anzahl == null
                ? Color(0xFFAAAFB4).withOpacity(0.3)
                : googleMaterialColors.getLightColor(7).withOpacity(0.2)
              ),
              onPressed: (anzahl == null
                ? (){}
                : ()=> Navigator.pop(context, anzahl)
              ),
              shape: new RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
              splashColor: Colors.transparent
            )
          ],
        );
      }
    );
  }

  cookingTime(BuildContext context){
    Duration _duration;

    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext ctxt){
          return custom.CustomAlertDialog(
            title: Text("Arbeitszeit: "),
            content: Container(
              child: DurationPicker(
                duration: _duration,
                onChange: (value){
                  _duration = value;
                },
                snapToMins: 5.0,
              ),
            ),
            actions: <Widget>[
              FlatButton(
                  child: Text(
                    "Abbrechen",
                    style: TextStyle(
                        color: googleMaterialColors.getLightColor(2),
                        fontFamily: "Google-Sans",
                        fontSize: 14.0
                    ),
                  ),
                  highlightColor: googleMaterialColors.getLightColor(2).withOpacity(0.2),
                  onPressed: ()=>Navigator.pop(ctxt),
                  shape: new RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                  splashColor: Colors.transparent
              ),
              FlatButton(
                  child: Text(
                    "Speichern",
                    style: TextStyle(
                        color: (_duration == null
                            ? Color(0xFFAAAFB4)
                            : googleMaterialColors.getLightColor(7)
                        ),
                        fontFamily: "Google-Sans",
                        fontSize: 14.0
                    ),
                  ),
                  highlightColor: (_duration == null
                      ? Color(0xFFAAAFB4).withOpacity(0.3)
                      : googleMaterialColors.getLightColor(7).withOpacity(0.2)
                  ),
                  onPressed: (_duration == null
                      ? (){}
                      : ()=> Navigator.pop(context, _duration)
                  ),
                  shape: new RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                  splashColor: Colors.transparent
              )
            ],
          );
        }
    );
  }

  takePhoto(BuildContext context){
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext ctxt){
        return custom.CustomAlertDialog(
          title: Text("Foto ändern"),
          content: Container(
            height: 78.0,
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(1.0)
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                InkWell(
                  child: Padding(
                    padding: EdgeInsets.only(left: 10.0, right: 150.0, bottom: 10.0, top: 10.0),
                    child: Text("Pick a photo"),
                  ),
                  onTap: ()=> Navigator.pop(ctxt, "pick"),
                ),
                InkWell(
                  child: Padding(
                    padding: EdgeInsets.only(left: 10.0, right: 150.0, bottom: 10.0, top: 10.0),
                    child: Text("Take a photo"),
                  ),
                  onTap: ()=> Navigator.pop(ctxt, "take"),
                ),

              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                "Abbrechen",
                style: TextStyle(
                    color: googleMaterialColors.getLightColor(2),
                    fontFamily: "Google-Sans",
                    fontSize: 14.0
                ),
              ),
              highlightColor: googleMaterialColors.getLightColor(2).withOpacity(0.2),
              onPressed: ()=>Navigator.pop(ctxt),
              shape: new RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
              splashColor: Colors.transparent
            )
          ],
        );
      }
    );
  }

  setNotification(BuildContext context, String name, int id, DateTime selectedDate) async{
    return showDialog(
      context: context,
      builder: (_) => NotificationDialog(name, id, selectedDate)
    );
  }

  showPopupMenu(BuildContext context, int page) async{
    //Possible choices
    List<String> choices = [
      "Alphabetisch",
      "Datum",
      "Liste umbenennen",
      "Liste löschen",
      "Alle erledigten Einkäufe löschen"
    ];

    //get current order
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String prefsOrder = prefs.getString("order");
    String prefsList = prefs.getString("currentList");

    
    DBHelper db = new DBHelper();

    //Count amount of list titles
    int countList = await db.countAllTitles();

    //Count checked list items
    int countItems = await db.countCheckedItems(prefsOrder, prefsList);

    //Check if items are inside of the list
    checkListItems() async{
      int items = await db.countTitles(prefsList);
      if(items > 0) return false;
      else return true;
    }
    
    _title(String text){
      return Text(
        text,
        style: TextStyle(
          color: Colors.grey,
          fontFamily: "Google-Sans",
          fontSize: 13.0,  
          fontWeight: FontWeight.bold                         
        ),
      );
    }

    _sortItem(BuildContext context, String text, String preferenceSet) {
      return ListTile(
        trailing: (prefsOrder != preferenceSet
          ? Icon(Icons.check, color: Colors.transparent)
          : Icon(Icons.check, color: Colors.black54)
        ),
        title: Text(
          text,
          style: TextStyle(
            fontWeight: (prefsOrder != preferenceSet 
              ? FontWeight.normal
              : FontWeight.bold
            ),
            fontSize: 14.0
          ),
        ),
        onTap: () {
          prefs.setString("order", preferenceSet);
          Navigator.pop(context, text);
        },
      );
    }

    _item(BuildContext context, String text, bool enable){
      return InkWell(
        child: ListTile(
          trailing: Icon(Icons.check, color: Colors.transparent),
          contentPadding: EdgeInsets.only(left: 20.0),
          title: Text(
            text,
            style: TextStyle(
              fontSize: 14.0
            ),
          ),
          enabled: enable,
        ),
        onTap: (){
          if(enable) {
            Navigator.pop(context, text);
          }
        }
      );
    }

    return showDynamicBottomSheet(
      context: context,
      minHeight: 150.0,
      maxHeight: 350.0,
      child: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 30.0, left: 20.0, right: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  _title("Sortieren nach"),
                  Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        _sortItem(context, choices[0], "abc"),
                        _sortItem(context, choices[1], "timestamp")
                      ],
                    ),
                  ),                            
                ],
              ),
            ),
            Divider(),
            _item(context, choices[2], true),
            _item(context, choices[3], countList > 1),
            _item(context, choices[4], countItems > 0)
          ],
        ),
      )
    );
  }

  renameShopping(BuildContext context) async{
    TextEditingController controller = new TextEditingController();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String oldTitle = prefs.getString("currentList");
    controller.text = oldTitle;

    return showDialog(
      context: context,
      builder: (BuildContext context){
        return custom.CustomAlertDialog(
          content: Container(
            height: 100.0,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.all(Radius.circular(5.0))
            ),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 15.0, left: 15.0, right: 10.0, bottom: 10.0),
                  child: new Text(
                    "Einkaufsliste umbenennen",
                    style: TextStyle(
                      fontSize: 14.0,
                      fontFamily: "Google-Sans",
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 15.0, right: 15.0),
                  child: TextField(
                    autofocus: true,
                    controller: controller,                    
                  ),
                )
              ],
            ),
          ),
          contentPadding: EdgeInsets.only(bottom: 0.0),
          actions: <Widget>[
            new FlatButton(
              child: Text(
                "Abbrechen",
                style: TextStyle(
                  color: Colors.black
                ),
              ),
              highlightColor: GoogleMaterialColors().primaryColor().withOpacity(0.2),              
              onPressed: (){
                Navigator.pop(context, 'abbrechen');
              },              
              shape: new RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
              splashColor: Colors.transparent,
            ),
            new FlatButton(
              child: Text(
                "Erledigt",
                style: TextStyle(
                  color: Colors.white
                ),
              ),
              color: GoogleMaterialColors().primaryColor(),
              onPressed: (){
                if(controller.text.isNotEmpty) Navigator.pop(context, [oldTitle, controller.text]);                
              },
              shape: new RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
            )
          ],
        );
      }
    );
  }

  showShoppingMenu(BuildContext context) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String currentTitle = prefs.getString("currentList");
    
    DBHelper db = new DBHelper();

    List<Widget> items = new List();    

    _title(String text){
      return Text(
        text,
        style: TextStyle(
          color: Colors.grey,
          fontFamily: "Google-Sans",
          fontSize: 13.0,  
          fontWeight: FontWeight.bold                         
        ),
      );
    }
    
    _items(String text){
      return MyListTileText(
        backgroundColor: GoogleMaterialColors().primaryColor().withOpacity(0.4),
        enabled: currentTitle == text,
        childText: text,        
        onTap: (){            
          Navigator.pop(context, text);
        },
      );
    }

    _list() async{      
      List list = await db.getListTitles();

      for(int i=0; i < list.length; i++){
        items.add(
          _items(list[i].titleName)
        );
      }
    }

    await _list();
    return showDynamicBottomSheet(
      minHeight: 200.0,
      maxHeight: 200.0 + (items.length * 30.0),
      context: context,
      child: ShoppingMenu(
        title: _title("Ihre Listen"),
        items: items,
        kShoppingMenuHeight: _kShoppingMenuHeight
      )
    );
  }

  createNewList(BuildContext context) async{
    return showDialog(
        context: context,
        builder: (BuildContext context){
          return CreateNewList();
        }
    );    
  }

  addToShoppingList(BuildContext context) async{
    return showDialog(
      context: context,
      builder: (BuildContext context){
        return ListTitles();
      }
    );
  }

  deleteCheckedItems(BuildContext context, int itemCount) async{
    return customDialog(
      context, 
      "Alle erledigten Einkäufe löschen?", 
      Container(
        child: Text(
          itemCount.toString() + " erledigte Einkäufe werden unwiderruflich gelöscht",
          style: TextStyle(
            color: Colors.black54,
            fontFamily: "Google-Sans",
            fontSize: 13.0,
            fontWeight: FontWeight.w400
          ),
        ),
      ), 
      <Widget>[
        new FlatButton(
          child: Text(
            "Abbrechen",
            style: TextStyle(
              color: GoogleMaterialColors().primaryColor()
            ),
          ),
          highlightColor: GoogleMaterialColors().primaryColor().withOpacity(0.2),              
          onPressed: (){
            Navigator.pop(context, 'abbrechen');
          },              
          shape: new RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          splashColor: Colors.transparent,
        ),
        new FlatButton(
          child: Text(
            "Löschen",
            style: TextStyle(
              color: GoogleMaterialColors().primaryColor()
            ),
          ),
          highlightColor: GoogleMaterialColors().primaryColor().withOpacity(0.2),
          onPressed: (){
            Navigator.pop(context, "löschen");
          },
          shape: new RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        )
      ]
    );    
  }

  selectPortions(BuildContext context, int currentNumber) async{
    int selected = currentNumber;
    return showRoundedBottomSheet(      
      context: context,   
      height: 150.0,   
      child: Container(
        height: 70.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 15.0, left: 15.0),
              child: Text(
                "Portionen",
                style: TextStyle(
                  fontFamily: "Google-Sans",
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
            Expanded(
                  child: Container(              
                    height: 50.0,
                    width: 100.0,
                    child: CupertinoPicker(      
                      backgroundColor: Colors.white,          
                      onSelectedItemChanged: (selection){
                        selected = selection;
                      },
                      itemExtent: 25.0,
                      children: List.generate(
                        101,
                        (index){
                          Widget text;
                          if(index == 0) {
                            text = Text(
                              "${0.5}",
                              style: TextStyle(
                                fontFamily: "Google-Sans",
                                fontSize: 15.0
                              ),
                            );
                          }
                          else if(index < 101) {
                            text = Text(
                              "$index",
                              style: TextStyle(
                                fontFamily: "Google-Sans",
                                fontSize: 15.0
                              ),
                            );
                          }
                          return text;
                        }
                      ),
                    ),
                  ),
                ),
                FlatButton(                  
                  child: Row(
                    children: <Widget>[
                      Icon(OMIcons.save, color: Colors.black45),
                      Text(
                        "Speichern",
                        style: TextStyle(
                          fontFamily: "Google-Sans",
                          fontSize: 14.0                    
                        ),
                      )
                    ],
                  ),
                  onPressed: (){
                    Navigator.pop(context, selected);
                  },
                )
          ],
        ),
      )
    );
  }

  deleteRecipes(BuildContext context, int length) async{
    return showDialog(
      context: context,
      builder: (BuildContext context){
        return custom.CustomAlertDialog(
          content: Container(
            height: 50.0,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.all(Radius.circular(5.0))
            ),
            child: Center(
              child: Padding(
                padding: EdgeInsets.only(left: 15.0, top: 20.0,right: 5.0),
                child: Text(
                  (length > 1
                    ? "Diese Rezepte werden unwiderruflich gelöscht"
                    : "Dieses Rezept wird unwiderruflich gelöscht"
                  ),
                  style: TextStyle(
                    fontFamily: "Google-Sans",
                    fontSize: 15.0
                  ),
                ),
              ),
            ),
          ),
          contentPadding: EdgeInsets.only(bottom: 0.0),
          actions: <Widget>[
            new FlatButton(
              child: Text(
                "Abbrechen",
                style: TextStyle(
                  color: GoogleMaterialColors().primaryColor()
                ),
              ),
              highlightColor: GoogleMaterialColors().primaryColor().withOpacity(0.2),              
              onPressed: (){
                Navigator.pop(context, 'abbrechen');
              },              
              shape: new RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
              splashColor: Colors.transparent,
            ),
            new FlatButton(
              child: Text(
                "Löschen",
                style: TextStyle(
                  color: GoogleMaterialColors().primaryColor()
                ),
              ),
              highlightColor: GoogleMaterialColors().primaryColor().withOpacity(0.2),
              onPressed: (){
                Navigator.pop(context, "löschen");
              },
              shape: new RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
            )
          ],
        );
      }
    );
  }

  newShoppingItem(BuildContext context) async{
    TextEditingController numberController = new TextEditingController();
    TextEditingController namecontroller = new TextEditingController();
    List<String> masses = ["Stk.", "kg", "g", "l", "mg", "TL", "EL"];
    String selectedMass;  

    return showDialog(
      context: context,
      builder: (BuildContext context){
        return custom.CustomAlertDialog(
          content: Container(
            height: 100.0,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.all(Radius.circular(5.0))
            ),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 15.0, left: 15.0, right: 10.0, bottom: 10.0),
                  child: new Text(
                    "Neue Zutat zur Einkaufsliste hinzufügen",
                    style: TextStyle(
                      fontSize: 14.0,
                      fontFamily: "Google-Sans",
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 15.0, right: 15.0),
                  child: Row(
                    children: <Widget>[
                      Container(
                          width: 50.0,
                          child: Padding(
                            padding: EdgeInsets.only(top: 8.0, right: 5.0),
                            child: TextFormField(
                              controller: numberController,
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
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center                               
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
                            selectedMass = newValue;
                          },
                          value: selectedMass,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10.0, top: 8.0),
                        child: Container(
                          width: 100.0,
                          child: TextFormField(
                            controller: namecontroller,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(bottom: 5.0),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.black12, style: BorderStyle.solid
                                  ),
                                ),
                                hintText: "Bezeichnung"
                            ),
                            keyboardType: TextInputType.text,
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          contentPadding: EdgeInsets.only(bottom: 0.0),
          actions: <Widget>[
            new FlatButton(
              child: Text(
                "Abbrechen",
                style: TextStyle(
                  color: Colors.black
                ),
              ),
              highlightColor: GoogleMaterialColors().primaryColor().withOpacity(0.2),              
              onPressed: (){
                Navigator.pop(context, 'abbrechen');
              },              
              shape: new RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
              splashColor: Colors.transparent,
            ),
            new FlatButton(
              child: Text(
                "Speichern",
                style: TextStyle(
                  color: Colors.white
                ),
              ),
              color: GoogleMaterialColors().primaryColor(),
              onPressed: (){
                if(namecontroller.text.isNotEmpty && numberController.text.isNotEmpty && selectedMass != null) Navigator.pop(context, [namecontroller.text, numberController.text, selectedMass]);                
              },
              shape: new RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
            )
          ],
        );
      }
    );
  }

  editTermin(BuildContext context) async{
    Color deleteBackground = GoogleMaterialColors().getLightColor(2).withOpacity(0.2);
    Color deleteColor = GoogleMaterialColors().getLightColor(2);

    Color notificationBackground = GoogleMaterialColors().getLightColor(0).withOpacity(0.2);
    Color notificationColor = GoogleMaterialColors().getLightColor(0);

    List<String> sheetText = [
      "Termin löschen",
      "Benachrichtigung hinzufügen"
    ];
    
    List<String> sheetIcon = [
      "images/trash.svg",
      "images/reminder.svg"
    ];


    return showRoundedBottomSheet(
      context: context,
      height: 115.0,
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 10.0, left: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 10.0, left: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      RoundedBackground(
                        text: sheetText[0], 
                        background: deleteBackground, 
                        textColor: deleteColor,
                        svgAsset: sheetIcon[0],
                      ),
                      RoundedBackground(
                        text: sheetText[1], 
                        background: notificationBackground, 
                        textColor: notificationColor,
                        svgAsset: sheetIcon[1],
                      )
                    ],
                  ),
                ),                            
              ],
            ),
          ),
        ],
      )
    );
  }

  authorizeWriting(BuildContext context) async{

    _request() async{
      await SimplePermissions.requestPermission(Permission. WriteExternalStorage);
      Navigator.pop(context);      
    }

    return showDialog(
      context: context,
      builder: (BuildContext context){
        return custom.CustomAlertDialog(
          content: Container(
            height: 180.0,
            width: 280.0,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.all(Radius.circular(5.0))
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  child: Center(
                    child: Icon(OMIcons.folder, color: Colors.white, size: 36.0),                    
                  ),
                  decoration: BoxDecoration(
                    color: GoogleMaterialColors().primaryColor().withOpacity(0.6)
                  ),
                  height: 110.0,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0, bottom: 20.0),
                  child: Container(
                    child: Text(
                      "Um Rezepte teilen zu können, erlaube Time2Eat den Zugriff auf deinen Speicher.",
                      textAlign: TextAlign.justify,
                    ),
                    height: 30.0,
                    width: MediaQuery.of(context).size.width,
                  ),
                )
              ],
            ),
          ),
          contentPadding: EdgeInsets.only(bottom: 0.0),
          actions: <Widget>[
            new FlatButton(
              child: Text(
                "Jetzt nicht",
                style: TextStyle(
                  color: GoogleMaterialColors().primaryColor()
                ),
              ),
              highlightColor: GoogleMaterialColors().primaryColor().withOpacity(0.2),              
              onPressed: (){
                Navigator.pop(context);
              },              
              shape: new RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
              splashColor: Colors.transparent,
            ),
            new FlatButton(
              child: Text(
                "Weiter",
                style: TextStyle(
                  color: GoogleMaterialColors().primaryColor()
                ),
              ),
              highlightColor: GoogleMaterialColors().primaryColor().withOpacity(0.2),              
              onPressed: (){
                _request();
              },              
              shape: new RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
              splashColor: Colors.transparent,
            )
          ],
        );
      }
    );
  }


  customDialog(BuildContext context,String title, Widget content, List<Widget> actions) async{
    return showDialog(
      context: context,
      builder: (BuildContext context){
        return custom.CustomAlertDialog(
          content: Container(
            height: 100.0,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.all(Radius.circular(15.0))
            ),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 15.0, left: 15.0, right: 10.0, bottom: 10.0),
                  child: new Text(
                    title,
                    style: TextStyle(
                      fontSize: 14.0,
                      fontFamily: "Google-Sans",
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: EdgeInsets.only(left: 15.0, right: 5.0),
                    child: content,
                  )
                )
              ],
            ),
          ),
          contentPadding: EdgeInsets.only(bottom: 0.0),
          actions: actions,
        );
      }
    );
  }
}