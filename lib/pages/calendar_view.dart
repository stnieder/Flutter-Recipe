import 'package:flutter/material.dart';

import 'package:flutter_calendar/flutter_calendar.dart';

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
        new Calendar(
          onDateSelected: (DateTime date){
            setState(() {
              selectedDate = date;
            });
          },
        ),
        Text(""+selectedDate.toString())
      ],
    );
  }

}