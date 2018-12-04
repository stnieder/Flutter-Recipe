import 'package:Time2Eat/database/database.dart';
import 'package:Time2Eat/interface/CustomShowDialog.dart';
import 'package:Time2Eat/interface/GoogleColors.dart';
import 'package:Time2Eat/model/ListTitle.dart';
import 'package:flutter/material.dart';

Future<List<ListTitle>> fetchTitles() async{
  var dbHelper = DBHelper();
  await dbHelper.create();
  Future<List<ListTitle>> listTitle =  dbHelper.getListTitles();

  return listTitle;
}

class ListTitles extends StatefulWidget {
  @override
  _ListTitlesState createState() => _ListTitlesState();
}

class _ListTitlesState extends State<ListTitles> {
  String selected = "";

  @override
  Widget build(BuildContext context) {
    return CustomAlertDialog(
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
              if(selected.trim() != "" && selected.trim() != null){
                Navigator.pop(context, selected);
              }
            },
            shape: new RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          )
        ],
        content: futureBuilder(),
        contentPadding: EdgeInsets.only(bottom: 0.0)
      );    
  }

  futureDialog(AsyncSnapshot snapshot){
    return Container(
      height: snapshot.data.length * 52.0,           
      width: MediaQuery.of(context).size.width * 0.8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        shape: BoxShape.rectangle
      ),
      child: Container(        
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 15.0, left: 15.0, right: 10.0, bottom: 10.0),
              child: new Text(
                "Zur List hinzufügen",
                style: TextStyle(
                  fontSize: 14.0,
                  fontFamily: "Google-Sans",
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
            Expanded(
              child: StatefulBuilder(
                builder: (BuildContext context, updateTextState){
                  return Padding(
                    padding: EdgeInsets.only(left: 10.0, right: 10.0),
                    child: ListView.builder(                     
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index){
                        return Container(
                          child: InkWell(  
                            borderRadius: BorderRadius.all(Radius.circular(5.0)),                            
                            onTap: (){
                              updateTextState(() {
                                selected = snapshot.data[index].titleName;
                              });
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[                                
                                Padding(
                                  padding: EdgeInsets.only(bottom: 12.0, left: 12.0, top: 12.0),
                                  child: Text(
                                    snapshot.data[index].titleName,
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontFamily: "Google-Sans",
                                      fontSize: 13.0
                                    ),
                                  ),
                                ),
                                (selected == snapshot.data[index].titleName
                                  ? Padding(
                                      padding: EdgeInsets.only(right: 12.0),
                                      child: Icon(Icons.check),
                                    )
                                  : Container()                                  
                                )
                              ],
                            ),
                          ),
                          decoration: (selected == snapshot.data[index].titleName
                            ? BoxDecoration(
                                border: Border.all(color: Colors.black26),
                                borderRadius: BorderRadius.all(Radius.circular(5.0)),                                
                                color: GoogleMaterialColors().primaryColor().withOpacity(0.2)
                              )
                            : new BoxDecoration()
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  futureBuilder(){
    return new FutureBuilder(
      future: fetchTitles(),
      builder: (BuildContext context, AsyncSnapshot snapshot){
        switch(snapshot.connectionState){
          case ConnectionState.none:
            print("ConnecitonState.none");
            return Container(
              child: Column(
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.refresh),
                    onPressed: (){
                      setState(() {
                        print("refreshing");
                      });
                    },
                  ),                  
                ],
              ),
            );
          case ConnectionState.active:
            print("ConnectionState.active");
            return CircularProgressIndicator();
          case ConnectionState.waiting:
            print("ConnectionState.waiting");
            return Container(
              child: Column(
                children: <Widget>[
                  CircularProgressIndicator(),
                  Text(
                    "Bitte warten...",
                    style: TextStyle(
                      fontFamily: "Google-Sans",
                      fontSize: 12.0
                    ),
                  )
                ],
              ),
            );
          case ConnectionState.done:
            print("ConnectionState.done");
            if(snapshot.hasError) return new Text("Error: ${snapshot.error}");
            else return futureDialog(snapshot);
        }
      },
    );
  }
}