import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationID{

  NotificationID();

  getID_one(DateTime scheduled, int recipeID){
    String notification_id = 
      scheduled.year.toString() + scheduled.month.toString() + scheduled.day.toString() +
      scheduled.hour.toString() + scheduled.minute.toString() + scheduled.second.toString();

    notification_id += recipeID.toString();

    return int.parse(notification_id);
  }

  getID_daily(int day, Time schedule, int recipeID){
    String notification_id = 
      day.toString() + 
      schedule.hour.toString() + schedule.minute.toString() + schedule.second.toString();

    notification_id += recipeID.toString();

    return int.parse(notification_id);
  }

  getID_weekly(Day selected, Time schedule, int recipeID){
    String notification_id = 
      selected.value.toString() + 
      schedule.hour.toString() + schedule.minute.toString() + schedule.second.toString();

    notification_id += recipeID.toString();

    return int.parse(notification_id);
  }
}