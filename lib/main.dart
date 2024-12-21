import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/cart_provider.dart';
import 'providers/favorites_provider.dart';
import 'screens/home_screen.dart';
import 'screens/beer_detail_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/favorites_screen.dart';
import 'beer_data.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CartProvider()),
        ChangeNotifierProvider(create: (context) => FavoritesProvider()),
      ],
      child: MaterialApp(
        title: 'Beer Shop',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.brown,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const HomeScreen(),
          '/cart': (context) => const CartScreen(),
          '/favorites': (context) => const FavoritesScreen(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == '/beerDetail') {
            final Beer beer = settings.arguments as Beer;
            return MaterialPageRoute(
              builder: (context) => BeerDetailScreen(beer: beer),
            );
          }
          return null;
        },
      ),
    );
  }
}
