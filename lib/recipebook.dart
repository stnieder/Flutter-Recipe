import 'package:flutter/material.dart';

import 'bottom_sheets.dart';
import 'new_recipe.dart';

import 'interface/BubbleIndicator.dart';
import 'interface/FancyButton.dart';
import 'interface/LoadingBar.dart';

import 'pages/calendar_view.dart';
import 'pages/list.dart';
import 'pages/shopping_list.dart';


class Recipebook extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _Recipebook();
  }
}

class _Recipebook extends State<Recipebook> with TickerProviderStateMixin{
  BottomSheets bottomSheets = new BottomSheets();
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

  final List<dynamic> _new = [
    '/add_recipe',
    '/',
    '/'
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
          child: Text(_appTitles[_currentTab], style: TextStyle(color: Colors.black, fontFamily: "Google-Sans", fontSize: 26.0, fontWeight: FontWeight.w100)),
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
            icon: Icon(Icons.book),
            title: const Text(
              'Rezeptbuch',
              style: TextStyle(fontFamily: 'Google-Sans', fontWeight: FontWeight.w600),
            )
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              title: const Text(
                'Kalender',
                style: TextStyle(fontFamily: 'Google-Sans', fontWeight: FontWeight.w600),
              )
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_basket),
              title: const Text(
                'Einkaufsliste',
                style: TextStyle(fontFamily: 'Google-Sans', fontWeight: FontWeight.w600),
              )
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue[600],
        elevation: 4.0,
        child: Icon(Icons.add),
        onPressed: (){
          Navigator.pushNamed(context, _new[_currentTab]);
        },
      )
    );
  }

  void onTabTapped(int index){
    setState(() {
      _currentTab = index;
    });
  }
}