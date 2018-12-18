import 'package:Time2Eat/customizedWidgets/CustomListTile.dart';
import 'package:flutter/material.dart';

class ActiveDrawer extends StatefulWidget{
  final List<CustomListTile> children;

  ActiveDrawer(
    {
      @required this.children     
    }
  );

  @override
    State<StatefulWidget> createState() {
      return _ActiveDrawer();
    }
}

class _ActiveDrawer extends State<ActiveDrawer>{
  @override
  bool get wantKeepAlive => true;

  @override
    Widget build(BuildContext context) {
      return Drawer(
        child: Column(
          children: widget.children,
        ),
      );
    }
}