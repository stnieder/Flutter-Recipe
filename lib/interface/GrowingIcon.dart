import 'package:flutter/material.dart';

class GrowingIcon extends StatefulWidget{
  Icon icon;
  Icon changedIcon;
  Color iconColor;
  bool splash;
  void onPressed;  

  GrowingIcon({
    this.icon, 
    this.changedIcon,
    this.iconColor, 
    this.splash,
    @required this.onPressed
  }) : assert(icon != null),
       assert(iconColor != null),
       assert(splash != null);

  @override
    State<StatefulWidget> createState() {
      return _GrowingIcon(this);
    }
}


class _GrowingIcon extends State<GrowingIcon> with TickerProviderStateMixin{
  GrowingIcon growingIcon;
  _GrowingIcon(this.growingIcon);

  double defaultSize = 25.0;
  double growingSize = 30.0;

  AnimationController animationController;
  Animation<double> growingAnimation;  

  @override
    void initState() {
      super.initState();

      animationController = new AnimationController(vsync: this, duration: Duration(milliseconds: 200))
        ..addListener(() => setState((){}))
        ..addStatusListener((status){
          if(status == AnimationStatus.completed){
            animationController.reverse();
          } else if(status == AnimationStatus.dismissed){
            animationController.reset();
          }
        });

      growingAnimation = Tween(begin: defaultSize, end: growingSize).animate(CurvedAnimation(parent: animationController, curve: Curves.linear));    
    }

  @override
    void dispose() {
      super.dispose();
      animationController.dispose();
    }

  Widget growingIconButton(){
    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget child){
        return IconButton(
          icon: growingIcon.icon,
          color: growingIcon.iconColor,
          highlightColor: (growingIcon.splash
            ? Colors.grey[100]
            : Colors.transparent
          ),
          splashColor: (growingIcon.splash
            ? Colors.grey[500]
            : Colors.transparent
          ),
          iconSize: growingAnimation.value,
          onPressed: (){
            animationController.forward();
            growingIcon.onPressed;
          },
        );
      },
    );
  }

  @override
    Widget build(BuildContext context) {
      return growingIconButton();
    }
}