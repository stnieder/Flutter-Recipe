class ShoppingDB{
  ShoppingDB();

  int id, checked;
  String item, measure, number, timestamp;

  static final columns = ["id", "item", "measure", "number", "checked", "timestamp"];

  Map<String, dynamic> toMap(){
    Map<String, dynamic> map = {
      "item": item,
      "measure": measure,
      "number": number,
      "checked": checked,
      "timestamp": timestamp
    };

    if(id != null){
      map["id"] = id;
    }

    return map;
  }

  static fromMap(Map map){
    ShoppingDB shopping = new ShoppingDB();

    shopping.id = map["id"];
    shopping.item = map["item"];
    shopping.number = map["number"];
    shopping.measure = map["measure"];
    shopping.checked = map["checked"];
    shopping.timestamp = map["timestamp"];
  }
}

class Shopping{

  int id, checked;
  String item, measure, number, timestamp;

  Shopping(this.id, this.item, this.number, this.measure, this.checked, this.timestamp);
}