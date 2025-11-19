import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/shayari_model.dart';

class ShayariService {
  static Future<List<Shayari>> loadShayari(String language) async {
    try {
      final String jsonString = await rootBundle.loadString(
        'assets/json/${language}_shayari.json',
      );
      final List<dynamic> jsonList = json.decode(jsonString);
      
      return jsonList.map((json) => Shayari.fromJson(json, language)).toList();
    } catch (e) {
      print('Error loading $language shayari: $e');
      return [];
    }
  }

  static Future<List<String>> getCategories(String language) async {
    final shayaris = await loadShayari(language);
    final categories = shayaris.map((s) => s.category).toSet().toList();
    categories.sort();
    return categories;
  }

  static Future<List<Shayari>> getShayariByCategory(
      String language, String category) async {
    final shayaris = await loadShayari(language);
    return shayaris.where((s) => s.category == category).toList();
  }
}