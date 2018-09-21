import 'package:flutter/material.dart';

class ContainerRedesign extends StatefulWidget{
  AlignmentGeometry alignment;
  List<Widget> children;
  BoxConstraints constraints;
  Color color;
  Decoration decoration;
  Decoration foregroundDecoration;
  double height;
  Key key;
  EdgeInsetsGeometry margin;
  EdgeInsetsGeometry padding;
  String title;
  Matrix4 transform;
  double width;

  ContainerRedesign(
    {
      Key key,
      this.alignment,
      this.padding,
      color,
      Decoration decoration,
      this.foregroundDecoration,
      double width,
      double height,
      BoxConstraints constraints,
      this.margin,
      this.transform,
      this.title,
      this.children,
    }
  ) : assert(margin == null || margin.isNonNegative),
        assert(padding == null || padding.isNonNegative),
        assert(decoration == null || decoration.debugAssertIsValid()),
        assert(constraints == null || constraints.debugAssertIsValid()),
        assert(color == null || decoration == null,
        'Cannot provide both a color and a decoration\n'
            'The color argument is just a shorthand for "decoration: new BoxDecoration(color: color)".'
        ),
        decoration = decoration ?? (color != null ? new BoxDecoration(color: color) : null),
        constraints =
        (width != null || height != null)
            ? constraints?.tighten(width: width, height: height)
            ?? new BoxConstraints.tightFor(width: width, height: height)
            : constraints,
        super(key: key);

  @override
  _ContainerRedesign createState() => _ContainerRedesign(
    key,
    alignment,
    padding,
    color,
    decoration,
    foregroundDecoration,
    width,
    height,
    constraints,
    margin,
    transform,
    title,
    children
  );
}

class _ContainerRedesign extends State<ContainerRedesign>{
  AlignmentGeometry alignment;
  List<Widget> children;
  BoxConstraints constraints;
  Color color;
  Decoration decoration;
  Decoration foregroundDecoration;
  double height;
  Key key;
  EdgeInsetsGeometry margin;
  EdgeInsetsGeometry padding;
  String title;
  Matrix4 transform;
  double width;

  _ContainerRedesign(
      Key key,
      this.alignment,
      this.padding,
      color,
      Decoration decoration,
      this.foregroundDecoration,
      double width,
      double height,
      BoxConstraints constraints,
      this.margin,
      this.transform,
      this.title,
      this.children,
    );

  //Put children inside Column to be acceptable
  Widget childrenWidgets(){
    return new Column(
      children: children,
    );
  }

  bool expanded = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment,
      color: color,
      constraints: constraints,
      child: Column(
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
      ),
      decoration: decoration,
      foregroundDecoration: foregroundDecoration,
      height: height,
      key: key,
      padding: padding,
      transform: transform,
      width: width,
    );
  }
}