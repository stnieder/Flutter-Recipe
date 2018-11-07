import 'package:flutter/material.dart';

import '../interface/Calendar/flutter_calendar.dart';
import '../interface/GoogleColors.dart';

class CalendarView extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _CalendarView();
  }
}

class _CalendarView extends State<CalendarView>{
  DateTime selectedDate;
  GoogleMaterialColors googleMaterialColors = new GoogleMaterialColors();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(   
        headerSliverBuilder: (BuildContext context, bool innerBoxisScrolled){
          return <Widget>[
            SliverAppBar(
              backgroundColor: Color(0xFFfafafa),
              centerTitle: true,
              expandedHeight: 56.0,
              floating: false,
              pinned: true,              
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  "Einkaufsliste", 
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: "Google-Sans",
                      fontSize: 19.0,
                      fontWeight: FontWeight.w200
                  )
                ), 
              )
            )
          ];
        },
        body: new Calendar(),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: googleMaterialColors.primaryColor(),
        elevation: 4.0,
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, '/');
        }
      )
    );
  }

}