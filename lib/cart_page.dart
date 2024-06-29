import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'checkout_page.dart';

class CartPage extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;

  CartPage(this.cartItems);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  double _totalPrice = 0.0;

  @override
  void initState() {
    super.initState();
    _calculateTotalPrice();
  }

  void _removeFromCart(int index) {
    setState(() {
      widget.cartItems.removeAt(index);
      _calculateTotalPrice();
      _saveCartItems();
    });
  }

  void _calculateTotalPrice() {
    double total = 0.0;
    for (var item in widget.cartItems) {
      total += double.parse(
          item['price'].replaceAll('Rp ', '').replaceAll('.', ''));
    }
    setState(() {
      _totalPrice = total;
    });
  }

  void _saveCartItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String cartItemsJson = jsonEncode(widget.cartItems);
    prefs.setString('cartItems', cartItemsJson);
  }

  void _checkout() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CheckoutPage(widget.cartItems, _totalPrice),
      ),
    ).then((_) {
      _loadCartItems();
    });
  }

  void _loadCartItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cartItemsJson = prefs.getString('cartItems');
    if (cartItemsJson != null) {
      List<dynamic> cartItemsData = jsonDecode(cartItemsJson);
      setState(() {
        widget.cartItems.clear();
        widget.cartItems.addAll(cartItemsData.map((item) => Map<String, dynamic>.from(item)).toList());
        _calculateTotalPrice();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[50],
      appBar: AppBar(
        title: Text('Keranjang Belanja'),
        backgroundColor: Colors.orange,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              itemCount: widget.cartItems.length,
              itemBuilder: (context, index) {
                final item = widget.cartItems[index];
                return Card(
                  elevation: 2.0,
                  margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                  child: ListTile(
                    leading: Image.network(
                      item['imageUrl'],
                      width: 60.0,
                      height: 60.0,
                      fit: BoxFit.cover,
                    ),
                    title: Text(item['title'], style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(item['price'], style: TextStyle(color: Colors.grey[600])),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.orange),
                      onPressed: () => _removeFromCart(index),
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) => Divider(),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Harga:',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Rp ${_totalPrice.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              onPressed: _checkout,
              icon: Icon(Icons.shopping_cart_checkout),
              label: Text('Checkout'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.orange,
                padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                textStyle: TextStyle(fontSize: 18.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
