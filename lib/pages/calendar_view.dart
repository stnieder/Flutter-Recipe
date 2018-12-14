import 'package:Time2Eat/DialogClasses/Dialogs.dart';
import 'package:Time2Eat/database/database.dart';
import 'package:async/async.dart';
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
  int return_intervallID;
  bool oldData;

  bool calendarExpandable = true;
  bool calendarExpanded;

  List<String> editList = new List();
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();
  AnimatedList _animatedList;
  List<String> names = new List();
  List<String> ids = new List();
  List<String> timestamps = new List();

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
                editList = [];
              });
            }
          ),
        ),
        Container(
          child: FutureBuilder(
            builder: (context, snapshot){
              if(snapshot.hasData){
                if(snapshot.data.length > 0){
                  
                  for (var i = 0; i < snapshot.data.length; i++) {
                    ids.add(snapshot.data[i].id);
                    names.add(snapshot.data[i].name);
                    timestamps.add(snapshot.data[i].timestamp);
                  }

                  return Flexible(
                    child: _createList(snapshot)
                    
                    /*ListView.builder(
                      addAutomaticKeepAlives: true,
                      itemBuilder: (BuildContext context, int index){
                        if(!editList.contains(snapshot.data[index].name)){
                          return _gestureDetectorChild(snapshot.data[index].name, snapshot.data[index].image);
                        } 
                      },
                      itemCount: snapshot.data.length,
                    )*/,
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

  _createList(AsyncSnapshot snapshot){

    _animatedList = new AnimatedList(
      key: _listKey,
      initialItemCount: names.length,
      itemBuilder: (BuildContext context, int index, Animation<double> animation){
        return _gestureDetectorChild(
          snapshot.data[index].name,
          snapshot.data[index].image,
          index,
          animation
        );
      },
    );

    return _animatedList;
  }

  _gestureDetectorChild(String name, String image, int index, Animation<double> animation){
    return FadeTransition(
      opacity: animation,
      child: new GestureDetector(
        child: Container(
          decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color:  Colors.black12))
          ),
          child: ListTile(
              leading: CircleAvatar(
                child: (image != "no image"
                    ? Container(
                  width: 40.0,
                  height: 40.0,
                  decoration: new BoxDecoration(
                    image: new DecorationImage(
                      colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.2), BlendMode.darken),
                      image: AssetImage(image),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: new BorderRadius.all(new Radius.circular(50.0)),
                  ),
                )
                    : Text(
                  name[0].toUpperCase(),
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 21.0,
                      fontWeight: FontWeight.w400
                  ),
                )
                ),
              ),
              title: Text(name),
            ),
        ),
        onTap: (){
          editNotification(name, image, index);
        },
      ),
    );
  }


  _dateOnly(DateTime date){
    DateTime returnDate = DateTime(date.year, date.month, date.day);
    DateFormat formatter = new DateFormat('dd-MM-yyyy');
    String formatted = formatter.format(returnDate);
    return formatted;
  }

  showNotificationDialog(String recipeName) async{
    DBHelper db = new DBHelper();
    await db.create();
    int recipeID = await db.getRecipeID(recipeName);
    Dialogs dialog = new Dialogs();
    List r_value = await dialog.setNotification(context, recipeName, recipeID);
    if(r_value != null){
      int notificationID = r_value[0];
      String intervall = r_value[1];
      String timestamp = timestamps[names.indexOf(recipeName)];
      return_intervallID = await db.getIntervallID(intervall);
      int terminID = await db.getTerminID(recipeName, return_intervallID,timestamp, selectedDate);      
      await db.updateNotification(terminID, notificationID, return_intervallID, timestamp);
    }
    setState(() {});
  }

  editNotification(String recipe, String image, int index) async{
    var edit = await Dialogs().editTermin(context);
    bool cancelFuture = false;
    if(edit == "delete"){
      SnackBar snackBar = SnackBar(
        duration: Duration(seconds: 5),
        action: SnackBarAction(          
          label: "Rückgängig machen",
          onPressed: (){
            setState(() {
              editList.remove(recipe);
              _listKey.currentState.insertItem(
                index
              );
              cancelFuture = true;
            });
          },
          textColor: GoogleMaterialColors().getLightColor(5),          
        ),
        content: Text("Termin gelöscht"),
      );
      setState(() {
        editList.add(recipe);
        _listKey.currentState.removeItem(
          index, 
          (BuildContext context, Animation<double> animation){
            return FadeTransition(
              opacity: animation,
              child: _gestureDetectorChild(recipe, image, index, animation),
            );
          }
        );
      });
      Scaffold.of(context).showSnackBar(snackBar);  
      Future.delayed(Duration(seconds: 5), () async{
        if(!cancelFuture){
          DBHelper db = new DBHelper();
          await db.create();
          int recipeID = int.parse(ids[names.indexOf(recipe)]);
          String timestamp = timestamps[names.indexOf(recipe)];

          int intervallID = await db.getIntervall(recipeID, selectedDate, timestamp);
          await db.deleteTermin(recipeID, selectedDate, intervallID, timestamp);
        }
      });
    } else if(edit == "notification"){
      showNotificationDialog(recipe);
    }
  }
}