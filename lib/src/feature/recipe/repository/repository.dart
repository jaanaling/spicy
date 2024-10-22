import 'package:application/src/feature/recipe/model/recipe.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class RecipeRepository {
  final String _recipesKey = 'recipes';
  List<RecipeModel> _recipes = [];

  Future<List<RecipeModel>> loadRecipes() async {
    final prefs = await SharedPreferences.getInstance();
    final List<RecipeModel> recipes = await _getRecipesFromPrefs(prefs);

    if (recipes.isEmpty) {
      _recipes = await _getDefaultRecipes();
      await _saveRecipesToPrefs(prefs, _recipes);
      return _recipes;
    }

    _recipes = recipes;
    return _recipes;
  }

  Future<List<RecipeModel>> _getRecipesFromPrefs(
      SharedPreferences prefs) async {
    final String? recipesJson = prefs.getString(_recipesKey);
    if (recipesJson != null) {
      final List<dynamic> decodedJson =
          jsonDecode(recipesJson) as List<dynamic>;
      return decodedJson
          .map((json) => RecipeModel.fromMap(json as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  Future<void> _saveRecipesToPrefs(
      SharedPreferences prefs, List<RecipeModel> recipes) async {
    await prefs.setString(
        _recipesKey, jsonEncode(recipes.map((e) => e.toMap()).toList()));
  }

  Future<void> addRecipe(RecipeModel recipe) async {
    _recipes.add(recipe);
    final prefs = await SharedPreferences.getInstance();
    await _saveRecipesToPrefs(prefs, _recipes);
  }

  Future<void> removeRecipe(String name) async {
    _recipes.removeWhere((recipe) => recipe.name == name);
    final prefs = await SharedPreferences.getInstance();
    await _saveRecipesToPrefs(prefs, _recipes);
  }

  Future<void> toggleFavorite(String name) async {
    final recipe = _recipes.firstWhere((recipe) => recipe.name == name);
    if (recipe.isFavorite != null) {
      recipe.isFavorite = !recipe.isFavorite!;
    } else {
      recipe.isFavorite = true;
    }
    final prefs = await SharedPreferences.getInstance();
    await _saveRecipesToPrefs(prefs, _recipes);
  }

  Future<List<RecipeModel>> _getDefaultRecipes() async {
    final String response =
        await rootBundle.loadString('assets/json/recipe.json');
    final List<dynamic> data = json.decode(response) as List<dynamic>;
    return data
        .map((json) => RecipeModel.fromMap(json as Map<String, dynamic>))
        .toList();
  }

  List<Ingredient> getIngredientsByType(String type) {
    Set<String> uniqueIngredientNames = {};

    for (var recipe in _recipes) {
      uniqueIngredientNames.addAll(recipe.ingredients
          .where((ingredient) => ingredient.type.toLowerCase() == type.toLowerCase())
          .map((ingredient) => ingredient.name));
    }

    return uniqueIngredientNames.map((name) => Ingredient(name: name, type: type, quantityType: '', quantity: 0)).toList();
  }
}
