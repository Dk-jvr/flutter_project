import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/favorites_provider.dart';
import '../beer_data.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final favoriteItems = favoritesProvider.favoriteBeers;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
      ),
      body: favoriteItems.isEmpty
          ? const Center(child: Text('No favorites added yet'))
          : ListView.builder(
              itemCount: favoriteItems.length,
              itemBuilder: (context, index) {
                final beer = favoriteItems[index];
                return ListTile(
                  leading: Image.asset(beer.image),
                  title: Text(beer.name),
                  subtitle: Text('\$${beer.price.toStringAsFixed(2)}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      favoritesProvider.removeFromFavorites(beer);
                    },
                  ),
                );
              },
            ),
    );
  }
}
