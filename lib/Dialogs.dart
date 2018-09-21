import 'package:flutter/material.dart';

import 'interface/CustomShowDialog.dart';

class Dialogs{

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
                  "Deine Änderungen wurden nicht gespeichert",
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

  takePhoto(BuildContext context){
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context){
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
                    child: Text("Foto machen"),
                  ),
                  onTap: ()=> Navigator.pop(context, "machen"),
                ),
                InkWell(
                  child: Padding(
                    padding: EdgeInsets.only(left: 10.0, right: 150.0, bottom: 10.0, top: 10.0),
                    child: Text("Foto auswählen"),
                  ),
                  onTap: ()=> Navigator.pop(context, "auswählen"),
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
              onPressed: ()=>Navigator.pop(context),
              shape: new RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
              splashColor: Colors.transparent
            )
          ],
        );
      }
    );
  }

}