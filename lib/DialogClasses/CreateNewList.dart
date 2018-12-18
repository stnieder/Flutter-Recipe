import 'package:Time2Eat/database/database.dart';
import 'package:Time2Eat/interface/CustomShowDialog.dart';
import 'package:Time2Eat/interface/GoogleColors.dart';
import 'package:flutter/material.dart';

class CreateNewList extends StatefulWidget {
  @override
  _CreateNewListState createState() => _CreateNewListState();
}

class _CreateNewListState extends State<CreateNewList> {

  TextEditingController controller = new TextEditingController();
    DBHelper db = new DBHelper();

    bool _titleTaken = true;

    _checkList<bool>(String title){
      db.create().then((nothing){
        db.checkListTitle(title).then((val){
          if(val > 0 && controller.text.trim().isNotEmpty){
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