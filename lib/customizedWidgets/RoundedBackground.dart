import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RoundedBackground extends StatefulWidget {
  final String text;
  final Color textColor;
  final Color background;
  final String svgAsset;
  RoundedBackground(
    {
      this.text,
      this.textColor,
      this.background,
      this.svgAsset
    }
  );

  @override
  _RoundedBackgroundState createState() => _RoundedBackgroundState();
}

class _RoundedBackgroundState extends State<RoundedBackground> {
  bool enabled = false;
  

  List<String> sheetText = [
    "Termin löschen",
    "Benachrichtigung hinzufügen"
  ];

  @override
    Widget build(BuildContext context) {
      return InkWell(
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          child: Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 20.0, bottom: 20.0, left: 20.0,),                
              ),              
              Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: SvgPicture.asset(
                  widget.svgAsset,
                  color: (enabled
                    ? widget.textColor
                    : Colors.black54
                  ),
                  height: 24.0,
                  width: 24.0,
                )
              ),
              Text(
                widget.text,
                style: TextStyle(
                  color: (enabled
                    ? widget.textColor
                    : Colors.black54
                  ),
                  fontFamily: "Google-Sans",
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold
                ),
              )
            ],
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(50.0),
              topLeft: Radius.circular(50.0)
            ),
            color: (enabled
              ? widget.background
              : Colors.transparent
            )
          ),
        ),
        onTapDown: (TapDownDetails details){
          setState(() {
            enabled = true;
          });
        },
        onTapCancel: (){
          setState(() {
            enabled = false;
          });
        },
        onTap: (){
          String r_value = "";
          if(widget.text == sheetText[0]){
            r_value = "delete";
          } else if(widget.text == sheetText[1]){
            r_value = "notification";
          } else {
            return;
          }
          Navigator.pop(context, r_value);
        },
      ); 
    }
}