class StepsDB{
  StepsDB();

  int id;
  int number;
  String description;

  static final columns = ["id", "number", "description"];

  Map<String, dynamic> toMap(){
    Map<String, dynamic> map = {
      "number": number,
      "description": description
    };

    if(id != null){
      map["id"] = id;
    }

    return map;
  }

  static fromMap(Map map){
    StepsDB stepsDB = new StepsDB();

    stepsDB.id = map["id"];
    stepsDB.number = map["number"];
    stepsDB.description = map["description"];
  }
}

class Steps{
  int id, number;
  String description;

  Steps(this.id, this.number, this.description);
}