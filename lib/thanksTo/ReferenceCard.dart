import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ReferenceCard extends StatelessWidget{

  final String url;
  final String publisher;
  final String assetName;
  ReferenceCard({this.url, this.publisher, this.assetName});


  @override
    Widget build(BuildContext context) {
      return Container(
        child: Card(
          elevation: 3.0,
          child: Column(
            children: <Widget>[
              GestureDetector(
                child: Container(
                  child: Image.asset(
                    assetName,
                    height: MediaQuery.of(context).size.height/3,
                    width: 192.0,
                  )
                ),
                onTap: (){
                  _launchURL();
                },
              ),
              Container(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 10.0, left: 15.0),
                  child: Text(
                    publisher,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                width: MediaQuery.of(context).size.width,
              )
            ],
          ),        
        ),
      );
    }


  _launchURL() async{
    if(await canLaunch(url)){
      await launch(
        url,
        forceWebView: true
      );
    } else {
      throw "URL konnte nicht abgerufen werden.";
    }
  }
}