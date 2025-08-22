// lib/providers/favorites_provider.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesProvider extends ChangeNotifier {
  List<String> _favoriteBairroNames = [];

  List<String> get favoriteBairroNames => _favoriteBairroNames;

  FavoritesProvider() {
    loadFavorites();
  }

  // Carrega os favoritos salvos no SharedPreferences
  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    _favoriteBairroNames = prefs.getStringList('bairros_favoritos') ?? [];
    notifyListeners();
  }

  bool isFavorite(String bairroName) {
    return _favoriteBairroNames.contains(bairroName);
  }

  // Ação principal para favoritar ou desfavoritar
  Future<void> toggleFavorite(String bairroName) async {
    final prefs = await SharedPreferences.getInstance();
    if (isFavorite(bairroName)) {
      _favoriteBairroNames.remove(bairroName);
    } else {
      _favoriteBairroNames.add(bairroName);
    }
    
    // Salva a lista atualizada no SharedPreferences
    await prefs.setStringList('bairros_favoritos', _favoriteBairroNames);
    
    // Notifica todos os widgets que estão ouvindo para se reconstruírem
    notifyListeners();
  }
}