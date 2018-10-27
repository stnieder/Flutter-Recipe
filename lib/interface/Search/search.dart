import 'package:flutter/material.dart';

import 'package:recipe/interface/GoogleDivider.dart';
import 'SearchBox.dart';

class SearchPage extends StatefulWidget{
  @override
    State<StatefulWidget> createState() {
      return _SearchPage();
    }
}

class _SearchPage extends State<SearchPage> with TickerProviderStateMixin{

  TextEditingController searchController = new TextEditingController();

  AnimationController iconController;
  Animation<double> changeAnimation;
  bool changedIcon = false;


  @override
    void initState() {
      super.initState();

      iconController = new AnimationController(vsync: this, duration: Duration(milliseconds: 200))..addListener((){setState(() {});})..addStatusListener((status){
        if(status == AnimationStatus.completed){
          iconController.reverse();
          changedIcon = !changedIcon;
        }
      });

      changeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(CurvedAnimation(parent: iconController, curve: Curves.linear));
      iconController.forward();
    }

  @override
    void dispose() {
      super.dispose();
      searchController.dispose();
    }

  @override
    Widget build(BuildContext context) {
      return Scaffold(
        body: Container(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 27.0),
                child: SearchBox(
                  backgroundColor: Colors.transparent,
                  autofocus: true,
                  searchController: searchController,
                  addBorder: false,
                  elevation: 6.0,
                  height: 40.0,
                  width: 450.0,
                  hintText: "Rezepte suchen",
                  leadingButton: InkWell(
                    onTap: () => Navigator.pop(context),
                    child: FadeTransition(
                      opacity: changeAnimation,
                      child: Padding(
                        padding: EdgeInsets.only(left: 15.0, right: 5.0),
                        child: (changedIcon
                          ? Icon(
                              Icons.arrow_back,
                              color: Colors.black45,
                            )
                          : Icon(
                              Icons.search,
                              color: Colors.black45,
                            )
                        ),
                      ),
                    ),
                  ),
                  trailingButton: [
                    Padding(
                      padding: EdgeInsets.only(right: 15.0),
                      child: IconButton(
                        icon: Icon(
                          Icons.more_vert,
                          color: Colors.black45
                        ),
                        onPressed: (){},
                      ),
                    )
                  ]
                ),
              ),
              GoogleDivider()
            ],
          ),
          width: 450.0,
        ),
      );
    }
}