import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:Time2Eat/database/database.dart';
import 'package:Time2Eat/interface/RoundCheckBox.dart';
import 'package:Time2Eat/model/Shopping.dart';

import '../interface/GoogleColors.dart';
import '../interface/MyExpansionTile.dart';


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
  GoogleMaterialColors googleMaterialColors = new GoogleMaterialColors();
  
  SharedPreferences prefs;
  final GlobalKey<MyExpansionTileState> expansionTile = new GlobalKey();

  DBHelper db = new DBHelper();

  @override
    void initState() {      
      super.initState();
    }

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: FutureBuilder(
        future: fetchShoppingList(),
        builder: (context, snapshot){
          List<Widget> checked = new List();
          List<Widget> notchecked = new List();
          if(snapshot.hasData){
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
                child: Text("Keine Daten gefunden."),
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
    );
  }

  checkShopping(String item, String timestamp, int check) async{
    await db.create();
    await db.updateShopItem(item, timestamp, check);
  }

  checkbox(String item, String timestamp, String number, String measure, int checked){        
    return RoundCheckBoxListTile(
      title: (checked == 0
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
      checked: checked == 1,
      underline: checked == 0,
      onTap: (){
        setState(() {
          if(checked == 0) checked = 1;
          else {            
            checked = 0;            
          }
          checkShopping(item, timestamp, checked);
        });
      },
    );
  }
}