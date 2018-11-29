import 'dart:typed_data';

import 'package:Time2Eat/interface/CustomShowDialog.dart';
import 'package:Time2Eat/interface/GoogleColors.dart';
import 'package:Time2Eat/interface/MyDropDownButton.dart';
import 'package:Time2Eat/recipe/recipebook.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class NotificationDialog extends StatefulWidget{
  final String recipe;
  NotificationDialog(this.recipe);

  @override
  State<StatefulWidget> createState() {
    return _NotificationDialog();
  }
}

class _NotificationDialog extends State<NotificationDialog>{  
  

  //FlutterNotificationsPlugin
  FlutterLocalNotificationsPlugin flutterLocalNotifications = new FlutterLocalNotificationsPlugin();
  String channelID = "Time2Eat";
  String channelName;
  String channelDescription = "It's time two eat something amazing!";

  //Select a date
  DateFormat dateFormat;
  DateFormat dayName;
  List<String> date = new List();
  String selectedDate;
  DateTime selectedDateTime;

  //Select a time
  List<String> timeName = new List();
  List<String> timeNumber = new List();
  List<String> timeList = new List();
  String selectedTime;

  //Select notification intervall
  List<String> intervalle = new List();
  List<String> intervallHint = new List();
  String selectedIntervall;

  _getContent(){ 
    return CustomSimpleDialog(  
      contentPadding: EdgeInsets.only(bottom: 5.0, right: 5.0, left: 5.0, top: 15.0),    
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 10.0),
          child: Text(
          "Erinnerung hinzufügen",
          style: TextStyle(
              fontFamily: "Google-Sans",
              fontSize: 15.0,
              fontWeight: FontWeight.bold
          ),
        ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
          child: Container(
            child: new MyDropdownButton(
              hint: Text(selectedDate),
              items: date.map((String value){
                return new MyDropdownMenuItem(
                  value: value,
                  child: ListTile(
                    title: new Text(value),
                  ),
                );
              }).toList(),
              onChanged: convertDate,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 5.0),
          child: Container(
            child: new MyDropdownButton(
              hint: Text(selectedTime),
              items: timeName.map((String value){
                int count = timeName.indexOf(value);                
                return new MyDropdownMenuItem(                  
                  value: timeNumber[count],
                  child: ListTile(
                    title: Text(value),
                    trailing: Text(
                      timeNumber[count],
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 14.0
                      ),
                    ),
                  ),
                );
              }).toList(),
              onChanged: convertTime,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 5.0),
          child: Container(
            child: new MyDropdownButton(
              hint: Text(selectedIntervall),
              items: intervalle.map((String value){
                return new MyDropdownMenuItem(                  
                  value: value,
                  child: ListTile(
                    title: Text(value)
                  ),
                );
              }).toList(),
              onChanged: setIntervall,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: FlatButton(
                shape: new RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                child: Text(
                  "Abbrechen",
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: "Google-Sans"
                  ),
                ),
                highlightColor: GoogleMaterialColors().getLightColor(7).withOpacity(0.1),
                onPressed: (){
                  Navigator.pop(context);
                },
                splashColor: Colors.transparent,
              ),
            ),
            RaisedButton(
              animationDuration: Duration(milliseconds: 300),              
              child: Text(
                "Speichern",
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: "Google-Sans"
                ),
              ), 
              color: GoogleMaterialColors().getLightColor(7).withOpacity(0.85),   
              elevation: 0.0,         
              highlightColor: GoogleMaterialColors().getLightColor(7).withAlpha(200),
              highlightElevation: 2.0,
              onPressed: (){
                setNotficationTime(selectedIntervall);
                Navigator.pop(context);
              },
              shape: new RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
              splashColor: Colors.transparent,
            )
          ],
        )
      ],
    );
  }

  convertDate(String value) async{
    if(value == date[0]){
       selectedDate = dateFormat.format(DateTime.now());
       selectedDateTime = DateTime.now();
    } else if(value == date[1]){
      var newFormat = dateFormat.format(DateTime.now().add(Duration(days: 1)));
      selectedDate = newFormat;
      selectedDateTime = DateTime.now().add(Duration(days: 1));
    } else if(value == date[2]){
      var newFormat = dateFormat.format(DateTime.now().add(Duration(days: 7)));
      selectedDate = newFormat;
      selectedDateTime = DateTime.now().add(Duration(days: 7));
    } else if(value == date[3]){
      var selectDialog = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(DateTime.now().year-1),
        lastDate: DateTime(DateTime.now().year+2)
      );
      if(selectDialog != null) {
        selectedDateTime = selectDialog;
        selectedDate = (dateFormat.format(selectDialog));
      }
    }
    setState(() {});
  }

  convertTime(String value) async{
    var pickedTime;
    if(value != ""){
      selectedTime = value;
    } else {
      pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now()
      );
      if(pickedTime != null){
        selectedTime = pickedTime.toString().split("(")[1].split(")")[0].toString();
      }
    }    
    setState(() {});
  }

  setIntervall(String value) async{
    var count = intervalle.indexOf(value);
    selectedIntervall = intervallHint[count];
    setState(() {});
  }

  setNotficationTime(String interval){
    if(interval == intervalle[0]){
      scheduleNot();
    } else if(interval == intervalle[1]){
      showDailyNot();
    } else if(interval == intervalle[2]){
      showWeeklyNot();
    } else if(interval == intervalle[3]){
      print("Benutzerdefiniert ist noch in Bearbeitung!");
    }
  }


  Future showOnGoingNot() async{
    var android = new AndroidNotificationDetails(
      channelID, 
      channelName, 
      channelDescription,
      importance: Importance.Default,
      ongoing: true,
      autoCancel: false
    );
    var iOS = new IOSNotificationDetails();
    var platformSpecs = new NotificationDetails(android, iOS);

    await flutterLocalNotifications.show(
      0, 
      channelName, 
      channelDescription, 
      platformSpecs
    );
  }  


  Future scheduleNot() async{
    //Get Specific Date
    var date = selectedDate;

    //Get Specific Time
    var hour = int.parse(selectedTime.split(":")[0]);
    var minute = int.parse(selectedTime.split(":")[1]);
    var time = Time(hour, minute, 0);
    print("Time: "+time.toString());

    var vibrationPattern = new Int64List(4);
    vibrationPattern[0] = 0;
    vibrationPattern[1] = 1000;
    vibrationPattern[2] = 5000;
    vibrationPattern[3] = 2000;


    var android = new AndroidNotificationDetails(
      channelID, 
      channelName, 
      channelDescription,
      sound: 'slow_spring_board',
      vibrationPattern: vibrationPattern,
      color: GoogleMaterialColors().primaryColor()
    );
    var iOS = new IOSNotificationDetails(sound:  'slow_spring_board.aiff');
    var platformSpecs = new NotificationDetails(android, iOS);

    /*
    await flutterLocalNotifications.schedule(
      0,
      channelName,
      channelDescription,
      selectedDateTime,
      platformSpecs
    );
    */
  }


  Future showDailyNot() async{
    //Get Specific Time
    var hour = int.parse(selectedTime.split(":")[0]);
    var minute = int.parse(selectedTime.split(":")[1]);
    var time = Time(hour, minute, 0);

    var android = new AndroidNotificationDetails(channelID, channelName, channelDescription);
    var iOS = new IOSNotificationDetails();
    var platformSpecs = new NotificationDetails(android, iOS);

    await flutterLocalNotifications.showDailyAtTime(
      0, 
      channelName, 
      channelDescription, 
      time, 
      platformSpecs
    );
  }

  Future showWeeklyNot() async{
    //Get Specific Time
    var hour = int.parse(selectedTime.split(":")[0]);
    var minute = int.parse(selectedTime.split(":")[1]);
    var time = Time(hour, minute, 0);

    //Get Day of today
    List<Day> days = [Day.Monday, Day.Tuesday, Day.Thursday, Day.Wednesday, Day.Friday, Day.Saturday, Day.Sunday];
    var specDay = DateTime.now().day;

    var android = new AndroidNotificationDetails(channelID, channelName, channelDescription);
    var ios = new IOSNotificationDetails();
    var platformChannelSpecs = new NotificationDetails(android, ios);

    await flutterLocalNotifications.showWeeklyAtDayAndTime(
      0,
      channelName,
      channelDescription,
      days[specDay],
      time,
      platformChannelSpecs
    );
  }

  Future deleteAllNot() async{
    await flutterLocalNotifications.cancelAll();
  }

  Future onSelectNotification(String payload) async{
    if(payload != null){
      debugPrint('Notification payload: '+payload);
    }

    await Navigator.push(
      context, 
      MaterialPageRoute(builder: (context) => Recipebook())
    );
  }

  @override
    void initState() {
      super.initState(); 
      initializeDateFormatting('de_DE', null);
      dateFormat = new DateFormat.MMMMd("de_DE");           
      dayName = new DateFormat('EEEEE', "de_DE");
      date = [
        "Heute",
        "Morgen",
        "Nächsten " + dayName.format(DateTime.now()),
        "Datum auswählen..."
      ];  
      selectedDate = dateFormat.format(DateTime.now());

      timeName = [
        "Morgens",
        "Nachmittags",
        "Spätnachmittags",
        "Abends",
        "Uhrzeit auswählen..."
      ];

      timeNumber = [
        "08:00",
        "13:00",
        "18:00",
        "20:00",
        ""
      ];
      selectedTime = timeNumber[0];

      intervalle = [
        "Einmaliger Termin",
        "Täglich",
        "Wöchentlich",
        "Benutzerdefiniert..."
      ];

      intervallHint = [
        "Einmaliger Termin",
        "wird täglich wiederholt ",
        "wird wöchentlich wiederholt ",
        "in Bearbeitung..."
      ];
      selectedIntervall = intervallHint[0];

      var initializeAndroid = new AndroidInitializationSettings('time2eat');
      var initializeIOS = new IOSInitializationSettings();
      var initializeSettings = new InitializationSettings(initializeAndroid, initializeIOS);
      flutterLocalNotifications.initialize(
        initializeSettings,
        onSelectNotification: onSelectNotification
      );

      channelName = widget.recipe;
    }


  @override
  Widget build(BuildContext context) {
    return _getContent();
  }
}