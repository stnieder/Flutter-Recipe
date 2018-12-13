import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:path_provider/path_provider.dart';



class JsonExample extends StatefulWidget {
  @override
  _JsonExampleState createState() => _JsonExampleState();
}

class _JsonExampleState extends State<JsonExample> {
  File jsonFile;
  Directory directory;
  Map<String,dynamic> jsonMap;
  String filename = "recipe_name.json";
  bool fileExists = false;


  @override
    void initState() {
      super.initState();
      getApplicationDocumentsDirectory().then((Directory dir){
        directory = dir;
        jsonFile = new File(directory.path+"/"+filename);
        fileExists = jsonFile.existsSync();
        if(fileExists) {
          this.setState((){
            jsonMap = json.decode(jsonFile.readAsStringSync());
          });
        }
      });
    }

  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }

  File createFile(Map<String, dynamic> content) {

  }

  void writeFile(List<dynamic> values){
    
  }
}