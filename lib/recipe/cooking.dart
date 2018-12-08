import 'package:flutter/material.dart';

import 'package:Time2Eat/interface/RoundCheckBox.dart';

class StartCooking extends StatefulWidget {
  final List<String> steps;
  StartCooking({this.steps});

  @override
  _StartCookingState createState() => _StartCookingState();
}

class _StartCookingState extends State<StartCooking> {
  int oldStep;
  int currentStep;
  List<Step> stepper = new List();

  GlobalKey<CheckCardsState> cardKey;
  List<GlobalKey<CheckCardsState>> _keys = new List();
  Map<int, GlobalKey> map = new Map();

  ThemeData enabledTheme = ThemeData(

  );

  @override
    void initState() {
      super.initState();      
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).canvasColor,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.black45),
          onPressed: () {
            //Zuerst ein Dialog zur Bestätigung
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 0.0),
        child: _stepper(),
      )
    );
  }

  _stepper(){
    List<Widget> titles = new List();
    for (var i = 0; i < widget.steps.length; i++) {
      titles.add(
        Padding(
          padding: EdgeInsets.only(top: 8.0, right: 15.0),
          child: Text(
            "${widget.steps[i]}",
            style: TextStyle(
              fontFamily: "Google-Sans",
              fontSize: 14.0,
              fontWeight: FontWeight.w300
            ),
          ),
        )
      );
    }

    return CheckCards(
      itemCount: widget.steps.length,
      titles: titles,
    );
  }
}

class CheckCards extends StatefulWidget {
  final int itemCount;
  final List<Widget> titles;
  CheckCards(
    {
      Key key,
      @required this.itemCount,
      @required this.titles,
    }
  ) : super(key: key);

  @override
  CheckCardsState createState() => CheckCardsState();
}

class CheckCardsState extends State<CheckCards> {
  bool checked;
  List<bool> checkedList = new List();

  @override
    void initState() {
      super.initState();
      checked = false;
      for(int i=0; i < widget.itemCount; i++){
        checkedList.add(false);
      }
    }

  @override
  Widget build(BuildContext context) {
    List<Widget> cards = new List();
    for (var i = 0; i < widget.itemCount; i++) {
      cards.add(
        Card(          
          elevation: 2.0,
          shape: new RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0))
          ),
          child: ListTile(
            onTap: (){
              setState(() {
                checkedList[i] = !checkedList[i];
                if(checkedList[i] == true){
                  for(int j=i-1; j > -1; j--){
                    checkedList[j] = true;
                  }
                } else if(checkedList[i] == false){
                  for(int j=i+1; j < widget.itemCount; j++){
                    checkedList[j] = false;
                  }
                }
              });
            },
            leading: Text(
              "${i+1}",
              style: TextStyle(
                color: Colors.amber,
                fontFamily: "Google-Sans",
                fontSize: 15.0,
                fontWeight: FontWeight.bold
              ),
            ),
            title: widget.titles[i],
            trailing: AnimatedCrossFade(
              firstChild: Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black26,
                        width: 2.0
                      ),
                      shape: BoxShape.circle
                  ),
                  child: Text(""),
                  height: 24.0,
                  width: 24.0
              ),
              secondChild: Container(                
                child: Icon(Icons.check, color:  Colors.white),
                decoration: BoxDecoration(
                  color: Colors.amber,
                  shape: BoxShape.circle
                ),
              ),
              duration: Duration(milliseconds: 200),
              crossFadeState: (checkedList[i]
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst
              ),
            ),
          ),
        )
      );
    }

    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (scrolling){
        scrolling.disallowGlow();
      },
      child: ListView(
        children: cards,
      ),
    );
  }
}