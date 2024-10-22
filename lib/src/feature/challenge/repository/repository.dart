import 'dart:convert';
import 'package:application/src/feature/challenge/model/challenge.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share_plus/share_plus.dart';

class ChallengeRepository {
  List<ChallengeRecipe> _challenges = [];

  Future<List<ChallengeRecipe>> loadChallenges() async {
    if (_challenges.isEmpty) {
      _challenges = await _getDefaultChallenges();
    }
    return _challenges;
  }

  Future<List<ChallengeRecipe>> _getDefaultChallenges() async {
    final String response =
        await rootBundle.loadString('assets/json/challenge.json');
    final List<dynamic> data = json.decode(response) as List<dynamic>;
    return data
        .map((json) => ChallengeRecipe.fromMap(json as Map<String, dynamic>))
        .toList();
  }

  // Сохранение списка челленджей в SharedPreferences
  Future<void> saveChallenges(List<ChallengeRecipe> challenges) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String encodedData = jsonEncode(
      challenges.map((challenge) => challenge.toMap()).toList(),
    );
    await prefs.setString('challenges', encodedData);
  }

  // Загрузка списка челленджей из SharedPreferences
  Future<List<ChallengeRecipe>> loadChallengesFromPrefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? challengesString = prefs.getString('challenges');
    
    if (challengesString != null) {
      final List<dynamic> decodedData = jsonDecode(challengesString) as List<dynamic>;
      return decodedData
          .map((json) => ChallengeRecipe.fromMap(json as Map<String, dynamic>))
          .toList();
    }

    return await loadChallenges(); // Загружает дефолтные челленджи, если сохраненных нет
  }
  Future<void> toggleFavorite(ChallengeRecipe recipe) async {
    final recipes = await loadChallenges();
    final updatedRecipes = recipes.map((r) {
      if (r.name == recipe.name) {
        return r.copyWith(isFavorite: !r.isFavorite);
      }
      return r;
    }).toList();
    await saveChallenges(updatedRecipes);
  }

  Future<void> shareChallenge(String name) async {
      await Share.share('''
I just had the craziest spicy dish called $name and it was on fire! 🔥 I dare you to try it! Can you handle the heat?\n\n
Let’s see who can finish it without reaching for water. Are you up for the challenge? 💪\n\n
Tag me when you take your first bite! 😆''', subject: 'Check out this challenge!');
  }
}
