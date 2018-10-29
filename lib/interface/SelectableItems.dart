import 'package:flutter/material.dart';
import 'package:recipe/interface/GoogleColors.dart';
import 'package:recipe/recipe/recipeDetails.dart';

class CustomWidget extends StatefulWidget {
  final int index;
  final bool longPressEnabled;
  final VoidCallback callback;
  final String name;
  final Color color;
  final String image;

  const CustomWidget(
    {
      Key key, 
      this.index, 
      this.longPressEnabled, 
      this.callback, 
      this.name, 
      this.color,
      this.image
    }
  ) : super(key: key);

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
            Navigator.push(
              context, 
              MaterialPageRoute(builder: (context)=>RecipeDetails(widget.name))
            );
          }
        },
        child: ListTile(
          leading: CircleAvatar(
            child: (selected
              ? Icon(
                  Icons.check,
                  color: Colors.white,
                )
              : (widget.image != "no image"
                ? Container(
                    width: 40.0,
                    height: 40.0,
                    decoration: new BoxDecoration(
                      image: new DecorationImage(
                        colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.2), BlendMode.darken),
                        image: AssetImage(widget.image),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: new BorderRadius.all(new Radius.circular(50.0)),
                    ),
                  )
                : Text(
                    widget.name[0].toUpperCase(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 21.0,
                      fontWeight: FontWeight.w400
                    ),
                  )
              )
            ),
            backgroundColor: (selected
              ? googleMaterialColors.primaryColor()
              : widget.color.withOpacity(1.00)
            )
          ),
          title: Padding(
            padding: EdgeInsets.only(top: 25.0),
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