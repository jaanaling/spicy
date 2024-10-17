// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class Ingredient extends Equatable {
  final String name;
  final String type;

  Ingredient({
    required this.name,
    required this.type,
  });

  @override
  List<Object?> get props => [name, type];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'type': type,
    };
  }

  factory Ingredient.fromMap(Map<String, dynamic> map) {
    return Ingredient(
      name: map['name'] as String,
      type: map['type'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Ingredient.fromJson(String source) =>
      Ingredient.fromMap(json.decode(source) as Map<String, dynamic>);
}

class RecipeModel extends Equatable {
  final String name;
  final String imagePath;
  final int spicinessLevel;
  final int servings;
  final String difficulty;
  final String cuisine;
  final String time; // добавлено поле time
  final List<Ingredient> ingredients; // изменено на список Ingredient
  final List<String> steps;
  final double calories;
  final double proteins;
  final double fats;
  final double carbs;
  bool? isFavorite;

  RecipeModel({
    required this.name,
    required this.imagePath,
    required this.spicinessLevel,
    required this.servings,
    required this.difficulty,
    required this.cuisine,
    required this.time, // добавлено поле time
    required this.ingredients,
    required this.steps,
    required this.calories,
    required this.proteins,
    required this.fats,
    required this.carbs,
    this.isFavorite = false,
  });

  @override
  List<Object?> get props => [
        name,
        imagePath,
        spicinessLevel,
        servings,
        difficulty,
        cuisine,
        time, // добавлено поле time
        ingredients,
        steps,
        calories,
        proteins,
        fats,
        carbs,
        isFavorite,
      ];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'imagePath': imagePath,
      'spicinessLevel': spicinessLevel,
      'servings': servings,
      'difficulty': difficulty,
      'cuisine': cuisine,
      'time': time, // добавлено поле time
      'ingredients': ingredients.map((x) => x.toMap()).toList(),
      'steps': steps,
      'calories': calories,
      'proteins': proteins,
      'fats': fats,
      'carbs': carbs,
      'isFavorite': isFavorite,
    };
  }

  factory RecipeModel.fromMap(Map<String, dynamic> map) {
    return RecipeModel(
      name: map['name'] as String,
      imagePath: map['imagePath'] as String,
      spicinessLevel: map['spicinessLevel'] as int,
      servings: map['servings'] as int,
      difficulty: map['difficulty'] as String,
      cuisine: map['cuisine'] as String,
      time: map['time'] as String, // добавлено поле time
      ingredients: List<Ingredient>.from(
        (map['ingredients'] as List<dynamic>)
            .map((x) => Ingredient.fromMap(x as Map<String, dynamic>)),
      ),
      steps: List<String>.from(map['steps'] as List<String>),
      calories: map['calories'] as double,
      proteins: map['proteins'] as double,
      fats: map['fats'] as double,
      carbs: map['carbs'] as double,
      isFavorite: map['isFavorite'] as bool?,
    );
  }

  String toJson() => json.encode(toMap());

  factory RecipeModel.fromJson(String source) =>
      RecipeModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
