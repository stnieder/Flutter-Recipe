import 'package:flutter/material.dart';

class CustomListTile extends StatefulWidget{
  final Color mainColor;
  final String label;
  final IconData leading;
  final String trailing;

  CustomListTile({
    @required this.mainColor,
    @required this.label,
    @required this.leading,
    this.trailing
  });

  @override
    State<StatefulWidget> createState() {
      return _ListTile();
    }
}

class _ListTile extends State<CustomListTile> with TickerProviderStateMixin{
  bool selected = false;
  bool pressed = false;

  AnimationController _colorController;
  AnimationController _decorationController;
  Animation colorTransition;
  Animation decorationTransition;

  @override
    void initState() {      
      super.initState();
      _colorController = new AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 200)
      )..addListener(()=>setState((){}))..addStatusListener((status){});

      _decorationController = new AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 200)
      )..addListener(()=>setState((){}))..addStatusListener((status){});

      colorTransition = ColorTween(begin: Colors.grey[600], end: widget.mainColor).animate(CurvedAnimation(curve: Curves.linear, parent: _colorController));
      decorationTransition = ColorTween(begin: Color(0xFFfafafa), end: widget.mainColor.withOpacity(0.2)).animate(CurvedAnimation(curve: Curves.linear, parent: _decorationController));
    }

  @override
    Widget build(BuildContext context) {
      return GestureDetector(
        onTap: (){
          setState(() {
            if(selected){
              _colorController.reverse();
              _decorationController.reverse();
            } else if(!selected){
              _colorController.forward();
              _decorationController.forward();
            }
            selected = !selected;            
          });
        },        
        child: Padding(
          padding: EdgeInsets.only(left: 10.0),
          child: Container(                
            child: Padding(
              padding: EdgeInsets.only(bottom: 1.0, left: 15.0),
              child: Row(
                children: <Widget>[
                  Icon(
                    widget.leading, 
                    color: colorTransition.value
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20.0,right: 150.0),
                    child: Text(
                      widget.label,
                      style: TextStyle(
                        color: colorTransition.value,
                        fontWeight: FontWeight.w600
                      ),
                    ),
                  ),
                  (widget.trailing != null
                    ? Text(
                        widget.trailing,
                        style: TextStyle(
                          color: colorTransition.value,
                          fontWeight: FontWeight.w700
                        ),
                      )
                    : Container()
                  )
                ],
              ),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(32.0),
                topLeft: Radius.circular(32.0)
              ),
              color: decorationTransition.value,                  
            ),
            height: 40.0,
          ),
        ),
      );
    }
}