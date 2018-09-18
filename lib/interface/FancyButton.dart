import 'package:flutter/material.dart';

class FancyButton extends StatefulWidget{
  final Function() onPressed;
  final IconData icon;

  FancyButton({this.onPressed, this.icon});

  @override
  _FancyButtonState createState() => _FancyButtonState();
}

class _FancyButtonState extends State<FancyButton> with SingleTickerProviderStateMixin{
  bool isOpen = false;
  bool _visible = false;
  AnimationController _animationController;
  Animation<Color> _animateColor;
  Animation<EdgeInsetsGeometry> _descriptionMove;
  Animation _animateRotation;
  Curve _curve = Curves.easeInOut;

  @override
  void initState() {
    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 200))
      ..addListener((){
        setState(() {});
      });

    _animateRotation = Tween(begin: Matrix4.rotationZ(0.0), end: Matrix4.rotationZ(-150.0)).animate(CurvedAnimation(parent: _animationController, curve: Curves.linear));

    _animateColor = ColorTween(begin: Colors.blueAccent, end: Colors.grey).animate(CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.00, 1.00, curve: _curve),
      )
    );

    _descriptionMove = EdgeInsetsGeometryTween(begin: EdgeInsets.only(left: 0.0), end: EdgeInsets.only(left: 10.0)).animate(CurvedAnimation(parent: _animationController, curve: Curves.linear));

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  animate(){
    if(!isOpen){ //isOpen is false
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    isOpen = !isOpen;
    _visible = !_visible;
  }

  Widget addLabel(){
    return Padding(
        padding: EdgeInsets.only(left: 20.0),
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (BuildContext context, Widget child){
            return AnimatedOpacity(
                duration: Duration(milliseconds: 200),
                opacity: _visible ? 1.0 : 0.0,
                child: Padding(
                  padding: _descriptionMove.value,
                  child: IconButton(
                    icon: Icon(Icons.label_outline, color: Colors.blueAccent),
                    onPressed: (){},
                  ),
                )
            );
          },
        ),
      );
  }

  Widget toggle(){
    return AnimatedBuilder(
      animation: _animationController,
      builder: (BuildContext context, Widget child){
        return Transform(
          alignment: FractionalOffset.center,
          transform: _animateRotation.value,
          child: IconButton(
            color: _animateColor.value,
              onPressed: animate,
              icon: Icon(Icons.add_circle),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        addLabel(),
        toggle(),
      ],
    );
  }

}