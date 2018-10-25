import 'package:flutter/material.dart';
import 'package:recipe/interface/GoogleColors.dart';
import 'package:recipe/recipe/recipeDetails.dart';

class SelectableItem extends StatefulWidget{
  final int index;
  final bool longPressEnabled;
  final AsyncSnapshot snapshot;
  final VoidCallback callback;

  final String name;
  final Color avatarColor;

  SelectableItem({Key key, this.index, this.snapshot, this.longPressEnabled, this.callback, this.name, this.avatarColor});

  @override
  State<StatefulWidget> createState() {
    return new _SelectableItem(this);
  }  
}

class _SelectableItem extends State<SelectableItem>{
  SelectableItem selectableItem = new SelectableItem();
  _SelectableItem(this.selectableItem);

  bool selected = false;
  var snapshot;
  GoogleMaterialColors googleMaterialColors = new GoogleMaterialColors();


  @override
    void initState() {
      super.initState();
      snapshot = selectableItem.snapshot;
    }
  
  @override
    Widget build(BuildContext context) {
      return new GestureDetector(
        onLongPress: (){
          setState(() {
            selected = !selected;
          });
          widget.callback();
        },
        onTap: (selected
          ? (){
              setState((){
                selected = !selected;
              });
              widget.callback();
            }
          : ()=>Navigator.push(
              context, 
              MaterialPageRoute(builder: (context) => RecipeDetails(selectableItem.name))
            )
        ),
        child: ListTile(
          leading: CircleAvatar(
            child: (selected
              ? Icon(
                  Icons.check,
                  color: Colors.white,
                )
              : Text(
                  selectableItem.name[0].toUpperCase(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 21.0,
                    fontWeight: FontWeight.w400
                  ),
                )
            ),
            backgroundColor: (selected
              ? googleMaterialColors.getLightColor(2)
              : selectableItem.avatarColor.withOpacity(0.85)
            )
          ),
          title: Padding(
            padding: EdgeInsets.only(left: 17.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  selectableItem.name,
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