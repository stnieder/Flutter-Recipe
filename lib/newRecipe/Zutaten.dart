//Created at 24.09.18 by stnieder


import 'package:flutter/material.dart';
import 'package:outline_material_icons/outline_material_icons.dart';

class Zutaten extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Zutaten();
}

class _Zutaten extends State<Zutaten> {

  double zutatHeight;
  List<double> numberList = [];
  List<String> mass = ["kg","g","l","ml","TL","EL"];
  List<String> massList = [];
  List<String> nameList = [];
  String selectedMass;
  TextEditingController nameController = new TextEditingController();
  TextEditingController numberController = new TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Column(
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
                  nameController.clear();
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
                          controller: nameController,
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
                    zutatHeight += 56.0;
                    numberList.add(double.parse(numberController.text));
                    numberController.clear();

                    massList.add(selectedMass);
                    selectedMass == null;

                    nameList.add(nameController.text);
                    nameController.clear();
                  });
                },
              ),
            ),
            Divider(

            ),
            Container(
              height: zutatHeight,
              child:ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: nameList.length,
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
                              reduceNumber(index);
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
                    direction: (nameController.text.isEmpty
                        ? DismissDirection.horizontal
                        : DismissDirection.startToEnd
                    ),
                    onDismissed: (direction){
                      if(direction == DismissDirection.startToEnd){
                        setState(() {
                          reduceNumber(index);

                          nameList.removeAt(index);
                          massList.removeAt(index);
                          numberList.removeAt(index);
                        });
                      } else if(direction == DismissDirection.endToStart){
                        if(nameController.text.isNotEmpty){
                          showBottomSnack("Dismissed abortion");
                        } else if(nameController.text.isEmpty){
                          nameController.text = nameList[index];
                          numberController.text = numberList[index].toString();
                          selectedMass = massList[index];

                          nameList.removeAt(index);
                          massList.removeAt(index);
                          numberList.removeAt(index);

                          reduceNumber(index);
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
    );
  }


  void reduceNumber(int index){
    if(numberList[index] > 0.0){
      numberList[index]--;
    } else if(numberList[index] == 0.0){
      setState(() {
        removeItemAt(index);
      });
    }
  }

  void removeItemAt(int index){
    nameList.removeAt(index);
    massList.removeAt(index);
    numberList.removeAt(index);
  }

  void showBottomSnack(String value){
    Scaffold.of(context)
        .showSnackBar(SnackBar(
          content: Text(value),
    ));
  }
}