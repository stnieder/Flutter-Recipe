/*

  Die verschiedenen Intervalltypen: onetime, daily, weekly

*/


class IntervallDB{
  IntervallDB();

  int id;
  String intervallName;

  static final columns = ["id", "intervallName"];

  Map<String, dynamic> toMap(){
    Map<String, dynamic> map = {
      "intervallName": intervallName
    };

    if(id != null){
      map["id"] = id;
    }

    return map;
  }

  static fromMap(Map map){
    IntervallDB intervall = new IntervallDB();

    intervall.id = map["id"];
    intervall.intervallName = map["intervallName"];
  }
}

class Intervall{

  int id;
  String intervallName;

  Intervall(this.id, this.intervallName);
}