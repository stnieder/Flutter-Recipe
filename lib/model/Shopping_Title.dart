import 'package:flutter/foundation.dart';


class ShoppingTitlesDB{
  ShoppingTitlesDB();

  int id, idTitles, idShopping;

  static final columns = ["id", "idTitles", "idShopping"];

  Map<String, dynamic> toMap(){
    Map<String, dynamic> map = {
      "idTitles": idTitles,
      "idShopping": idShopping
    };

    if(id != null){
      map["id"] = id;
    }

    return map;
  }

  static fromMap(Map map){
    ShoppingTitlesDB shopTitle = new ShoppingTitlesDB();

    shopTitle.id = map["id"];
    shopTitle.idTitles = map["idTitles"];
    shopTitle.idShopping = map["idShopping"];
  }
}