import 'dart:async';
import 'dart:core';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:image_picker/image_picker.dart';

import 'package:recipe/interface/CircularImage.dart';
import 'package:recipe/interface/GoogleColors.dart';
import 'package:recipe/Dialogs.dart';
import 'package:recipe/newRecipe/Allgemein.dart';
import 'package:recipe/newRecipe/Zutaten.dart';

class NewRecipe extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _NewRecipe();
}

class _NewRecipe extends State<NewRecipe>{
  Dialogs dialogs = new Dialogs();

  ScrollController scrollController = new ScrollController();
  File _image;

  String selectedMass;
  List<String> masses = ["kg", "g", "l", "mg", "TL", "EL"];

  List<double> zNumber = [];
  List<String> zMass = [];
  List<String> zNamen = [];
  double zutatenHeight = 0.0;

  final TextEditingController zNumberController = new TextEditingController();
  final TextEditingController zNamenController = new TextEditingController();

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  int personenAnzahl;

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            onPressed: (){},
            icon: Icon(
              Icons.check,
              color: Colors.green[400],
            ),
          ),
        ],
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () async{
            var result = await dialogs.closeDialog(context);
            if(result == "verwerfen") Navigator.pop(context);
          },
          icon: Icon(
            Icons.close,
            color: Colors.grey[500],
          ),
        ),
        title: Text(
          "Rezept erstellen",
          style: TextStyle(
            color: Colors.black,
            fontFamily: "Google-Sans",
            fontWeight: FontWeight.normal,
            fontSize: 17.0
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 10.0, bottom: 20.0, left: 179.0, right: 179.0),
            child: GestureDetector(
              child: Container(
                child: (_image == null
                  ? CircleAvatar(child: Icon(OMIcons.addAPhoto))
                  : CircularImage(_image)
                ),
                height: 52.0,
                width: 50.0,
              ),
              onTap: () async{
                switch(await dialogs.takePhoto(context)){
                  case "take":
                    getImage(ImageSource.camera);
                    break;
                  case "pick":
                    getImage(ImageSource.gallery);
                    break;
                }
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 20.0),
              ),
              InkWell(
                borderRadius: BorderRadius.circular(10.0),
                onTap: () async{
                  personenAnzahl = await dialogs.personenAnzahl(context);
                  setState(() {});
                },
                child: Column(
                  children: <Widget>[
                    Icon(OMIcons.group),
                    Center(
                        child: Text(personenAnzahl == null
                                  ? "-"
                                  : personenAnzahl.toString(), style: TextStyle(fontFamily: "Google-Sans"),
                                ),
                    )
                  ],
                ),
              ),
              InkWell(
                borderRadius: BorderRadius.circular(10.0),
                onTap: (){
                  //dialog mit eingabe der zeit der zubereitung
                },
                child: Column(
                  children: <Widget>[
                    Icon(OMIcons.avTimer),
                    Center(child: Text("-"))
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 20.0),
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.only(left: 20.0, right: 20.0),
            child: Divider(),
          )
        ],
      ),
    );
  }
  
  Future getImage(ImageSource imageSource) async{
    var image = await ImagePicker.pickImage(source: imageSource);
    setState(() {
      _image = image;
    });
  }
}