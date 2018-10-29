import 'package:flutter/material.dart';

import 'SearchTransition.dart';

class SearchBox extends StatefulWidget{    
  final bool addBorder;
  final bool autofocus;
  final double elevation;
  final double height;
  final Widget leadingButton;
  final double width;
  final List<Widget> trailingButton;
  final String hintText;
  final onTextFieldPressed;
  final Color backgroundColor;
  final TextEditingController searchController;

  SearchBox({
    @required this.leadingButton,
    this.trailingButton,
    @required this.addBorder,
    this.autofocus,
    @required this.elevation,
    this.height,
    this.width,
    this.hintText,
    this.onTextFieldPressed,
    this.backgroundColor,
    this.searchController
  });

  @override
    State<StatefulWidget> createState() {
      return _SearchBox();
    }
}

class _SearchBox extends State<SearchBox>{

  List<Widget> trailingList = new List();
  final FocusNode focusNode = FocusNode(); 

  @override
    void initState() {
      super.initState();
      if(widget.trailingButton != null){
        for(int i=0; i<widget.trailingButton.length; i++){
          trailingList.add(widget.trailingButton[i]);
        }
      }      
    }

  @override
    void dispose() {
      super.dispose();
      widget.searchController.dispose();
      focusNode.dispose();
    }
  
  @override
    Widget build(BuildContext context) {
      return Card(  
        color: widget.backgroundColor,      
        child: Container(          
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 2.0),
                child: widget.leadingButton,
              ),
              Flexible(                
                child: InkWell(
                  onTap: widget.onTextFieldPressed,
                  child: (widget.onTextFieldPressed == null
                    ? TextField(   
                          autofocus: widget.autofocus,                 
                          controller: widget.searchController,                      
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: (widget.hintText == null
                              ? ""
                              : widget.hintText
                            ),
                            hintStyle: TextStyle(
                              fontFamily: "Google-Sans"
                            )
                          ),
                          focusNode: focusNode
                        )
                    : IgnorePointer(                    
                        child: TextField(   
                          autofocus: widget.autofocus,                 
                          controller: widget.searchController,                      
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: (widget.hintText == null
                              ? ""
                              : widget.hintText
                            )
                          ),
                          focusNode: focusNode,                  
                        ),
                      )
                  ),
                ),
              ),
              (widget.trailingButton == null
                ? Container()
                : Row(
                    children: trailingList,
                  )
              )
            ],
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(8.0)
            ),
          ),  
          height: (widget.height == null
            ? 25.0
            : widget.height
          ),      
          width: (widget.width == null
            ? 500.0
            : widget.width
          ),
        ),
        elevation: (widget.addBorder
          ? widget.elevation
          : 0.0
        ),       
      );
    }
}