import 'package:flutter/material.dart';

class Constants {
  static const String settings = "Einstellungen";
  static const String update = "Aktualisieren";
  static const String select = "Auswählen";
  static const String search = "Rezepte suchen";
  static const String error = "Keine Daten vorhanden";  

  static const List<Icon> listPopUpIcons = <Icon>[
    Icon(Icons.settings, color: Colors.black45),
    Icon(Icons.loop, color: Colors.black45),
    Icon(Icons.check_circle_outline, color: Colors.black45)
  ];

  static const List<String> listPopUp = <String>[
    settings,
    update,
    select
  ];
}