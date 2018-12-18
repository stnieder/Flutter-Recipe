import 'dart:typed_data';

import 'package:json_annotation/json_annotation.dart';
part 'recipes.g.dart';

@JsonSerializable(nullable: false)
class RecipesModel {
  String name, description, timestamp, preperation, creation, resting, people, backgroundColor;
  String image;
  int favorite; //0 = false; 1 = true
  List<ZutatenModel> zutaten;
  List<ZubereitungModel> zubereitung;

  @JsonKey(nullable: false)
  RecipesModel recipeModel;

  RecipesModel(
    this.name, this.image, this.description, this.timestamp, this.preperation, this.creation, this.resting, this.people, this.backgroundColor,
    this.favorite,
    this.zutaten,
    this.zubereitung
  );

  factory RecipesModel.fromJson(Map<String, dynamic> json) {
    return _$RecipesModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$RecipesModelToJson(this);
}

@JsonSerializable()
class ZutatenModel {
  String zutat, number, measure;

  ZutatenModel(this.zutat, this.number, this.measure);

  factory ZutatenModel.fromJson(Map<String, dynamic> json) => _$ZutatenModelFromJson(json);
  Map<String,dynamic> toJson() => _$ZutatenModelToJson(this);
}

@JsonSerializable()
class ZubereitungModel {
  String number, steps;

  ZubereitungModel(this.number, this.steps);

  factory ZubereitungModel.fromJson(Map<String,dynamic> json) => _$ZubereitungModelFromJson(json);
  Map<String,dynamic> toJson() => _$ZubereitungModelToJson(this);
}