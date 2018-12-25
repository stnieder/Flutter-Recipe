import 'package:flutter/material.dart';


class StartCooking extends StatefulWidget {
  final List<String> steps;
  final String recipe;
  StartCooking({this.steps, @required this.recipe});

  @override
  _StartCookingState createState() => _StartCookingState();
}

class _StartCookingState extends State<StartCooking> {
  int oldStep;
  int currentStep;
  List<Step> stepper = new List();

  GlobalKey<CheckCardsState> cardKey;
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
            Navigator.pop(context);
          },
        ),
        title: Text(
          widget.recipe,
          style: TextStyle(
            fontFamily: "Google-Sans"
          ),
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

class CheckCardsState extends State<CheckCards> with SingleTickerProviderStateMixin{
  bool checked;
  List<bool> checkedList = new List();
  AnimationController _animation;

  ThemeData checkedTheme = ThemeData(
    accentColor: Colors.grey[700],
    cardColor: Colors.black.withOpacity(0.1),
    textTheme: TextTheme(
      body1: TextStyle(
        color: Colors.grey[850],
        fontFamily: "Google-Sans",
        fontSize: 14.0
      )
    )
  );

  ThemeData notchecked = ThemeData(
    accentColor: Colors.amber,
    cardColor: Colors.white,
    textTheme: TextTheme(
      body1: TextStyle(
        color: Colors.black,
        fontFamily: "Google-Sans",
        fontSize: 14.0
      )
    )
  );

  @override
    void initState() {
      super.initState();
      checked = false;
      for(int i=0; i < widget.itemCount; i++){
        checkedList.add(false);
      }

      _animation = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 300)
      );

      _animation.repeat();
    }

  @override
  Widget build(BuildContext context) {
    List<Widget> cards = new List();
    for (var i = 0; i < widget.itemCount; i++) {
      cards.add(
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.grey[300])
            )
          ),
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, child){
              return Container( 
                color: (checkedList[i] == false
                  ? Colors.white
                  : Colors.grey[300]
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
                      color: (checkedList[i] == false
                        ? Colors.amber
                        : Colors.black.withOpacity(0.5)
                      ),
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
              );
            },
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