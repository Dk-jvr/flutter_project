import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../beer_data.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'beer_detail_screen.dart';
import 'cart_screen.dart';
import '../providers/favorites_provider.dart';
import 'favorites_screen.dart';
import '../styles/app_styles.dart';  // Импортируем AppStyles

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Beer> beers = [];
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchBeers();
  }

  Future<void> fetchBeers() async {
    final response = await http.get(
      Uri.parse('https://raw.githubusercontent.com/Dk-jvr/pivo/main/beers.json'),
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body);
      setState(() {
        beers = Beer.fromJsonList(jsonList);
      });
    } else {
      throw Exception('Failed to load beers');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Beer Shop'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CartScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: _selectedIndex == 0
          ? beers.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: beers.length,
                  itemBuilder: (context, index) {
                    final beer = beers[index];
                    return ListTile(
                      leading: Image.asset(beer.image),
                      title: Text(
                        beer.name,
                        style: AppStyles.getTitleStyle(context),  // Используем стиль из AppStyles
                      ),
                      subtitle: Text(
                        '\$${beer.price.toStringAsFixed(2)}',
                        style: AppStyles.bodyTextStyle(context),  // Используем стиль из AppStyles
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BeerDetailScreen(beer: beer),
                          ),
                        );
                      },
                    );
                  },
                )
          : const FavoritesScreen(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
        ],
      ),
    );
  }
}
