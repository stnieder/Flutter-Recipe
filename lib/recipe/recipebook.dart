import 'package:flutter/material.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:recipe/database/database.dart';

import 'package:recipe/interface/LoadingBar.dart';

import 'package:recipe/pages/calendar_view.dart';
import 'package:recipe/pages/list.dart';
import 'package:recipe/pages/shopping_list.dart';


class Recipebook extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _Recipebook();
  }
}

class _Recipebook extends State<Recipebook> with TickerProviderStateMixin{
  var dbHelper = new DBHelper();

  bool visible = false;

  int _currentTab = 0;
  final List<Widget> _tabs = [
    new Lists(),
    new CalendarView(),
    new Shopping()
  ];

  final List<String> _appTitles = [
    "Rezeptbuch",
    "Termine",
    "Einkaufsliste"
  ];

  @override
    void initState() {
      super.initState();
      dbHelper.create();
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            centerTitle: false,
            bottom: PreferredSize(
                child: LoadingBar(),
                preferredSize: Size.fromRadius(10.0)
            ),
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            title: Padding(
              padding: EdgeInsets.only(top: 30.0),
              child: Text(_appTitles[_currentTab], style: TextStyle(
                  color: Colors.black,
                  fontFamily: "Google-Sans",
                  fontSize: 26.0,
                  fontWeight: FontWeight.w100)),
            )
        ),
        body: _tabs[_currentTab],
        bottomNavigationBar: BottomNavigationBar(
          onTap: onTabTapped,
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentTab,
          fixedColor: Colors.blue[600],
          items: [
            BottomNavigationBarItem(
                icon: Icon(OMIcons.book),
                title: const Text(
                  'Rezeptbuch',
                  style: TextStyle(
                      fontFamily: 'Google-Sans', fontWeight: FontWeight.w600),
                )
            ),
            BottomNavigationBarItem(
                icon: Icon(OMIcons.calendarToday),
                title: const Text(
                  'Kalender',
                  style: TextStyle(
                      fontFamily: 'Google-Sans', fontWeight: FontWeight.w600),
                )
            ),
            BottomNavigationBarItem(
                icon: Icon(OMIcons.shoppingBasket),
                title: const Text(
                  'Einkaufsliste',
                  style: TextStyle(
                      fontFamily: 'Google-Sans', fontWeight: FontWeight.w600),
                )
            )
          ],
        )
    );
  }

  void onTabTapped(int index){
    setState(() {
      _currentTab = index;
    });
  }
}