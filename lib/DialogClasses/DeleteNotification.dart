import 'package:flutter/material.dart';

class RoundedBackground extends StatefulWidget {
  final String text;
  final Color textColor;
  final Color background;
  final IconData icon;
  RoundedBackground(
    {
      this.text,
      this.textColor,
      this.background,
      this.icon
    }
  );

  @override
  _RoundedBackgroundState createState() => _RoundedBackgroundState();
}

class _RoundedBackgroundState extends State<RoundedBackground> {
  bool enabled = false;
  

  List<String> sheetText = [
    "Termin löschen",
    "Termin bearbeiten",
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
                child: Icon(
                  widget.icon,
                  color: (enabled
                    ? widget.textColor
                    : Colors.black54
                  ),
                ),
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
          } else if(widget.text == sheetText[2]){
            r_value = "notification";
          } else {
            return;
          }
          Navigator.pop(context, r_value);
        },
      ); 
    }
}