import 'package:Time2Eat/NotificationID.dart';
import 'package:Time2Eat/interface/CustomShowDialog.dart';
import 'package:Time2Eat/interface/GoogleColors.dart';
import 'package:Time2Eat/interface/MyDropDownButton.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';


class NotificationDialog extends StatefulWidget{
  final String recipe;
  final int recipeID;
  NotificationDialog(this.recipe, this.recipeID);

  @override
  State<StatefulWidget> createState() {
    return _NotificationDialog();
  }
}

class _NotificationDialog extends State<NotificationDialog>{  
  

  //FlutterNotificationsPlugin
  FlutterLocalNotificationsPlugin flutterLocalNotifications = new FlutterLocalNotificationsPlugin();
  String channelID = "Time2Eat";
  String channelName = "channel name";
  String channelDescription = "It's time to eat something amazing!";

  //Select a date
  DateFormat dateFormat;
  DateFormat dayName;
  List<String> date = new List();
  String selectedDate;
  DateTime selectedDateTime;

  //Select a time
  final List<String> timeName = [
        "Morgens",
        "Nachmittags",
        "Spätnachmittags",
        "Abends",
        "Uhrzeit auswählen..."
      ];

  final List<String> timeNumber = [
        "08:00",
        "13:00",
        "18:00",
        "20:00",
        ""
      ];
  List<String> timeList = new List();
  String selectedTime;
  TimeOfDay notificationTime;
  var pickedTime;
  int timeIndex;

  int notificationID;

  //Select notification intervall
  final List<String> intervalle = [
    "Einmaliger Termin",
    "Täglich",
    "Wöchentlich"
  ];
  final List<String> intervallHint = [
    "Einmaliger Termin",
    "wird täglich wiederholt ",
    "wird wöchentlich wiederholt "
  ]; 
  String selectedIntervall;

  //Days
  final List<String> weekDays = ["Montag", "Dienstag", "Mittwoch", "Donnerstag", "Freitag", "Samstag", "Sonntag"];
  int selectedDay;

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
        (selectedIntervall == intervalle[0]
          ? Padding(
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
            ) 
          : Container()
        ),
        (selectedIntervall == intervallHint[2]
          ? Padding(
              padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
              child: Container(
                child: new MyDropdownButton(
                  hint: Text(weekDays[selectedDay]),
                  items: weekDays.map((String value){
                    return new MyDropdownMenuItem(
                      value: value,
                      child: ListTile(
                        title: new Text(value),
                      ),
                    );
                  }).toList(),
                  onChanged: (String value){                    
                    setState(() {
                      int number = weekDays.indexOf(value);
                      selectedDay = number;
                    });
                  },
                ),
              ),
            ) 
          : Container()
        ),
        Padding(
          padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 5.0),
          child: Container(
            child: new MyDropdownButton(
              hint: Text(selectedTime),
              items: timeName.map((String value){
                int count = timeName.indexOf(value); 
                timeIndex = count;               
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
              color: GoogleMaterialColors().primaryColor().withOpacity(0.15),   
              elevation: 0.0,         
              highlightColor: GoogleMaterialColors().primaryColor().withOpacity(0.15),
              highlightElevation: 2.0,
              onPressed: (){
                createNotification();
              },
              shape: new RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
              splashColor: Colors.transparent,
            )
          ],
        )
      ],
    );
  }

  createNotification() async{
    int id = await setNotficationTime(selectedIntervall);
    Navigator.pop(context, id);
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
    notificationTime = TimeOfDay(
      hour: int.parse(selectedTime.toString().split(":")[0]),
      minute: int.parse(selectedTime.toString().split(":")[1])
    );
    setState(() {});
  }

  setIntervall(String value) async{
    var count = intervalle.indexOf(value);
    selectedIntervall = intervallHint[count];
    setState(() {});
  }

  setNotficationTime(String interval) async{
    String r_value = "";
    if(interval == intervalle[0]){
      r_value = await _oneTimeNotification();
    } else if(interval == intervalle[1]){
      r_value = await _dailyNotification();
    } else if(interval == intervalle[2]){
      r_value = await _weeklyNotification();
    } 

    return r_value;
  }

Future _oneTimeNotification() async {  
  var schedule = DateTime(
    DateTime.now().year,
    selectedDateTime.month,
    selectedDateTime.day,
    int.parse(selectedTime.toString().split(":")[0]),
    int.parse(selectedTime.toString().split(":")[1])
  );
  var android = new AndroidNotificationDetails(channelID, channelName, channelDescription);
  var iOS = new IOSNotificationDetails();

  NotificationDetails platformChannelSpecifics = new NotificationDetails(android, iOS);

  int notificationID = NotificationID().getID_one(schedule, widget.recipeID);

  await flutterLocalNotifications.schedule(
    notificationID,
    widget.recipe,
    channelDescription,
    schedule,
    platformChannelSpecifics
  );

  return notificationID.toString();
}

Future _dailyNotification() async{
  var schedule = new Time(
    int.parse(selectedTime.toString().split(":")[0]),
    int.parse(selectedTime.toString().split(":")[1]),
    0
  );
  var android = new AndroidNotificationDetails(channelID, channelName, channelDescription);
  var iOS = new IOSNotificationDetails();

  NotificationDetails platformChannelSpecifics = new NotificationDetails(android, iOS);

  int notificationID = NotificationID().getID_daily(DateTime.now().day, schedule, widget.recipeID);

  await flutterLocalNotifications.showDailyAtTime(
    notificationID,
    widget.recipe,
    channelDescription,
    schedule,
    platformChannelSpecifics
  );

  return notificationID.toString();
}

Future _weeklyNotification() async{
  var schedule = new Time(
    int.parse(selectedTime.toString().split(":")[0]),
    int.parse(selectedTime.toString().split(":")[1]),
    0
  );
  var android = new AndroidNotificationDetails(channelID, channelName, channelDescription);
  var iOS = new IOSNotificationDetails();

  NotificationDetails platformChannelSpecifics = new NotificationDetails(android, iOS);
  int notificationID = NotificationID().getID_weekly(Day(selectedDay), schedule, widget.recipeID);

  await flutterLocalNotifications.showWeeklyAtDayAndTime(
    notificationID,
    widget.recipe,
    channelDescription,
    Day(selectedDay),
    schedule,
    platformChannelSpecifics
  );

  return notificationID.toString();
}

  Future onSelectNotification(String payload) async {
    showDialog(
      context: context,
      builder: (_) {
        return new AlertDialog(
          title: Text("PayLoad"),
          content: Text("Payload : $payload"),
        );
      },
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
      selectedDateTime = DateTime.now();

      timeIndex = 0;
      selectedTime = timeNumber[timeIndex];
      notificationTime = TimeOfDay(
        hour: int.parse(selectedTime.toString().split(":")[0]),
        minute: int.parse(selectedTime.toString().split(":")[1])
      );

      selectedIntervall = intervallHint[0];

      selectedDay = DateTime.now().day;

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