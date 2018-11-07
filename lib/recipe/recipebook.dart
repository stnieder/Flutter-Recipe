import 'package:flutter/material.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import '../database/database.dart';

import '../pages/calendar_view.dart';
import '../pages/list.dart';
import '../pages/shopping_list.dart';


class Recipebook extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _Recipebook();
  }
}

class _Recipebook extends State<Recipebook> with TickerProviderStateMixin{
  var dbHelper = new DBHelper();

  int _currentTab = 0;
  final List<Widget> _tabs = [
    new Lists(),
    new CalendarView(),
    new Shopping()
  ];

  @override
    void initState() {
      super.initState();
      dbHelper.create();
      setState(() {});
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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