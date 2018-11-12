import 'package:Time2Eat/database/database.dart';
import 'package:Time2Eat/model/Recipes.dart';
import 'package:Time2Eat/model/Termine.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../interface/Calendar/flutter_calendar.dart';
import '../interface/GoogleColors.dart';


Future<List> fetcheTermine(String date) async{
  var dbHelper = DBHelper();
  await dbHelper.create();

  Future<List> termine = dbHelper.getTermine(date);
  return termine;
}


class CalendarView extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _CalendarView();
  }
}

class _CalendarView extends State<CalendarView>{
  GoogleMaterialColors googleMaterialColors = new GoogleMaterialColors();

  String selectedDate;

  @override
  Widget build(BuildContext context) {
    selectedDate = _dateOnly(DateTime.now());
    return Column(
      children: <Widget>[
        new Calendar(
          onDateSelected: (DateTime dateTime){
            print("Date now: "+selectedDate.toString());
            selectedDate = _dateOnly(dateTime);
            print("Selected: "+selectedDate.toString());
          },
        ),
        Container(
          child: FutureBuilder<List>(
            builder: (context, snapshot){
              if(snapshot.hasData){
                if(snapshot.data.length > 0){
                  return ListView.builder(
                    itemBuilder: (BuildContext context, int index){
                      return new Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          CircleAvatar(
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
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                                snapshot.data[index].name
                            ),
                          ),
                          Align(
                            child: Text(
                              snapshot.data[index].termin
                            ),
                            alignment: Alignment.centerRight,
                          )
                        ],
                      );
                    },
                    itemCount: snapshot.data.length,
                  );  
                } else if(snapshot.data.length == 0){
                  return new Column(
                    children: <Widget>[
                      Image.asset('images/allDone.png'),
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
    DateFormat formatter = new DateFormat('yyyy-MM-dd');
    String formatted = formatter.format(returnDate);
    return formatted;
  }
}