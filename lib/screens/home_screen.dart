import 'package:flutter/material.dart';
import '../beer_data.dart'; // Импортируем модель Beer
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'beer_detail_screen.dart'; // Импортируем экран детальной информации о пиве
import 'cart_screen.dart'; // Импортируем CartScreen

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Список пива
  List<Beer> beers = [];

  @override
  void initState() {
    super.initState();
    fetchBeers();
  }

  // Функция для получения пива из API или локальных данных
  Future<void> fetchBeers() async {
    final response = await http.get(Uri.parse('https://raw.githubusercontent.com/Dk-jvr/pivo/main/beers.json'));

    if (response.statusCode == 200) {
      // Если запрос успешен, парсим JSON и загружаем пиво
      List<dynamic> jsonList = json.decode(response.body);
      setState(() {
        beers = Beer.fromJsonList(jsonList); // Преобразуем JSON в объекты Beer
      });
    } else {
      throw Exception('Failed to load beers');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Beer Shop'),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              // Переход в корзину
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: beers.isEmpty
          ? Center(child: CircularProgressIndicator()) // Показываем загрузку, если пиво еще не загружено
          : ListView.builder(
              itemCount: beers.length,
              itemBuilder: (context, index) {
                final beer = beers[index];
                return ListTile(
                  leading: Image.asset(beer.image), // Путь к изображению пива
                  title: Text(beer.name),
                  subtitle: Text('\$${beer.price.toStringAsFixed(2)}'),
                  onTap: () {
                    // Переход на страницу с деталями пива
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BeerDetailScreen(beer: beer),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
