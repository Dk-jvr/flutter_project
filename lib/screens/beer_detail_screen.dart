import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
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
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _litersController = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.beer.name),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
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
      body: SingleChildScrollView(  // Добавляем прокрутку, чтобы избежать переполнения
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(widget.beer.image),
            const SizedBox(height: 16),
            Text(widget.beer.name, style: AppStyles.getTitleStyle(context)),
            const SizedBox(height: 8),
            Text('Price: \$${widget.beer.price.toStringAsFixed(2)} per liter'),
            const SizedBox(height: 16),
            Text('Description:'),
            TextFormField(
              controller: _descriptionController,
              decoration: AppStyles.getInputDecoration(),
              maxLines: 5,
              onChanged: (value) {
                setState(() {
                  widget.beer.description = value;
                });
              },
            ),
            const SizedBox(height: 16),
            Text(
              'Enter Quantity (in liters):',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            // Ограничиваем высоту поля ввода, чтобы оно занимало только половину экрана
            Container(
              height: MediaQuery.of(context).size.height / 4,  // Высота поля ввода равна половине экрана
              child: TextField(
                controller: _litersController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Liters',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  final parsedValue = double.tryParse(value);
                  if (parsedValue != null && parsedValue > 0) {
                    setState(() {
                      _liters = parsedValue;
                    });
                  } else {
                    setState(() {
                      _liters = 1.0; // Default value if invalid input
                    });
                  }
                },
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'You selected $_liters liters',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Provider.of<CartProvider>(context, listen: false)
                    .addToCart(widget.beer, _liters);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${widget.beer.name} added to cart!')),
                );
              },
              child: Text('Add to Cart', style: AppStyles.getButtonTextStyle()),
            ),
          ],
        ),
      ),
    );
  }
}
