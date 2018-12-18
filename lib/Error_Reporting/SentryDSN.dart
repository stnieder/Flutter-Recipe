

import 'package:sentry/sentry.dart';

returnSentryDSN(){
  String sentry = "https://e0c53c6b16ee48988496ab29cd9b5c30@sentry.io/1356228";
  return sentry;
}

bool get isInDebugMode {
  bool inDebugMode = false;

  assert(inDebugMode = true);

  return inDebugMode;
}