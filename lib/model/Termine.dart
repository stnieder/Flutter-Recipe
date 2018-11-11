class TermineDB{
  TermineDB();

  int id;
  String termin; //should be a Date

  static final columns = ["id", "termin"];

  Map<String, dynamic> toMap(){
    Map<String, dynamic> map = {
      "termin": termin
    };

    if(id != null){
      map["id"] = id;
    }

    return map;
  }

  static fromMap(Map map){
    TermineDB termine = new TermineDB();

    termine.id = map["id"];
    termine.termin = map["termin"];
  }
}

class Termine{

  int id;
  String termin;

  Termine(this.id, this.termin);
}