// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipes.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecipesModel _$RecipesModelFromJson(Map<String, dynamic> json) {
  return RecipesModel(
      json['name'] as String,
      json['image'] as String,
      json['description'] as String,
      json['timestamp'] as String,
      json['preperation'] as String,
      json['creation'] as String,
      json['resting'] as String,
      json['people'] as String,
      json['backgroundColor'] as String,
      json['favorite'] as int,
      (json['zutaten'] as List)
          .map((e) => ZutatenModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['zubereitung'] as List)
          .map((e) => ZubereitungModel.fromJson(e as Map<String, dynamic>))
          .toList());
}

Map<String, dynamic> _$RecipesModelToJson(RecipesModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'timestamp': instance.timestamp,
      'preperation': instance.preperation,
      'creation': instance.creation,
      'resting': instance.resting,
      'people': instance.people,
      'backgroundColor': instance.backgroundColor,
      'image': instance.image,
      'favorite': instance.favorite,
      'zutaten': instance.zutaten,
      'zubereitung': instance.zubereitung,
      'recipeModel': instance.recipeModel
    };

ZutatenModel _$ZutatenModelFromJson(Map<String, dynamic> json) {
  return ZutatenModel(json['zutat'] as String, json['number'] as String,
      json['measure'] as String);
}

Map<String, dynamic> _$ZutatenModelToJson(ZutatenModel instance) =>
    <String, dynamic>{
      'zutat': instance.zutat,
      'number': instance.number,
      'measure': instance.measure
    };

ZubereitungModel _$ZubereitungModelFromJson(Map<String, dynamic> json) {
  return ZubereitungModel(json['number'] as String, json['steps'] as String);
}

Map<String, dynamic> _$ZubereitungModelToJson(ZubereitungModel instance) =>
    <String, dynamic>{'number': instance.number, 'steps': instance.steps};
