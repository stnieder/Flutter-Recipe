class TermineDB{
  TermineDB();

  int id, terminIntervall;
  String terminDate, notificationID; //should be a Date

  static final columns = ["id", "terminDate", "notificationID", "terminIntervall"];

  Map<String, dynamic> toMap(){
    Map<String, dynamic> map = {
      "terminDate": terminDate,
      "notificationID": notificationID,
      "terminIntervall": terminIntervall
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
    termine.terminIntervall = map["terminIntervall"];
  }
}

class Termine{

  int id;
  String terminDate, notificationID, terminIntervall;

  Termine(this.id, this.terminDate, this.notificationID, this.terminIntervall);
}