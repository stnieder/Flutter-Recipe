import 'package:flutter_local_notifications/flutter_local_notifications.dart';

List<String> notificationIntervalle = [
  "onetime",
  "daily",
  "weekly"
];

class NotificationID{

  NotificationID();

  int getID_one(DateTime scheduled, int recipeID){
    String notification_id = 
      scheduled.month.toString() + scheduled.day.toString() +
      scheduled.hour.toString() + scheduled.minute.toString() +
      recipeID.toString();

    print("NotificationID: $notification_id");

    return int.parse(notification_id);
  }

  int getID_daily(int day, Time schedule, int recipeID){
    String notification_id = 
      DateTime.now().month.toString() + day.toString() + 
      schedule.hour.toString() + schedule.minute.toString() + 
      recipeID.toString();

    return int.parse(notification_id);
  }

  int getID_weekly(Day selected, Time schedule, int recipeID){
    String notification_id = 
      DateTime.now().month.toString() + selected.value.toString() + 
      schedule.hour.toString() + schedule.minute.toString() +
      recipeID.toString();

    return int.parse(notification_id);
  }
}