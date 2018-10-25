import 'package:flutter/material.dart';

class Shopping extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _Shopping();
  }
}

class _Shopping extends State<Shopping>{

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: NestedScrollView(        
        headerSliverBuilder: (BuildContext context, bool innerBoxisScrolled){
          return <Widget>[
            SliverAppBar(
              backgroundColor: Color(0xFFfafafa),
              centerTitle: true,
              expandedHeight: 56.0,
              floating: false,
              pinned: true,              
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  "Einkaufsliste", 
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: "Google-Sans",
                      fontSize: 19.0,
                      fontWeight: FontWeight.w200
                  )
                ), 
              )
            )
          ];
        },
        body: new Center(child: Text("Shopping")),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFFDB4437),
        elevation: 4.0,
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, '/');
        },
      )
    );
  }

}