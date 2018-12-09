class ListTitleDB{
  ListTitleDB();

  int id;
  String titleName;

  static final columns = ["id", "titleName"];

  Map<String,dynamic> toMap(){
    Map<String,dynamic> map = {
      "titleName": titleName
    };

    if(id != null) map["id"] = id;

    return map;
  }

  static fromMap(Map map){
    ListTitleDB titles = new ListTitleDB();

    titles.id = map["id"];
    titles.titleName = map["titleName"];

    return titles;
  }
}

class ListTitle{
  int id;
  String titleName;

  ListTitle(this.id, this.titleName);
}