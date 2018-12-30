import 'package:Time2Eat/database/database.dart';
import 'package:flutter/material.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ShoppingMenu extends StatefulWidget {
  final Widget title;
  final List<Widget> items;
  final double kShoppingMenuHeight;

  ShoppingMenu(
    {
      this.title,
      this.items,
      this.kShoppingMenuHeight
    }
  );

  @override
  _ShoppingMenuState createState() => _ShoppingMenuState();
}

class _ShoppingMenuState extends State<ShoppingMenu> {
  SharedPreferences prefs;
  String currentTitle;
  Color addListColor = Colors.white;
  double initial;
  
  DBHelper db = new DBHelper();

  setPrefs() async{
    prefs = await SharedPreferences.getInstance();
    currentTitle = prefs.getString("currentList");
  }

  @override
    void initState() {
      super.initState();
      setPrefs();
    }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overscroll){
            overscroll.disallowGlow();
          },        
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: widget.kShoppingMenuHeight
            ),
            child: ListView( 
                physics: NeverScrollableScrollPhysics(),             
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 30.0, left: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(bottom: 10.0),
                          child: widget.title,
                        ),
                        Column(
                          children: widget.items
                        )
                      ],
                    ),
                  ),
                  Divider(),
                  GestureDetector(
                    child: ListTile(
                      leading: Icon(Icons.add, color: Colors.black54),
                      title: Text(
                        "Neue Liste erstellen",
                        style: TextStyle(
                          fontFamily: "Google-Sans",
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),            
                    onTap: (){
                      Navigator.pop(context, "neue Liste");
                    },
                  ),
                  Divider(),
                  GestureDetector(
                    child: ListTile(
                      leading: Icon(OMIcons.smsFailed, color: Colors.black54),
                      title: Text(
                        "Feedback geben",
                        style: TextStyle(
                          fontFamily: "Google-Sans",
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),            
                    onTap: (){
                      Navigator.pop(context, "feedback");
                    },
                  )
                ],
              ),
          ),
        ),
      );
  }
}