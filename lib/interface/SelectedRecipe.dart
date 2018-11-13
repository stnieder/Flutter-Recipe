import 'package:Time2Eat/interface/GoogleColors.dart';
import 'package:flutter/material.dart';

import 'CircularImage.dart';

class SelectedRecipe extends StatefulWidget {
  final bool hasImage;
  final Color backgroundColor;
  final AssetImage backgroundImage;
  final String label;

  SelectedRecipe(
    {
      @required this.hasImage,
      this.backgroundColor,
      this.backgroundImage,
      @required this.label
    }
  );

  @override
  _SelectedRecipeState createState() => _SelectedRecipeState();
}

class _SelectedRecipeState extends State<SelectedRecipe> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            child: Stack(
              children: <Widget>[
                (widget.hasImage
                    ? CircularImage(widget.backgroundImage.assetName)
                    : CircleAvatar(
                      backgroundColor: (widget.backgroundColor == null
                          ? new GoogleMaterialColors().primaryColor().withOpacity(0.9)
                          : widget.backgroundColor
                      ),
                      child: Text(
                        widget.label[0],
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "Google-Sans",
                            fontWeight: FontWeight.w400
                        ),
                      ),
                    )
                ),
                Padding(
                  padding: EdgeInsets.only(left: 25.0, top: 20.0),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: RotationTransition(
                      turns: new AlwaysStoppedAnimation(45 / 360),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle
                        ),
                        child: Icon(
                          Icons.add_circle,
                          size: 18.0,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            width: 40.0,
            height: 40.0,
          ),
          new Flexible(
            child: new Container(
              padding: EdgeInsets.only(left: 5.0),
              child: new Text(
                widget.label,
                overflow: TextOverflow.ellipsis,
                style: new TextStyle(
                  fontSize: 13.0,
                  fontFamily: 'Google-Sans',
                ),
              ),
            ),
          ),
        ],
      ),
      height: 70.0,
      width: 55.0
    );
  }
}
