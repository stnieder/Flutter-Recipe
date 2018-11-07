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

  final GlobalKey<ScaffoldState> _drawerKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _defaultAppBar(),
      body: new Calendar(),
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


  AppBar _defaultAppBar(){
    return AppBar(
      backgroundColor: Color(0xFFfafafa),
      elevation: 0.0,
      centerTitle: true,
      leading: IconButton(
        icon: Icon(
          Icons.menu,
          color: Colors.black54,
        ),
        onPressed: (){
          _drawerKey.currentState.openDrawer();
        },
      ),
      title: Text(
        "Einkaufsliste",
        style: TextStyle(
          color: Colors.black54,
          fontFamily: "Google-Sans",
          fontSize: 17.0
        ),
      ),
    );
  }

}