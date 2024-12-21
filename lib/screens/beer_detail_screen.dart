import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../providers/favorites_provider.dart';
import '../beer_data.dart';
import 'cart_screen.dart';
import '../styles/app_styles.dart';

class BeerDetailScreen extends StatefulWidget {
  final Beer beer;

  const BeerDetailScreen({super.key, required this.beer});

  @override
  _BeerDetailScreenState createState() => _BeerDetailScreenState();
}

class _BeerDetailScreenState extends State<BeerDetailScreen> {
  double _liters = 1.0;
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _litersController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _descriptionController.text = widget.beer.description;
    _litersController.text = _liters.toStringAsFixed(1);
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _litersController.dispose();
    super.dispose();
  }

  void _saveDescription() {
    setState(() {
      widget.beer.description = _descriptionController.text;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Description updated!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    bool isFavorite = favoritesProvider.favoriteBeers.contains(widget.beer);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.beer.name),
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
          IconButton(
            icon: Icon(
              shadows: [
                  Shadow(blurRadius: 3, color: Colors.black)
              ],
              isFavorite ? Icons.favorite : Icons.favorite,
              color: isFavorite ? Colors.red : Colors.white
            ),
            onPressed: () {
              if (isFavorite) {
                favoritesProvider.removeFromFavorites(widget.beer);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Removed from favorites')),
                );
              } else {
                favoritesProvider.addToFavorites(widget.beer);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Added to favorites')),
                );
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: Image.asset(
                widget.beer.image,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.beer.name,
                    style: AppStyles.getTitleStyle(context),
                  ),
                  const SizedBox(height: 8),

                  Text(
                    'Price: \$${widget.beer.price.toStringAsFixed(2)} per liter',
                    style: AppStyles.bodyTextStyle(context),
                  ),
                  const SizedBox(height: 16),

                  Text(
                    'Description:',
                    style: AppStyles.bodyTextStyle(context),
                  ),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: AppStyles.getInputDecoration(),
                    maxLines: 5,
                  ),
                  const SizedBox(height: 16),

                  ElevatedButton(
                    onPressed: _saveDescription,
                    child: const Text('Save Description'),
                    style: AppStyles.buttonStyle,
                  ),
                  const SizedBox(height: 16),

                  Text(
                    'Enter Quantity (in liters):',
                    style: AppStyles.bodyTextStyle(context),
                  ),
                  TextField(
                    controller: _litersController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: AppStyles.getInputDecoration(),
                    onChanged: (value) {
                      final parsedValue = double.tryParse(value);
                      if (parsedValue != null && parsedValue > 0) {
                        setState(() {
                          _liters = parsedValue;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 16),

                  Text(
                    'You selected $_liters liters',
                    style: AppStyles.bodyTextStyle(context),
                  ),
                  const SizedBox(height: 16),

                  ElevatedButton(
                    onPressed: () {
                      Provider.of<CartProvider>(context, listen: false)
                          .addToCart(widget.beer, _liters);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${widget.beer.name} added to cart!'),
                        ),
                      );
                    },
                    child: const Text('Add to Cart'),
                    style: AppStyles.buttonStyle,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
