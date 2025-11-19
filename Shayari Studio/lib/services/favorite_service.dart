import 'package:shared_preferences/shared_preferences.dart';
import '../models/shayari_model.dart';

class FavoriteService {
  static const String _favoritesKey = 'favorite_shayaris';

  static Future<void> toggleFavorite(Shayari shayari) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = await getFavorites();
    
    if (shayari.isFavorite) {
      favorites.removeWhere((s) => s.id == shayari.id && s.language == shayari.language);
    } else {
      favorites.add(shayari);
    }
    
    shayari.isFavorite = !shayari.isFavorite;
    
    final List<String> favoritesJson = 
        favorites.map((s) => jsonEncode(s.toJson())).toList();
    
    await prefs.setStringList(_favoritesKey, favoritesJson);
  }

  static Future<List<Shayari>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? favoritesJson = prefs.getStringList(_favoritesKey);
    
    if (favoritesJson == null) return [];
    
    return favoritesJson.map((jsonString) {
      final Map<String, dynamic> json = jsonDecode(jsonString);
      return Shayari.fromJson(json, json['language']);
    }).toList();
  }

  static Future<bool> isFavorite(Shayari shayari) async {
    final favorites = await getFavorites();
    return favorites.any((s) => s.id == shayari.id && s.language == shayari.language);
  }
}