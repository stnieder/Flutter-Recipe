import 'package:Time2Eat/interface/GoogleColors.dart';
import 'package:flutter/material.dart';

import 'CircularImage.dart';

class SelectedRecipe extends StatefulWidget {
  final bool hasImage;
  final Color backgroundColor;
  final AssetImage backgroundImage;
  final String label;
  final Widget littleIcon; 
  final double height;
  final double width;

  SelectedRecipe(
    {
      @required this.hasImage,
      this.backgroundColor,
      this.backgroundImage,
      @required this.label,
      @required this.littleIcon,
      this.height,
      this.width
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
                    child: widget.littleIcon,
                  ),
                )
              ],
            ),
            width: 40.0,
            height: 40.0,
          ),
          (widget.label == ""
            ? Container()
            : new Text(
                widget.label,
                overflow: TextOverflow.ellipsis,
                style: new TextStyle(
                  color: Colors.grey,
                  fontSize: 13.0,
                  fontFamily: 'Google-Sans',
                ),
                textAlign: TextAlign.left,
              )
          ),
        ],
      ),
      height: (widget.height == null
        ? 70.0
        : widget.height
      ),
      width: (widget.width == null
        ? 63.0
        : widget.width
      )
    );
  }
}


