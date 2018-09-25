//Created at 24.09.18 by stnieder


import 'package:flutter/material.dart';
import 'package:outline_material_icons/outline_material_icons.dart';

class Allgemein extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Allgemein();
}

class _Allgemein extends State<Allgemein> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
            padding: EdgeInsets.only(top: 10.0, left: 10.0, bottom: 0.0),
            child: Text(
              "Allgemein",
              style: TextStyle(
                  fontFamily: "Google-Sans",
                  fontWeight: FontWeight.w500,
                  fontSize: 13.0,
                  color: Colors.grey[500]
              ),
            )
        ),
        Column(
          children: <Widget>[
            ListTile(
              leading: Padding(
                padding: EdgeInsets.only(bottom: 20.0),
                child: Icon(OMIcons.fastfood),
              ),
              title: TextField(
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: "Name",
                  ),
                  maxLength: 30,
                  maxLengthEnforced: true
              ),
            ),
            ListTile(
              leading: Padding(
                padding: EdgeInsets.only(bottom: 20.0),
                child: Icon(OMIcons.subject),
              ),
              title: TextField(
                decoration: InputDecoration(
                    hintText: "Beschreibe dein Rezept..."
                ),
                keyboardType: TextInputType.multiline,
                maxLines: null,
                maxLength: 200,
              ),
            )
          ],
        ),
      ],
    );
  }
}