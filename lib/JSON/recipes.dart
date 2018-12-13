import 'package:json_annotation/json_annotation.dart';
part 'recipes.g.dart';

@JsonSerializable()
class RecipesModel {
  int favorite; //0 = false; 1 = true
  String name, image, description, timestamp, preperation, creation, resting, people, backgroundColor;
  List<ZutatenModel> zutaten;
  List<ZubereitungModel> zubereitung;

  @JsonKey(nullable: false)
  RecipesModel recipeModel;

  RecipesModel(
    this.name, this.image, this.description, this.favorite, this.timestamp, this.preperation, this.creation, this.resting, this.people, this.backgroundColor,
    this.zutaten,
    this.zubereitung
  );

  factory RecipesModel.fromJson(Map<String, dynamic> json) => _$RecipesModelFromJson(json);

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