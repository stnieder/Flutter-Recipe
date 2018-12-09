import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class SelectPortion extends StatefulWidget {
  int currentNumber;
  SelectPortion(
    {
      @required this.currentNumber
    }
  );

  @override
  _SelectPortionState createState() => _SelectPortionState();
}

class _SelectPortionState extends State<SelectPortion> {

  @override
    void initState() {
      super.initState();
    }

  @override
  Widget build(BuildContext context) {
    return CupertinoPicker(
      onSelectedItemChanged: (selection){
        setState(() {
          widget.currentNumber = selection;
        });
      },
      itemExtent: 20.0,
      children: List.generate(
        101,
        (index){
          Widget text;
          if(index == 0) text = Text("${0.5}");
          else if(index < 101) text = Text("$index");
          return text;
        }
      ),
    );
  }
}