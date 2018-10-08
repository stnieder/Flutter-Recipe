import 'package:flutter/material.dart';
import 'package:flutter_duration_picker/flutter_duration_picker.dart';

import 'interface/CustomShowDialog.dart';

class Dialogs{
  final personenAnzahlController = new TextEditingController();

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
                  color: Color(0xFFdb3236),
                  fontFamily: "Google-Sans",
                  fontSize: 14.0
                ),
              ),
              highlightColor: Color(0xFFdb3236).withOpacity(0.2),
              onPressed: ()=>Navigator.pop(ctxt),
              shape: new RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
              splashColor: Colors.transparent
            ),
            FlatButton(
              child: Text(
                "Ok",
                style: TextStyle(
                    color: (anzahl == null
                      ? Color(0xFFAAAFB4)
                      : Color(0xFF4285F4)
                    ),
                    fontFamily: "Google-Sans",
                    fontSize: 14.0
                ),
              ),
              highlightColor: (anzahl == null
                ? Color(0xFFAAAFB4).withOpacity(0.3)
                : Color(0xFF419df4).withOpacity(0.2)
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
                        color: Color(0xFFdb3236),
                        fontFamily: "Google-Sans",
                        fontSize: 14.0
                    ),
                  ),
                  highlightColor: Color(0xFFdb3236).withOpacity(0.2),
                  onPressed: ()=>Navigator.pop(ctxt),
                  shape: new RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                  splashColor: Colors.transparent
              ),
              FlatButton(
                  child: Text(
                    "Ok",
                    style: TextStyle(
                        color: (_duration == null
                            ? Color(0xFFAAAFB4)
                            : Color(0xFF4285F4)
                        ),
                        fontFamily: "Google-Sans",
                        fontSize: 14.0
                    ),
                  ),
                  highlightColor: (_duration == null
                      ? Color(0xFFAAAFB4).withOpacity(0.3)
                      : Color(0xFF419df4).withOpacity(0.2)
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
                    color: Color(0xFF4285F4),
                    fontFamily: "Google-Sans",
                    fontSize: 14.0
                ),
              ),
              highlightColor: Color(0xFF419df4).withOpacity(0.2),
              onPressed: ()=>Navigator.pop(ctxt),
              shape: new RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
              splashColor: Colors.transparent
            )
          ],
        );
      }
    );
  }

}