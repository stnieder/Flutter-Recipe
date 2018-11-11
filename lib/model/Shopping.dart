class ShoppingDB{
  ShoppingDB();

  int id, checked;
  String item, measure, number;

  static final columns = ["id", "item", "measure", "number", "checked"];

  Map<String, dynamic> toMap(){
    Map<String, dynamic> map = {
      "item": item,
      "measure": measure,
      "number": number,
      "checked": checked
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
  }
}

class Shopping{

  int id, checked;
  String item, measure, number;

  Shopping(this.id, this.item, this.number, this.measure, this.checked);
}