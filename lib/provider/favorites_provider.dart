import 'dart:convert';
import 'package:departures/widgets/station_display.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesProvider with ChangeNotifier {
  List<StationDisplay> _favorites = [];
  List<StationDisplay> get favorites => _favorites;

  FavoritesProvider() {
    _loadFavorites();
  }

  void toggleFavorite(StationDisplay station) {
    if (_favorites.any((fav) => fav.stationId == station.stationId)) {
      removeFavorite(station);
    } else {
      addFavorite(station);
    }
  }

  // ! When calling, ensure no duplicate favorites are added
  void addFavorite(StationDisplay station) {
    _favorites.add(station);
    _saveFavorites();
    notifyListeners();
  }

  void removeFavorite(StationDisplay station) {
    _favorites.removeWhere((fav) => fav.stationId == station.stationId);
    _saveFavorites();
    notifyListeners();
  }

  void moveFavorite(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final StationDisplay station = _favorites.removeAt(oldIndex);
    _favorites.insert(newIndex, station);
    _saveFavorites();
    notifyListeners();
  }

  void _loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? favoritesJson = prefs.getStringList('favorites');
    if (favoritesJson != null) {
      _favorites = favoritesJson
          .map((json) => StationDisplay.fromJson(jsonDecode(json)))
          .toList();
    }
    notifyListeners();
  }

  void _saveFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favoritesJson = _favorites
        .map((station) => jsonEncode(station.toJson()))
        .toList();
    prefs.setStringList('favorites', favoritesJson);
  }
}
