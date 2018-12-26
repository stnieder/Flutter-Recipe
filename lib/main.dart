import 'dart:async';

import 'package:Time2Eat/main_pages/Splashscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sentry/sentry.dart';
import 'Error_Reporting/SentryDSN.dart';

import 'recipe/new_recipe.dart';


var flutterLocalNotifcations;
final SentryClient _sentry = new SentryClient(dsn: returnSentryDSN());
GlobalKey<NavigatorState> _mainKey = new GlobalKey<NavigatorState>();


Future<Null> main() async{
  FlutterError.onError = (FlutterErrorDetails details) async{
    if(isInDebugMode){
      FlutterError.dumpErrorToConsole(details);
    } else {
      Zone.current.handleUncaughtError(details.exception, details.stack);
    }
  };
  runZoned<Future<void>>(()async{
    flutterLocalNotifcations = new FlutterLocalNotificationsPlugin();
    runApp(new Recipe());
  }, onError: (error, stackTrace) async{
    await _reportError(error, stackTrace);
  });
}

bool get isInDebugMode {
  bool inDebugMode = false;
  assert(inDebugMode = true);
  return inDebugMode;
}



Future<Null> _reportError(dynamic error, dynamic stackTrace) async{
  print('Caught error: $error');

  if(isInDebugMode) {
    print(stackTrace);
    return;
  } else {
    print("Reporting to Sentry.io...");

    final SentryResponse response = await _sentry.captureException(
      exception: error,
      stackTrace: stackTrace
    );

    if(response.isSuccessful) {
      print("Success! Event ID: ${response.eventId}");
    } else {
      GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();
      Text snackbarText = new Text("Den Fehler bitte weiterleiten");
      SnackBar snackBar = new SnackBar(
        key: _key,
        content: snackbarText,
        action: SnackBarAction(
          label: "Kopieren",
          onPressed: () {
            Clipboard.setData(ClipboardData(text: error.toString()));
            snackbarText = Text("Kopiert");
          },
        ),
      );
      _key.currentState.showSnackBar(snackBar);
    }
  }
}

class Recipe extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    setPrefs();
    return new MaterialApp( 
      key: _mainKey,
      builder: (context, child) => MediaQuery(data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true), child: child),  
      title: "Rezeptbuch",
      theme: new ThemeData(        
        backgroundColor: Colors.white,
        canvasColor: Colors.white,
        primarySwatch: Colors.blue,
        iconTheme: IconThemeData(
          color: Colors.black54          
        ),
        textTheme: TextTheme(
          body1: TextStyle(
            color: Colors.black,
            fontFamily: "Noto-Sans"
          )
        )
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => Splashscreen(),
        '/add_recipe': (context) => NewRecipe()
      },
    );
  }

  setPrefs() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String list = prefs.getString("currentList");
    String start = prefs.getString("firstStart");
    if(list == null || list == "") {
      prefs.setString("currentList", "Einkaufsliste");
    }
    if(start == null || start == ""){
      prefs.setString("firstStart", "true");
    } else if(start == "true") prefs.setString("firstStart", "false");
  }
}
