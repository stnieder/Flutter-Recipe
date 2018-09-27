import 'dart:async';
import 'dart:core';
import 'dart:io';
import 'dart:math';
import 'package:dragable_flutter_list/dragable_flutter_list.dart';
import 'package:flutter/material.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:image_picker/image_picker.dart';

import 'package:recipe/interface/CircularImage.dart';
import 'package:recipe/Dialogs.dart';

class NewRecipe extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _NewRecipe();
}

class _NewRecipe extends State<NewRecipe>{
  Dialogs dialogs = new Dialogs();

  //MainPage
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  File _image;
  double personenAnzahl;

  //Zutaten
  double zutatHeight;
  List<double> numberList = [];
  List<String> mass = ["kg","g","l","ml","TL","EL"];
  List<String> massList = [];
  List<String> nameList = [];
  String selectedMass;
  TextEditingController nameController = new TextEditingController();
  TextEditingController numberController = new TextEditingController();


  //Zubereitung
  final TextEditingController stepDescriptionController = new TextEditingController();
  GlobalKey<FormState> stepDescriptionKey = new GlobalKey<FormState>();
  double descriptionHeight = 0.0;
  List<String> stepDescription = [];
  int descriptionCounter = 0;

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
      body: ListView(
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
                onTap: () async{
                  var returnedNumber = await dialogs.personenAnzahl(context);
                  print(returnedNumber);
                },
                child: Column(
                  children: <Widget>[
                    Icon(OMIcons.group),
                    Center(child: Text(personenAnzahl == null
                        ? "-"
                        : personenAnzahl
                    ))
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
          Column(
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
              Divider()
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(top: 10.0, left: 10.0, bottom: 0.0),
                  child: Text(
                    "Zutaten",
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
                    leading: IconButton(
                      icon: Icon(Icons.close),
                      onPressed: (){
                        numberController.clear();
                        selectedMass = null;
                        numberController.clear();
                        setState(() {
                        });
                      },
                      tooltip: "leeren",
                    ),
                    title: Row(
                      children: <Widget>[
                        Container(
                            width: 50.0,
                            child: Padding(
                              padding: EdgeInsets.only(top: 8.0, right: 5.0),
                              child: TextFormField(
                                controller: numberController,
                                decoration: InputDecoration(
                                    border: UnderlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(2.0)),
                                    ),
                                    contentPadding: EdgeInsets.only(bottom: 5.0),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black12, style: BorderStyle.solid),
                                    ),
                                    hintText: "2.0"
                                ),
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                              ),
                            )
                        ),
                        Container(
                          child: new DropdownButton(
                            items: mass.map((String value){
                              return new DropdownMenuItem<String>(
                                value: value,
                                child: new Text(
                                    value
                                ),
                              );
                            }).toList(),
                            hint: Text("Maß"),
                            onChanged: (String newValue){
                              setState(() {
                                selectedMass = newValue;
                              });
                            },
                            value: selectedMass,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10.0, top: 8.0),
                          child: Container(
                            width: 100.0,
                            child: TextFormField(
                                controller: numberController,
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.only(bottom: 5.0),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black12, style: BorderStyle.solid),
                                    ),
                                    hintText: "Bezeichnung"
                                ),
                                keyboardType: TextInputType.text
                            ),
                          ),
                        )
                      ],
                    ),
                    trailing: IconButton(
                      tooltip: "hinzufügen",
                      icon: Icon(Icons.check),
                      onPressed: (){
                        setState(() {
                          zutatHeight += 50.0;
                          numberList.add(double.parse(numberController.text));
                          numberController.clear();

                          massList.add(selectedMass);
                          selectedMass == null;

                          numberList.add(double.parse(numberController.text));
                          numberController.clear();
                        });
                      },
                    ),
                  ),
                  Divider(

                  ),
                  Container(
                    height: zutatHeight+6,
                    child:ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: numberList.length,
                      itemBuilder: (BuildContext ctxt, int index){
                        final name = nameList[index];
                        final number = numberList[index];
                        final mass = massList[index];

                        return Dismissible(
                          background: Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.only(left: 20.0),
                            color: Colors.redAccent,
                            child: Icon(OMIcons.delete, color: Colors.white),
                          ),
                          secondaryBackground: Container(
                            alignment: Alignment.centerRight,
                            padding: EdgeInsets.only(right: 20.0),
                            color: Colors.orangeAccent,
                            child: Icon(OMIcons.edit, color: Colors.white),
                          ),
                          key: Key(name),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              ListTile(
                                leading: IconButton(
                                  icon: Icon(Icons.remove),
                                  onPressed: (){
                                    reducenumberList(index);
                                  },
                                ),
                                title: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                        number.toString()+mass+" "+name[index]
                                    )
                                  ],
                                ),
                                trailing: IconButton(
                                    icon: Icon(Icons.add),
                                    onPressed: (){
                                      numberList[index]++;
                                    }
                                ),
                              ),
                            ],
                          ),
                          direction: (numberController.text.isEmpty
                              ? DismissDirection.horizontal
                              : DismissDirection.startToEnd
                          ),
                          onDismissed: (direction){
                            if(direction == DismissDirection.startToEnd){
                              setState(() {
                                reducenumberList(index);

                                numberList.removeAt(index);
                                massList.removeAt(index);
                                numberList.removeAt(index);
                              });
                            } else if(direction == DismissDirection.endToStart){
                              if(numberController.text.isNotEmpty){
                                showBottomSnack("Dismissed abortion");
                              } else if(numberController.text.isEmpty){
                                numberController.text = numberList[index].toString();
                                selectedMass = massList[index];

                                numberList.removeAt(index);
                                massList.removeAt(index);
                                numberList.removeAt(index);

                                reducenumberList(index);
                              }

                              setState(() {});
                            }
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
          Column(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(top: 10.0, left: 10.0, bottom: 0.0),
                      child: Text(
                        "Zubereitung",
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
                      Form(
                        child: ListTile(
                          leading: IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: (){},
                          ),
                          title: TextFormField(
                            controller: stepDescriptionController,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Ein Schritt nach dem Anderen"
                            ),
                            validator: (value){
                              if(value.isEmpty){
                                return "Bitte Text eingeben";
                              }
                            },
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.check),
                            onPressed: (){
                              if(stepDescriptionKey.currentState.validate()){
                                descriptionHeight+=20.0;
                                stepDescription.add(stepDescriptionController.text);
                                stepDescriptionController.clear();
                                setState(() {});
                              }
                            },
                          ),
                        ),
                        key: stepDescriptionKey,
                      ),
                      Container(
                        height: descriptionHeight,
                        child: DragAndDropList(
                          stepDescription.length,
                          itemBuilder: (BuildContext ctxt, index){
                            return new SizedBox(
                              child: new Card(
                                child: new ListTile(
                                  leading: CircleAvatar(
                                    child: Text(index.toString()),
                                  ),
                                  title: Text(stepDescription[index]),
                                ),
                              ),
                            );
                          },
                          onDragFinish: (before, after){
                            String data = stepDescription[before];
                            stepDescription.removeAt(before);
                            stepDescription.insert(after, data);
                            setState(() {});
                          },
                          canBeDraggedTo: (one, two) => true,
                          dragElevation: 6.0,
                        ),
                      )
                    ],
                  ),
                  Divider()
                ],
              )
            ],
          )
        ],
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

  void showBottomSnack(String value){
    _scaffoldKey.currentState.showSnackBar(
        new SnackBar(
          content: Text(value),
        )
    );
  }

  void reducenumberList(int index){
    if(numberList[index] > 0.0){
      numberList[index]--;
    } else if(numberList[index] == 0.0){
      setState(() {
        numberList.removeAt(index);
        massList.removeAt(index);
        numberList.removeAt(index);
      });
    }
  }
}