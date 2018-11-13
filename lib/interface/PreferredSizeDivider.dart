import 'package:flutter/material.dart';

class PreferredSizeDivider extends Divider implements PreferredSizeWidget {
  PreferredSizeDivider({
    Key key,
    height = 16.0,
    indent = 0.0,
    color,
  })  : assert(height >= 0.0),
        super(
        key: key,
        height: height,
        indent: indent,
        color: color,
      ) {
    preferredSize = Size(double.infinity, height);
  }

  @override
  Size preferredSize;
}