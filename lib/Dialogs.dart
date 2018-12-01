import 'package:Time2Eat/database/database.dart';
import 'package:Time2Eat/interface/GoogleColors.dart';
import 'package:Time2Eat/interface/MyListTile.dart';
import 'package:Time2Eat/interface/NotificationDialog.dart';
import 'package:Time2Eat/interface/RoundedBottomSheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_duration_picker/flutter_duration_picker.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'interface/CustomShowDialog.dart';

class Dialogs{
  final personenAnzahlController = new TextEditingController();
  GoogleMaterialColors googleMaterialColors = new GoogleMaterialColors();

  closeDialog(BuildContext context){
    return showDialog(
        context: context,
        builder: (BuildContext context){
          return CustomAlertDialog(
            content: Container(
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.circular(5.0))
              ),
              child: Padding(
                padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0, bottom: 0.0),
                child: new Text(
                  "Dein Rezept wird nicht gespeichert",
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
        return CustomAlertDialog(
          title: Text("Personenanzahl pro Portion"),
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
          return CustomAlertDialog(
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
        return CustomAlertDialog(
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

  setNotification(BuildContext context, String name) {
    return showDialog(
      context: context,
      builder: (_) => NotificationDialog(name)
    );
  }

  showPopupMenu(BuildContext context, int page) async{
    //Possible choices
    List<String> choices = [
      "Alphabetisch",
      "Datum",
      "Liste umbenennen",
      "List löschen",
      "Alle erledigten Aufgaben löschen"
    ];

    //get current order
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String prefsOrder = prefs.getString("order");

    //Count amount of list titles
    DBHelper db = new DBHelper();
    int countTitles = await db.countTitles("");

    //Count checked list items
    int countItems = await db.countCheckedItems(prefsOrder, prefs.getString("currentList"));

    //Check if items are inside of the list
    checkListItems() async{
      int items = await db.checkShoppingItems(prefs.getString("currentList"));
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
          if(enable) Navigator.pop(context, text);
        }
      );
    }

    return showRoundedBottomSheet(
      context: context,
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
            _item(context, choices[3], await checkListItems()),
            _item(context, choices[4], countItems > 0)
          ],
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
        return CustomAlertDialog(
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
    Color addListColor = Colors.white;
    
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
    return showRoundedBottomSheet(
      context: context,
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 30.0, left: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 10.0),
                  child: _title("Ihre Listen"),
                ),
                Column(
                  children: items
                )
              ],
            ),
          ),
          Divider(),
          GestureDetector(
            child: ListTile(
              leading: Icon(Icons.add, color: Colors.black54),
              title: Text(
                "Neue Liste erstellen",
                style: TextStyle(
                  fontFamily: "Google-Sans",
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),            
            onTap: (){
              Navigator.pop(context, "neue Liste");
            },
          ),
          Divider(),
          GestureDetector(
            child: ListTile(
              leading: Icon(OMIcons.smsFailed, color: Colors.black54),
              title: Text(
                "Feedback geben",
                style: TextStyle(
                  fontFamily: "Google-Sans",
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),            
            onTap: (){
              Navigator.pop(context, "feedback");
            },
          )
        ],
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
}



class CreateNewList extends StatefulWidget {
  @override
  _CreateNewListState createState() => _CreateNewListState();
}

class _CreateNewListState extends State<CreateNewList> {

  TextEditingController controller = new TextEditingController();
    DBHelper db = new DBHelper();

    bool _titleTaken = false;

    _checkList<bool>(String title){
      db.create().then((nothing){
        db.checkListTitle(title).then((val){
          if(val > 0){
            setState(() {
              _titleTaken = true;
            });
          } else {
            setState(() {
              _titleTaken = false;
            });
          }
          print("Value: "+val.toString());
        });
      });
      return _titleTaken;
    }


  @override
  Widget build(BuildContext context) {
    return CustomAlertDialog(            
      content: Container(
        height: 110.0,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(Radius.circular(5.0))
        ),
        child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 15.0, left: 15.0, right: 10.0, bottom: 10.0),
            child: new Text(
              "Neue Liste erstellen",
              style: TextStyle(
                fontSize: 14.0,
                fontFamily: "Google-Sans",
                fontWeight: FontWeight.bold
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 15.0, right: 15.0),
            child: TextFormField(
              autofocus: true,    
              autocorrect: true,
              autovalidate: true,                
              controller: controller,                    
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Listentitel eingeben",
                hintStyle: TextStyle(
                  color: Colors.black54,
                  fontFamily: "Google-Sans",
                  fontSize: 13.0,
                  fontWeight: FontWeight.bold                        
                )
              ),
              validator: (value) => _checkList(value)
                ? "Dieser Titel ist vergeben"
                : null
              ,
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
            if(controller.text.trim().isNotEmpty && !_titleTaken) {
              Navigator.pop(context, controller.text.trim());
            }
          },
          shape: new RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        )
      ],
    );
  }
}