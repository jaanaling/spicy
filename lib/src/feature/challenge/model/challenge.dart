// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ChallengeRecipe {
  final String name;
  final int spiciness; // Уровень остроты (1-5)
  final String cuisine; // Страна кухни
  final String imageUrl;
  final bool isFavorite;

  ChallengeRecipe({
    required this.name,
    required this.spiciness,
    required this.cuisine,
    required this.imageUrl,
    required this.isFavorite,
  });

  ChallengeRecipe copyWith({
    String? name,
    int? spiciness,
    String? cuisine,
    String? imageUrl,
    bool? isFavorite,
  }) {
    return ChallengeRecipe(
      name: name ?? this.name,
      spiciness: spiciness ?? this.spiciness,
      cuisine: cuisine ?? this.cuisine,
      imageUrl: imageUrl ?? this.imageUrl,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'spiciness': spiciness,
      'cuisine': cuisine,
      'imageUrl': imageUrl,
      'isFavorite': isFavorite,
    };
  }

  factory ChallengeRecipe.fromMap(Map<String, dynamic> map) {
    return ChallengeRecipe(
      name: map['name'] as String,
      spiciness: map['spiciness'] as int,
      cuisine: map['cuisine'] as String,
      imageUrl: map['imageUrl'] as String,
      isFavorite: map['isFavorite'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory ChallengeRecipe.fromJson(String source) =>
      ChallengeRecipe.fromMap(json.decode(source) as Map<String, dynamic>);
}
