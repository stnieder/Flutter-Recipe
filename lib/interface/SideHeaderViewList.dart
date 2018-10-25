import 'package:flutter/material.dart';
import 'package:recipe/interface/GoogleColors.dart';
import 'package:recipe/recipe/recipeDetails.dart';

class CustomWidget extends StatefulWidget {
  final int index;
  final bool longPressEnabled;
  final bool anythingSelected;
  final VoidCallback callback;
  final String name;
  final Color avatarColor;

  const CustomWidget({Key key, this.index, this.longPressEnabled, this.anythingSelected, this.callback, this.name, this.avatarColor}) : super(key: key);

  @override
  _CustomWidgetState createState() => new _CustomWidgetState();
}

class _CustomWidgetState extends State<CustomWidget> {  
  bool selected = false;  
  GoogleMaterialColors googleMaterialColors = new GoogleMaterialColors();

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
        onLongPress: () {
          setState(() {
            selected = !selected;
          });
          widget.callback();
        },
        onTap: () {
            if (widget.longPressEnabled) {
              setState(() {
                selected = !selected;
              });
              widget.callback();
            } else {
              Navigator.push(context, MaterialPageRoute(builder: (context) => RecipeDetails(widget.name)));
            }
        },
        child: ListTile(
          leading: CircleAvatar(
            child: (selected
              ? Icon(
                  Icons.check,
                  color: Colors.white,
                )
              : Text(
                  widget.name[0].toUpperCase(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 21.0,
                    fontWeight: FontWeight.w400
                  ),
                )
            ),
            backgroundColor: (selected
              ? googleMaterialColors.getLightColor(2)
              : widget.avatarColor.withOpacity(0.85)
            )
          ),
          title: Padding(
            padding: EdgeInsets.only(top: 25.0, left: 17.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.name,
                  style: TextStyle(
                    fontSize: 15.0,
                    fontFamily: "Google-Sans",
                    color: Colors.black
                  ),
                ),                                    
              ],
            ),
          ),
        ),
      );
  }
}