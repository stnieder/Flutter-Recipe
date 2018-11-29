import 'package:flutter/material.dart';

class RoundCheckBoxListTile extends StatefulWidget{
  final bool underline;
  final Widget title;
  final Widget trailing;
  final Function onTap;
  final bool checked;  

  RoundCheckBoxListTile(
    {
      this.checked,
      this.onTap,
      @required this.title,
      this.trailing,
      this.underline
    }
  );

  @override
  State<StatefulWidget> createState() {
    return _RoundCheckBoxListTile();
  }
}

class _RoundCheckBoxListTile extends State<RoundCheckBoxListTile>{
  bool checked = false;

  @override
  void initState() {
    super.initState();
    if(widget.checked != null) checked = widget.checked;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 10.0, top: 5.0, bottom: 5.0),
          child: Row(
            children: <Widget>[
              (widget.underline
                ? Divider()
                : Container()
              ),
              GestureDetector(
                child: (checked
                    ? Padding(
                  padding: EdgeInsets.only(right: 17.0,top: 2.0),
                  child: Icon(
                    Icons.check,
                    color: Colors.blue,
                  ),
                )
                    : Padding(
                  padding: EdgeInsets.only(left: 4.0, top: 6.0, right: 17.0),
                  child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black26,
                            width: 2.0
                          ),
                          shape: BoxShape.circle
                      ),
                      child: Text(""),
                      height: 20.0,
                      width: 20.0
                  ),
                )
                ),
                onTap: (){
                  setState(() {
                    checked = !checked;
                  });
                  widget.onTap();
                },
              ),
              Padding(
                padding: EdgeInsets.only(top: 4.0),
                child: widget.title,
              ),
              (widget.trailing == null
                  ? Container()
                  : widget.trailing
              )
            ],
          ),
        ),        
      ],
    );
  }
}