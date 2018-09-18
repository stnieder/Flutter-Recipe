import 'package:flutter/material.dart';

class ContainerRedesign extends StatefulWidget{
  String title;
  List<Widget> children;
  ContainerRedesign(
    {
      this.children,
      this.title
    }
  ) : assert(
    children != null,
    title != null
  );

  @override
  _ContainerRedesign createState() => _ContainerRedesign(children, title);
}

class _ContainerRedesign extends State<ContainerRedesign>{
  List<Widget> children;
  String title;
  _ContainerRedesign(this.children, this.title);

  //Put children inside Column to be acceptable
  Widget childrenWidgets(){
    return new Column(
      children: children,
    );
  }

  bool expanded = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 10.0, left: 10.0, bottom: 0.0),
          child: GestureDetector(
            child: Text(
                title,
                style: TextStyle(
                    fontFamily: "Google-Sans",
                    fontWeight: FontWeight.w500,
                    fontSize: (expanded
                      ? 13.0
                      : 14.0
                    ),
                    color: Colors.grey[500]
                ),
            ),
            onTap: (){
              setState(() {
                expanded = !expanded;
              });
            },
          )
        ),
        childrenWidgets(),
        Divider()
      ],
    );
  }
}