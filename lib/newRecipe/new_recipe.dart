import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:outline_material_icons/outline_material_icons.dart';

import 'package:image_picker/image_picker.dart';
import 'package:recipe/interface/CircularImage.dart';

import 'package:recipe/interface/ContainerDesign.dart';
import 'package:recipe/Dialogs.dart';

class NewRecipe extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _NewRecipe();
}

class _NewRecipe extends State<NewRecipe>{
  Dialogs dialogs = new Dialogs();

  ScrollController scrollController = new ScrollController();
  File _image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        body: Container(
          color: Colors.white,
          child: ListView(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 10.0, bottom: 20.0, left: 179.0, right: 179.0),
                child: GestureDetector(
                  child: Container(
                    child: (_image == null
                      ? CircleAvatar(child: Icon(OMIcons.addAPhoto))
                      : CircularImage(_image)
                    ),
                    height: 50.0,
                    width: 50.0,
                  ),
                  onTap: () async{
                    String takePhoto = await dialogs.takePhoto(context);
                    if(takePhoto == "machen") getImage(ImageSource.camera);
                    else if(takePhoto == "auswählen") getImage(ImageSource.gallery);
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
                    onTap: (){
                      //dialog mit eingabe der personenanzahl
                    },
                    child: Column(
                      children: <Widget>[
                        Icon(OMIcons.group),
                        Center(child: Text("-"))
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
              ContainerRedesign(
                title: "Allgemein",
                height: 190.0,
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
          ),
        ),
      );
  }
  
  Future getImage(ImageSource imageSource) async{
    var takePhoto = await dialogs.takePhoto(context);
    var image = await ImagePicker.pickImage(source: imageSource);
    setState(() {
      _image = image;
    });
  }
  
}