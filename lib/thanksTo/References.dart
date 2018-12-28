import 'package:Time2Eat/thanksTo/ReferenceCard.dart';
import 'package:flutter/material.dart';

class References extends StatelessWidget {

  static const List<String> assetNames = [
    "images/allDone.png",
    "images/empty_shopping.png",
    "images/no_orders.png",
    "images/recipe_not_found.png"
  ];

  static const List<String> referenceURL = [
    "https://dribbble.com/shots/4945296-Job-done-D",
    "https://dribbble.com/shots/5573953-Nothing-Found-Illustration",    
    "https://dribbble.com/shots/4112199--No-Orders-Empty-State-Illustration",
    "https://dribbble.com/shots/4117132--Product-Not-Found-Empty-State-Illustration"
  ];

  static const List<String> publisher = [
    "LazyZhou",
    "Lehel Babos",
    "Sofy Dubinska",
    "Sofy Dubinska"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.help_outline, color: Colors.black54),
            onPressed: () => helpDialog(context),
          )
        ],
        automaticallyImplyLeading: false,        
        backgroundColor: Colors.white,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black54),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Verweis zu den Künstlern",
          style: TextStyle(
            color: Colors.black54
          ),
        ),
      ),
      body: Container(
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.77
          ),
          itemCount: 4,
          itemBuilder: (BuildContext context, int index){
            return ReferenceCard(
              url: referenceURL[index],
              publisher: publisher[index],
              assetName: assetNames[index],
            );
          },
        ),
      ),
    );
  }

  helpDialog(BuildContext context) async{
    showDialog(
      builder: (BuildContext context){
        return SimpleDialog(
          title: Text(
            "Den/Die Künstler/in unterstützen?",
            style: TextStyle(
              fontFamily: "Google-Sans",
              fontSize: 16.0
            ),
          ),
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 25.0, right: 15.0),
              child: Text(
                "Um zur Website zu gelangen, von welcher dieses Bild stammt, einfach darauf klicken.",
                softWrap: true,
              ),
            )
          ],
        );
      },
      context: context,      
    );
  }
}