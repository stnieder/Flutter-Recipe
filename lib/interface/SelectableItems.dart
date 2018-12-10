import 'package:flutter/material.dart';
import '../interface/GoogleColors.dart';
import '../recipe/recipeDetails.dart';

class SelectableItems extends StatefulWidget {
  final int index;
  final bool longPressEnabled;
  final bool isSelected;
  final VoidCallback callback;
  final String name;
  final Widget title;
  final Color color;
  final String image;

  SelectableItems(
    {
      key: Key,
      this.index, 
      this.longPressEnabled,
      this.isSelected = false,
      this.callback, 
      this.name, 
      this.title,
      this.color,
      this.image
    }
  ): super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new StateSelectableItem();
  }
}

class StateSelectableItem extends State<SelectableItems> {
  bool isSelected = false;
  GoogleMaterialColors googleMaterialColors = new GoogleMaterialColors();

  @override
  void initState() {
    if(widget.isSelected) isSelected = widget.isSelected;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
        onLongPress: () {
          setState(() {
            isSelected = !isSelected;
          });
          widget.callback();
        },
        onTap: () {
          if (widget.longPressEnabled) {
            setState(() {
              isSelected = !isSelected;
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
            child: (isSelected
              ? Icon(
                Icons.check,
                color: Colors.white,
              )
              : (widget.image == "no image"
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
            backgroundColor: (isSelected
              ? googleMaterialColors.primaryColor()
              : widget.color
            )
          ),
          title: Padding(
            padding: EdgeInsets.only(top: 25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                widget.title
              ],
            ),
          ),
        ),
      );
  }
}