import 'package:flutter/material.dart';

import 'package:recipe/interface/Calendar/flutter_calendar.dart';

class CalendarView extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _CalendarView();
  }
}

class _CalendarView extends State<CalendarView>{
  DateTime selectedDate;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        new Calendar()
      ],
    );
  }

}