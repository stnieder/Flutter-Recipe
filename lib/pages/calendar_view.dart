import 'package:Time2Eat/DialogClasses/Dialogs.dart';
import 'package:Time2Eat/database/database.dart';
import 'package:Time2Eat/recipe/recipebook.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../interface/Calendar/flutter_calendar.dart';
import '../interface/GoogleColors.dart';


Future<List> fetcheTermine(String date) async{
  var dbHelper = DBHelper();
  await dbHelper.create();

  Future<List> termine = dbHelper.getTermine(date);
  print("Terminanzahl: "+termine.toString());
  return termine;
}

deleteTermin(String date, String recipeName) async{

}


class CalendarView extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _CalendarView();
  }
}

class _CalendarView extends State<CalendarView>{
  GoogleMaterialColors googleMaterialColors = new GoogleMaterialColors();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
  final _key = GlobalKey();

  String selectedDate;
  bool oldData;

  bool calendarExpandable = true;
  bool calendarExpanded;

  @override
  void initState() {
    super.initState();
    selectedDate = _dateOnly(DateTime.now());
    oldData = false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      key: _key,
      children: <Widget>[
        new Flexible(
          child: Calendar(
            isExpandable: false,
            onDateSelected: (DateTime dateTime){
              setState(() {
                if(DateTime.now().difference(dateTime) > Duration()) oldData = true;
                else oldData = false;
                selectedDate = _dateOnly(dateTime);
              });
            }
          ),
        ),
        Container(
          child: FutureBuilder(
            builder: (context, snapshot){
              if(snapshot.hasData){
                if(snapshot.data.length > 0){
                  return Flexible(
                    child: ListView.builder(
                      addAutomaticKeepAlives: true,
                      itemBuilder: (BuildContext context, int index){
                        return new GestureDetector(
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border(bottom: BorderSide(color:  Colors.black12))
                            ),
                            child: ListTile(
                                leading: CircleAvatar(
                                  child: (snapshot.data[index].image != "no image"
                                      ? Container(
                                    width: 40.0,
                                    height: 40.0,
                                    decoration: new BoxDecoration(
                                      image: new DecorationImage(
                                        colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.2), BlendMode.darken),
                                        image: AssetImage(snapshot.data[index].image),
                                        fit: BoxFit.cover,
                                      ),
                                      borderRadius: new BorderRadius.all(new Radius.circular(50.0)),
                                    ),
                                  )
                                      : Text(
                                    snapshot.data[index].name[0].toUpperCase(),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 21.0,
                                        fontWeight: FontWeight.w400
                                    ),
                                  )
                                  ),
                                ),
                                title: Text(snapshot.data[index].name),
                              ),
                          ),
                          onLongPress: (){
                            editNotification(snapshot.data[index].name);
                          },
                        );
                      },
                      itemCount: snapshot.data.length,
                    ),
                  );
                } else {

                  return new Column(
                    children: <Widget>[
                      Image.asset(
                        'images/allDone.png',

                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 3.0),
                        child: Text(
                          "Gut gemacht",
                          style: TextStyle(
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                      Text(
                        "Sie haben sich eindeutig eine Pause verdient."
                      ),
                    ],
                  );
                }
              } else if(snapshot.hasError){
                return Center(
                  child: Text("${snapshot.error}"),
                );
              }
              return new Center(
                child: new CircularProgressIndicator(),
              );
            },
            future: fetcheTermine(selectedDate),
            initialData: [],
          ),
        )
      ],
    );
  }


  _dateOnly(DateTime date){
    DateTime returnDate = DateTime(date.year, date.month, date.day);
    DateFormat formatter = new DateFormat('dd-MM-yyyy');
    String formatted = formatter.format(returnDate);
    return formatted;
  }

  showNotificationDialog(String recipeName) async{
    Dialogs dialog = new Dialogs();
    await dialog.setNotification(context, recipeName);
  }

  showPositioned(){

  }

  editNotification(String recipe) async{
    var edit = await Dialogs().editTermin(context);
    if(edit == "delete"){
      SnackBar snackBar = SnackBar(
        action: SnackBarAction(          
          label: "Rückgängig machen",
          onPressed: (){
            print("rückgängig!");
          },
          textColor: GoogleMaterialColors().getLightColor(5),          
        ),
        content: Text("Termin gelöscht"),
      );
      Scaffold.of(context).showSnackBar(snackBar);
    } else if(edit == "notification"){
      showNotificationDialog(recipe);
    }
  }
}