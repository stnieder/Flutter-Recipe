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
  List<Widget> notchecked = new List();
  List<Widget> checked = new List();
  DBHelper db = new DBHelper();


  @override
  void initState() {
    super.initState();
    (()async{
      await db.create();
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: FutureBuilder(
        future: fetchShoppingList(),
        builder: (context, snapshot){
          if(snapshot.hasData){
            if(snapshot.data.length != 0){
              for(int i=0; i<snapshot.data.length; i++){
                if(snapshot.data[i].checked == 0) {
                  notchecked.add(
                    RoundCheckBoxListTile(
                      title: Text(snapshot.data[i].number + snapshot.data[i].measure + " " + snapshot.data[i].item),
                      checked: false,
                      onTap: () {
                        setState(() {
                          checkShopping(snapshot.data[i].item, snapshot.data[i].timestamp);
                        });
                      },
                    )
                  );
                } else if(snapshot.data[i].checked == 1){
                  checked.add(
                    RoundCheckBoxListTile(
                      title: Text(snapshot.data[i].number + snapshot.data[i].measure + " " + snapshot.data[i].item),
                      checked: true,
                      onTap: () {
                        setState(() {
                          checkShopping(snapshot.data[i].item, snapshot.data[i].timestamp);
                        });
                      },
                    )
                  );
                }
              }

              return Column(
                children: <Widget>[
                  Flexible(

                    child: ListView(
                      children: notchecked,
                    ),
                  ),
                  ExpansionTile(
                    title: Text("Checked Items"),
                    children: checked,
                  )
                ],
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
    List<String> uncheckedItems = await db.getUncheckedColumn(item, timestamp);
    List<String> checkedItems = await db.getCheckedColumn(item, timestamp);
    int updatedRecords;

    if(uncheckedItems.contains(item)){
      updatedRecords = await db.updateShopItem(item, timestamp, 0);
    } else if(checkedItems.contains(item)){
      updatedRecords = await db.updateShopItem(item, timestamp, 1);
    }
    print("Zutaten geupdatet");
    setState(() {});
  }
}