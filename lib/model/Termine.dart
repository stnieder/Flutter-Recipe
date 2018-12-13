class TermineDB{
  TermineDB();

  int id;
  String terminDate, notificationID; //should be a Date

  static final columns = ["id", "terminDate", "notificationID"];

  Map<String, dynamic> toMap(){
    Map<String, dynamic> map = {
      "terminDate": terminDate,
      "notificationID": notificationID
    };

    if(id != null){
      map["id"] = id;
    }

    return map;
  }

  static fromMap(Map map){
    TermineDB termine = new TermineDB();

    termine.id = map["id"];
    termine.terminDate = map["terminDate"];
    termine.notificationID = map["notificationID"];
  }
}

class Termine{

  int id;
  String terminDate, notificationID;

  Termine(this.id, this.terminDate, this.notificationID);
}