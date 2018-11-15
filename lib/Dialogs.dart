import 'package:Time2Eat/interface/GoogleColors.dart';
import 'package:Time2Eat/interface/MyDropDownButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_duration_picker/flutter_duration_picker.dart';
import 'package:intl/date_symbol_data_local.dart';
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
  //Select a date
  DateFormat monthName;
  DateFormat dayNumber;
  DateFormat dayName;
  List<String> date = new List();
  String selectedDate;

  //Select a time
  List<String> timeName = new List();
  List<String> timeNumber = new List();
  Map<String, String> time = new Map();
  List<String> timeList = new List();
  String selectedTime;

  _getContent(){ 
    return SimpleDialog(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 10.0),
          child: Text(
          "Erinnerung hinzufügen",
          style: TextStyle(
              fontFamily: "Google-Sans",
              fontSize: 15.0,
              fontWeight: FontWeight.bold
          ),
        ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
          child: Container(
            child: new MyDropdownButton(
              hint: Text(selectedDate + "                   "),
              items: date.map((String value){
                return new MyDropdownMenuItem(
                  value: value,
                  child: new Text(value),
                );
              }).toList(),
              onChanged: convertDate,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 5.0),
          child: Container(
            child: new MyDropdownButton(
              hint: Text(selectedTime),
              items: timeName.map((String value){
                int count = timeName.indexOf(value);                
                return new MyDropdownMenuItem(                  
                  value: timeNumber[count],
                  child: ListTile(
                    title: Text(value),
                    trailing: Text(
                      timeNumber[count],
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 14.0
                      ),
                    ),
                  ),
                );
              }).toList(),
              onChanged: convertTime,
            ),
          ),
        ),
      ],
    );
  }

  convertDate(String value) async{
    if(value == date[0]){
       selectedDate = (dayNumber.format(DateTime.now()) + ". " + monthName.format(DateTime.now()));
    } else if(value == date[1]){
      selectedDate = (dayNumber.format(DateTime(0,0,DateTime.now().day+1)) + ". " + monthName.format(DateTime.now()));
    } else if(value == date[2]){
      selectedDate = (dayNumber.format(DateTime(0,0,DateTime.now().day+7)) + ". " + monthName.format(DateTime.now()));
    } else if(value == date[3]){
      var selectDialog = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(DateTime.now().year-1),
        lastDate: DateTime(DateTime.now().year+2)
      );
      if(selectDialog != null) {
        selectedDate = (dayNumber.format(selectDialog) + ". " + monthName.format(selectDialog));
      }
    }
    setState(() {});
  }

  convertTime(String value) async{
    var pickedTime;
    if(value != ""){
      selectedTime = value;
    } else {
      pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now()
      );
      if(pickedTime != null){
        selectedTime = pickedTime.toString().split("(")[1].split(")")[0].toString();
      }
    }    
    setState(() {});
  }

  @override
    void initState() {
      super.initState(); 
      initializeDateFormatting('de_DE', null);
      monthName = new DateFormat("MMMM", "de_DE");  
      dayName = new DateFormat('EEEEE', "de_DE");
      dayNumber = new DateFormat.d("de_DE");           
      date = [
        "Heute",
        "Morgen",
        "Nächsten " + dayName.format(DateTime.now()),
        "Datum auswählen..."
      ];  
      selectedDate = dayNumber.format(DateTime.now()) + ". " + monthName.format(DateTime.now());

      timeName = [
        "Morgens",
        "Nachmittags",
        "Spätnachmittags",
        "Abends",
        "Uhrzeit auswählen..."
      ];

      timeNumber = [
        "08:00",
        "13:00",
        "18:00",
        "20:00",
        ""
      ];
      selectedTime = timeNumber[0];
    }


  @override
  Widget build(BuildContext context) {
    return _getContent();
  }
}