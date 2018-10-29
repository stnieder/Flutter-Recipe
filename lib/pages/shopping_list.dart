import 'package:flutter/material.dart';
import 'package:recipe/interface/GoogleColors.dart';

class Shopping extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _Shopping();
  }
}

class _Shopping extends State<Shopping>{
  GoogleMaterialColors googleMaterialColors = new GoogleMaterialColors();

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
        backgroundColor: googleMaterialColors.primaryColor(),
        child: Icon(Icons.add),
        elevation: 4.0,        
        onPressed: () {
          Navigator.pushNamed(context, '/');
        },
      )
    );
  }

}