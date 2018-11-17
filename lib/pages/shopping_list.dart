import 'package:Time2Eat/database/database.dart';
import 'package:Time2Eat/interface/RoundCheckBox.dart';
import 'package:Time2Eat/model/Shopping.dart';
import 'package:flutter/material.dart';
import '../interface/GoogleColors.dart';


Future<List<Shopping>> fetchShoppingList() async{
  var dbHelper = new DBHelper();
  await dbHelper.create();
  Future<List<Shopping>> shopping = dbHelper.getShopping();
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

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: FutureBuilder(
        future: fetchShoppingList(),
        builder: (context, snapshot){
          if(snapshot.hasData){
            if(snapshot.data.length != 0){
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index){
                  return new GestureDetector(
                    child: RoundCheckBoxListTile(
                      checked: (snapshot.data[index].checked == 1
                          ? true
                          : false
                      ),
                      title: new Text("${snapshot.data[index].number.toString()}${snapshot.data[index].measure} ${snapshot.data[index].item}"),
                      onTap: () => checkShopping(snapshot.data[index].item, snapshot.data[index].timestamp),
                    ),
                  );
                },
              );
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

  checkShopping(String item, String timestamp) async{
    DBHelper db = new DBHelper();
    await db.create();
    await db.updateShopItem(item, timestamp);
  }
}