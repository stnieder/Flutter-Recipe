class HistoryDB{
  HistoryDB();

  int id;
  String term, timestamp;

  static final columns = ["id", "term", "timestamp"];

  Map<String, dynamic> toMap(){
    Map<String, dynamic> map={
      "term": term,
      "timestamp": timestamp
    };

    if(id != null){
      map["id"] = id;
    }

    return map;
  }


  static fromMap(Map map){
    HistoryDB history = new HistoryDB();

    history.id = map["id"];
    history.term = map["term"];
    history.timestamp = map["timestamp"];

    return history;
  }
}


class History {
  int id;
  String term, timestamp;


  History(this.id, this.term, this.timestamp);
}