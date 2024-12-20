import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import 'dart:math';
import '../utils/promo_code_service.dart';
import '../utils/promo_code.dart'; // Импортируем модель промокода

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
      (promoCode) => promoCode.name == _promoCode && promoCode.expirationDate.isAfter(DateTime.now()),
      orElse: () => PromoCode(name: 'default', discount: 0.0, expirationDate: DateTime.now()), // Возвращаем дефолтный промокод
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
    Provider.of<CartProvider>(context, listen: false).clearCart();

    // Показать диалог с подтверждением заказа
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text('Order Confirmed'),
          content: Text(
              'Your order №$randomOrderNumber has been placed! \nPayment method: $_paymentMethod\nTotal with discount: \$${_calculateTotalWithDiscount().toStringAsFixed(2)}'),
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
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItems = cartProvider.cartItems;
    double total = cartItems.fold(0.0, (sum, item) => sum + (item.liters * item.beer.price));

    return total * (1 - _discount);
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItems = cartProvider.cartItems;

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
                            'Quantity: ${item.liters.toStringAsFixed(2)} liters\nTotal: \$${(item.liters * item.beer.price).toStringAsFixed(2)}'),
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
                      // Радиокнопки для выбора способа оплаты
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
                      // Поле для промокода
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
                            'Applied promo code: ${_appliedPromoCode!.name}\nDiscount: ${_appliedPromoCode!.discount * 100}%',
                            style: TextStyle(color: Colors.green),
                          ),
                        ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: _applyPromoCode,
                            child: Text('Apply Promo Code'),
                          ),
                          if (_appliedPromoCode != null)
                            ElevatedButton(
                              onPressed: _removePromoCode,
                              child: Text('Remove Promo Code'),
                            ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                          onPressed: () => _confirmOrder(context),
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
