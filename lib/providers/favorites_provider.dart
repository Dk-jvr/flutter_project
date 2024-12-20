import 'package:flutter/material.dart';
import '../beer_data.dart';

class FavoritesProvider with ChangeNotifier {
  final List<Beer> _favoriteBeers = [];

  List<Beer> get favoriteBeers => _favoriteBeers;

  void addToFavorites(Beer beer) {
    if (!_favoriteBeers.contains(beer)) {
      _favoriteBeers.add(beer);
      notifyListeners();
    }
  }

  void removeFromFavorites(Beer beer) {
    _favoriteBeers.remove(beer);
    notifyListeners();
  }
}
