//Created at 24.09.18 by stnieder


import 'package:dragable_flutter_list/dragable_flutter_list.dart';
import 'package:flutter/material.dart';

class Zubereitung extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Zubereitung();
}

class _Zubereitung extends State<Zubereitung> {

  final TextEditingController stepDescriptionController = new TextEditingController();
  GlobalKey<FormState> stepDescriptionKey = new GlobalKey<FormState>();
  double descriptionHeight = 0.0;
  List<String> stepDescription = [];
  int descriptionCounter = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
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
    );
  }
}