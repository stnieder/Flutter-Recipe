import 'package:flutter/material.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:TimeEater/database/database.dart';
import 'package:TimeEater/customizedWidgets/RoundCheckBox.dart';
import 'package:TimeEater/databaseModel/Shopping.dart';

import '../customizedWidgets/Colors.dart';
import '../customizedWidgets/MyExpansionTile.dart';


Future<List<Shopping>> fetchShoppingList() async{    
  String order = "abc";
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if(prefs.getString("order") == null) {
    order = "timestamp";
    prefs.setString("order", order);
  } else {
    prefs.setString("order", order);
  }
  var dbHelper = new DBHelper();
  await dbHelper.create();
  Future<List<Shopping>> shopping = dbHelper.getShopping(order, prefs.getString("currentList"));
  return shopping;
}



class ShoppingPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _ShoppingPage();
  }
}

class _ShoppingPage extends State<ShoppingPage>{
  MaterialColors googleMaterialColors = new MaterialColors();
  
  SharedPreferences prefs;
  final GlobalKey<MyExpansionTileState> expansionTile = new GlobalKey();

  DBHelper db = new DBHelper();

  List<Widget> checked = new List();
  List<Widget> notchecked = new List();

  @override
  void setState(fn) {
      super.setState(fn);      
      checked = [];
      notchecked = [];
    }



  @override
  Widget build(BuildContext context) {            
    return new NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (overscroll){
        overscroll.disallowGlow();
      },
      child: SingleChildScrollView(                  
        child: FutureBuilder(
          future: fetchShoppingList(),
          builder: (context, snapshot){          
            if(snapshot.hasData){
              checked = [];
              notchecked = [];
              if(snapshot.data.length != 0){
                for(int i=0; i<snapshot.data.length; i++){
                  if(snapshot.data[i].checked == 0) {
                    notchecked.add(
                      checkbox(
                        snapshot.data[i].item, 
                        snapshot.data[i].timestamp, 
                        snapshot.data[i].number, 
                        snapshot.data[i].measure, 
                        snapshot.data[i].checked
                      )
                    );
                  } else {    
                    checked.add(
                      checkbox(
                        snapshot.data[i].item, 
                        snapshot.data[i].timestamp, 
                        snapshot.data[i].number, 
                        snapshot.data[i].measure, 
                        snapshot.data[i].checked
                      )
                    );
                  }
                }

                if(checked.isEmpty){
                  return Container(
                    child: Column(
                      children: notchecked,
                    ),
                  );
                } else {
                  return Column(
                    children: <Widget>[
                      Container(
                        child: Column(
                          children: notchecked,
                        ),
                      ),
                      MyExpansionTile(
                        title: Text(
                          "Erledigt (${checked.length})",
                          style: TextStyle(
                            fontFamily: "Google-Sans",
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        key: expansionTile,
                        children: checked,
                      )
                    ],
                  );
                }              
              } else if(snapshot.data.length == 0){
                return new Center(                  
                  child: Padding(
                    padding: EdgeInsets.only(top: MediaQuery.of(context).size.height/4, right: 20.0),
                    child: Column(
                      children: <Widget>[
                        Icon(
                          OMIcons.list,
                          color: googleMaterialColors.primaryColor(),
                          size: 102.0,
                        ),
                        Text(
                          "Ihre Einkaufsliste wird hier angezeigt"
                        )
                      ],
                    ),
                  )
                );
              }
            } else if(snapshot.hasError){
              return Center(
                child: Text("${snapshot.error}"),
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }

  checkShopping(String item, String timestamp, int check) async{
    await db.create();
    await db.updateShopItem(item, timestamp, check);
  }

  checkbox(String item, String timestamp, String number, String measure, int check){        
    return RoundCheckBoxListTile(
      title: (check == 0
        ? Text(number + measure + " " + item)
        : RichText(
            text: TextSpan(
              children: <TextSpan>[
                new TextSpan(
                  text: number + measure + " " + item,
                  style: new TextStyle(
                    color: Colors.black,
                    decoration: TextDecoration.lineThrough
                  )
                )
              ]
            ),
          )
      ),
      checked: check == 1,
      underline: check == 0,
      onTap: (){
        setState(() {
          if(check == 0) check = 1;
          else {            
            check = 0;            
          }
          checkShopping(item, timestamp, check);
        });
      },
    );
  }
}