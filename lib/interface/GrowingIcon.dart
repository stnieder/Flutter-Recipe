import 'package:flutter/material.dart';

class GrowingIcon extends StatefulWidget{
  IconData defaultIcon;
  IconData changeToIcon;
  Color iconColor;
  int favorite; 
  double startSize;
  double endSize;

  GrowingIcon({
    this.defaultIcon, 
    this.changeToIcon,
    this.favorite,
    this.iconColor,
    this.startSize,
    this.endSize
  }) : assert(defaultIcon != null),
       assert(changeToIcon != null),
       assert(iconColor != null);

  @override
    State<StatefulWidget> createState() {
      return _GrowingIcon(this);
    }
}


class _GrowingIcon extends State<GrowingIcon> with TickerProviderStateMixin{
  GrowingIcon growingIcon;
  _GrowingIcon(this.growingIcon);

  bool favorite;
  Icon iconButtonIcon;

  AnimationController animationController;
  Animation<double> growingAnimation;  
  Animation<Icon> changeAnimation;

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

      growingAnimation = Tween(begin: growingIcon.startSize, end: growingIcon.endSize).animate(CurvedAnimation(parent: animationController, curve: Curves.linear));          
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
        return Icon(
          (
            growingIcon.favorite == 0
              ? growingIcon.defaultIcon
              : growingIcon.changeToIcon
          ),
          color: growingIcon.iconColor,
          size: growingAnimation.value,          
        );
      },
    );
  }

  @override
    Widget build(BuildContext context) {
      return growingIconButton();
    }
}