import 'package:flutter/material.dart';

class MyListTileText extends StatefulWidget {
  final bool enabled;
  final Color backgroundColor;
  final String childText;

  MyListTileText(
    {
      this.enabled,
      this.backgroundColor,
      @required this.childText
    }
  );

  @override
  _MyListTileTextState createState() => _MyListTileTextState();
}

class _MyListTileTextState extends State<MyListTileText> with TickerProviderStateMixin{
  Color backgroundColor;
  Color color;

  bool pressed = false;
  Animation _enabledAnimation;
  AnimationController _enabledController;

  Animation _disabledAnimation;
  AnimationController _disabledController;

  @override
    void initState() {
      super.initState();
      if(widget.backgroundColor != null) {
        backgroundColor = widget.backgroundColor;        
      } else {
        backgroundColor = Color(0xFF4285f4);
      }
      color = backgroundColor;

      _enabledController = new AnimationController(
        duration: Duration(milliseconds: 200),
        vsync: this
      );
      _disabledController = new AnimationController(
        duration: Duration(microseconds: 200),
        vsync: this
      );
      _enabledAnimation = ColorTween(begin: backgroundColor.withOpacity(0.2), end: backgroundColor.withOpacity(0.05)).animate(CurvedAnimation(parent: _enabledController, curve: Curves.linear));
      _disabledAnimation = ColorTween(begin: Colors.transparent, end: backgroundColor.withOpacity(0.05)).animate(CurvedAnimation(parent: _disabledController, curve: Curves.linear));
    }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        child: Row(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 16.0, bottom: 16.0, left: 15.0),              
            ),
            Text(
              widget.childText,
              style: TextStyle(
                color: (widget.enabled
                  ? backgroundColor.withOpacity(0.8)
                  : Colors.black54
                ),
                fontFamily: "Google-Sans",
                fontWeight: FontWeight.bold
              ),
            )
          ],
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50.0),
            bottomLeft: Radius.circular(50.0)          
          ),
          color: (widget.enabled
            ? _enabledAnimation.value
            : _disabledAnimation.value
          )
        ),
      ),
      onPanStart: (DragStartDetails details){
        setState(() {
          pressed = true;
          if(widget.enabled) _enabledController.forward();
          else _disabledController.forward();
        });
      },
      onTapCancel: (){
        setState(() {
          pressed = false;
          if(widget.enabled) _enabledController.reverse();
          else _disabledController.reverse();
        });
      },
    );
  }
}






class MyListTileWidget extends StatefulWidget {
  final bool enabled;
  final Color backgroundColor;
  final ListTile child;

  MyListTileWidget(
    {
      this.enabled,
      this.backgroundColor,
      @required this.child
    }
  );

  @override
  _MyListTileWidgetState createState() => _MyListTileWidgetState();
}

class _MyListTileWidgetState extends State<MyListTileWidget> with TickerProviderStateMixin{
  Color backgroundColor;

  Animation _animation;
  AnimationController _controller;

  @override
    void initState() {
      super.initState();
      if(widget.backgroundColor != null) {
        backgroundColor = widget.backgroundColor;        
      } else {
        backgroundColor = Color(0xFF4285f4);
      }

      _controller = new AnimationController(
        lowerBound: 0.3,
        duration: Duration(microseconds: 200),
        vsync: this
      );
      _animation = ColorTween(begin: Colors.white, end: backgroundColor.withOpacity(0.05)).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));
    }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        child: widget.child,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50.0),
            bottomLeft: Radius.circular(50.0)          
          ),
          color: _animation.value
        ),
      ),
      onScaleStart: (ScaleStartDetails details){
        setState(() {
          _controller.reverse();
        });
      },
      onScaleEnd: (ScaleEndDetails details){
        setState(() {
          _controller.reverse();
        });
      },
    );
  }
}