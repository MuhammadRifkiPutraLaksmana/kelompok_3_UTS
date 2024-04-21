import 'package:flutter/material.dart';
import 'checkout_page.dart';

class CartPage extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;

  CartPage(this.cartItems);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  double _totalPrice = 0.0;
  void _removeFromCart(int index) {
  setState(() {
    widget.cartItems.removeAt(index);
    _calculateTotalPrice();
  });
}

  @override
  void initState() {
    super.initState();
    _calculateTotalPrice();
  }

  void _calculateTotalPrice() {
    double total = 0.0;
    for (var item in widget.cartItems) {
      total += double.parse(item['price'].replaceAll('Rp ', '').replaceAll('.', ''));
    }
    setState(() {
      _totalPrice = total;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Keranjang Belanja'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.cartItems.length,
              itemBuilder: (context, index) {
                final item = widget.cartItems[index];
                return Card(
                  child: ListTile(
                    leading: Image.network(
                      item['imageUrl'],
                      width: 60.0,
                      height: 60.0,
                      fit: BoxFit.cover,
                    ),
                    title: Text(item['title']),
                    subtitle: Text(item['price']),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _removeFromCart(index),
                    ),
                  ),
                );
              },
            )
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Harga:',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Rp ${_totalPrice.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 18.0,
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
              onPressed: () {
                // Navigasi ke halaman checkout
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CheckoutPage(widget.cartItems),
                  ),
                );
              },
              icon: Icon(Icons.shopping_cart_checkout),
              label: Text('Checkout'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.orange,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
