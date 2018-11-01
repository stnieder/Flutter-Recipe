import 'package:flutter/material.dart';
import 'package:date_utils/date_utils.dart';
import 'package:recipe/interface/GoogleColors.dart';

class CalendarTile extends StatelessWidget {
  final VoidCallback onDateSelected;
  final DateTime date;
  final String dayOfWeek;
  final bool isDayOfWeek;
  final bool isSelected;
  final TextStyle dayOfWeekStyles;
  final TextStyle dateStyles;
  final Widget child;

  CalendarTile({
    this.onDateSelected,
    this.date,
    this.child,
    this.dateStyles,
    this.dayOfWeek,
    this.dayOfWeekStyles,
    this.isDayOfWeek: false,
    this.isSelected: false,
  });

  Widget renderDateOrDayOfWeek(BuildContext context) {
    if (isDayOfWeek) {
      return new InkWell(
        child: new Container(
          color: Colors.transparent,
          alignment: Alignment.center,
          child: new Text(
            dayOfWeek.toUpperCase(),
            style: TextStyle(
              color: Colors.grey,
              fontSize: 13.0
            ),
          )
        ),
      );
    } else {
      return new InkWell(
        onTap: onDateSelected,
        child: new Container(
          decoration: isSelected
              ? new BoxDecoration(
            shape: BoxShape.circle,
            color: new GoogleMaterialColors().primaryColor() //Google Logo --> Blue
          )
              : new BoxDecoration(),
          alignment: Alignment.center,
          child: new Text(
            Utils.formatDay(date).toString(),
            style: isSelected ? new TextStyle(color: Colors.white) : dateStyles,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (child != null) {
      return child;
    }
    return new Container(
      decoration: new BoxDecoration(
        color: Colors.transparent,
      ),
      child: renderDateOrDayOfWeek(context),
    );
  }
}