import 'package:Time2Eat/interface/GoogleColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_duration_picker/flutter_duration_picker.dart';
import 'package:intl/intl.dart';

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
                  Navigator.pop(context, 'verwerfen');
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

  setNotification(BuildContext context) {
    return showDialog(
      context: context,
      builder: (_) => NotificationDialog()
    );
  }
}

class NotificationDialog extends StatefulWidget{



  @override
  State<StatefulWidget> createState() {
    return _NotificationDialog();
  }
}

class _NotificationDialog extends State<NotificationDialog>{
  List<String> date = [
    "Heute",
    "Morgen",
    "Nächsten " + DateFormat.E().format(DateTime.now()),
    "Datum auswählen"
  ];
  DateFormat dayNumber = new DateFormat.d(Intl.systemLocale);
  DateFormat dayName = new DateFormat("EEEEE", "de_DE");
  String selectedDate;

  _getContent(){
    selectedDate = dayNumber.format(DateTime.now()) + " " + dayName.format(DateTime.now());
    return SimpleDialog(
      children: <Widget>[
        Text(
          "Erinnerung hinzufügen",
          style: TextStyle(
              fontFamily: "Google-Sans",
              fontWeight: FontWeight.w400
          ),
        ),
        Container(
          child: new DropdownButton(
            isDense: true,
            hint: Text(selectedDate),
            items: date.map((String value){
              String item = value;
              value = convertDate(value);
              return new DropdownMenuItem(
                value: value,
                child: new Text(item),
              );
            }).toList(),
            onChanged: (String dates) {
              setState(() {
                selectedDate = convertDate(dates);
              });
            },
          ),
        )
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    return _getContent();
  }

  convertDate(String value){
    if (value == "Heute") {
      String name = dayName.format(DateTime.now());
      selectedDate = (dayNumber.format(DateTime.now()) + name);
      print("Heute: "+selectedDate);
      value = selectedDate;
    } else if(value == "Morgen"){
      String name = dayName.format(DateTime(0, 0, DateTime.now().day + 1));
      selectedDate = (dayNumber.format(DateTime(0, 0, DateTime.now().day + 1)) + name);
      print("Morgen: "+selectedDate);
      value = selectedDate;
    }
    return value;
  }
}