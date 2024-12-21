import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../utils/promo_code_service.dart';
import '../utils/promo_code.dart'; // Import promo code model
import 'dart:math';
import '../styles/app_styles.dart'; // Import AppStyles for button styles

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  String _paymentMethod = 'card';
  String _promoCode = '';
  bool _isPromoValid = true;
  double _discount = 0.0;
  List<PromoCode> _promoCodes = [];
  PromoCode? _appliedPromoCode;
  bool _isTermsAccepted = false;
  bool _isSubscribed = false;

  @override
  void initState() {
    super.initState();
    _loadPromoCodes();
  }

  Future<void> _loadPromoCodes() async {
    final promoCodes = await PromoCodeService.loadPromoCodes();
    setState(() {
      _promoCodes = promoCodes;
    });
  }

  void _applyPromoCode() {
    final promoCode = _promoCodes.firstWhere(
      (promoCode) =>
          promoCode.name == _promoCode &&
          promoCode.expirationDate.isAfter(DateTime.now()),
      orElse: () => PromoCode(
        name: 'default',
        discount: 0.0,
        expirationDate: DateTime.now(),
      ),
    );

    if (promoCode.name != 'default') {
      setState(() {
        _appliedPromoCode = promoCode;
        _discount = promoCode.discount;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Promo code applied: ${promoCode.name}')),
      );
    } else {
      setState(() {
        _isPromoValid = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid or expired promo code!')),
      );
    }
  }

  void _removePromoCode() {
    setState(() {
      _appliedPromoCode = null;
      _discount = 0.0;
      _promoCode = '';
      _isPromoValid = true;
    });
  }

  void _confirmOrder(BuildContext context) {
    final randomOrderNumber = Random().nextInt(100000);
    final totalWithDiscount = _calculateTotalWithDiscount();

    Provider.of<CartProvider>(context, listen: false).clearCart();

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text('Order Confirmed'),
          content: Text(
            'Your order №$randomOrderNumber has been placed!\n'
            'Payment method: $_paymentMethod\n'
            'Total: \$${totalWithDiscount.toStringAsFixed(2)}',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/',
                  (route) => false,
                );
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  double _calculateTotalWithDiscount() {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final cartItems = cartProvider.cartItems;
    double total = cartItems.fold(
      0.0,
      (sum, item) => sum + (item.liters * item.beer.price),
    );
    return total * (1 - _discount);
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItems = cartProvider.cartItems;
    final totalWithDiscount = _calculateTotalWithDiscount();

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: cartItems.isEmpty
          ? Center(child: Text('Your cart is empty'))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return ListTile(
                        leading: Image.asset(item.beer.image, width: 50),
                        title: Text(item.beer.name),
                        subtitle: Text(
                          'Quantity: ${item.liters.toStringAsFixed(2)} liters\n'
                          'Total: \$${(item.liters * item.beer.price).toStringAsFixed(2)}',
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            cartProvider.removeFromCart(index);
                          },
                        ),
                      );
                    },
                  ),
                ),
                Divider(),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Select Payment Method:',
                        style: TextStyle(fontSize: 16),
                      ),
                      ListTile(
                        title: Text('Pay by Card'),
                        leading: Radio<String>(
                          value: 'card',
                          groupValue: _paymentMethod,
                          onChanged: (String? value) {
                            setState(() {
                              _paymentMethod = value!;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: Text('Cash on Delivery'),
                        leading: Radio<String>(
                          value: 'cash',
                          groupValue: _paymentMethod,
                          onChanged: (String? value) {
                            setState(() {
                              _paymentMethod = value!;
                            });
                          },
                        ),
                      ),
                      Text(
                        'Promo Code:',
                        style: TextStyle(fontSize: 16),
                      ),
                      TextField(
                        onChanged: (value) {
                          setState(() {
                            _promoCode = value;
                          });
                        },
                        decoration: InputDecoration(
                          labelText: 'Enter promo code',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      if (!_isPromoValid)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            'Promo code is invalid or expired!',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      if (_appliedPromoCode != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            'Applied promo code: ${_appliedPromoCode!.name}\n'
                            'Discount: ${_appliedPromoCode!.discount * 100}%',
                            style: TextStyle(color: Colors.green),
                          ),
                        ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: _applyPromoCode,
                            style: AppStyles.buttonStyle, // Use AppStyles here
                            child: Text('Apply Promo Code'),
                          ),
                          if (_appliedPromoCode != null)
                            ElevatedButton(
                              onPressed: _removePromoCode,
                              style: AppStyles.buttonStyle, // Use AppStyles here
                              child: Text('Remove Promo Code'),
                            ),
                        ],
                      ),
                      Divider(),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          'Total with discount: \$${totalWithDiscount.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Checkbox(
                            value: _isTermsAccepted,
                            onChanged: (bool? value) {
                              setState(() {
                                _isTermsAccepted = value ?? false;
                              });
                            },
                          ),
                          Expanded(
                            child: Text('I agree to the terms and conditions'),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Checkbox(
                            value: _isSubscribed,
                            onChanged: (bool? value) {
                              setState(() {
                                _isSubscribed = value ?? false;
                              });
                            },
                          ),
                          Expanded(
                            child: Text('Subscribe to notifications'),
                          ),
                        ],
                      ),
                      Center(
                        child: ElevatedButton(
                          onPressed: _isTermsAccepted
                              ? () => _confirmOrder(context)
                              : null,
                          style: AppStyles.buttonStyle, // Use AppStyles here
                          child: Text('Confirm Order'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
