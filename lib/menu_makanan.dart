import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class MenuMakanan extends StatefulWidget {
  @override
  _MenuMakananState createState() => _MenuMakananState();
}

class _MenuMakananState extends State<MenuMakanan>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  List<Map<String, dynamic>> _cartItems = [];

  @override
  void initState() {
    super.initState();
    _loadCartItems();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _saveCartItems();
    super.dispose();
  }

  void _loadCartItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cartItemsJson = prefs.getString('cartItems');
    if (cartItemsJson != null) {
      List<dynamic> cartItemsData = jsonDecode(cartItemsJson);
      _cartItems = cartItemsData
          .map((item) => Map<String, dynamic>.from(item))
          .toList();
    }
  }

  void _saveCartItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String cartItemsJson = jsonEncode(_cartItems);
    prefs.setString('cartItems', cartItemsJson);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu Makanan'),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartPage(_cartItems),
                ),
              );
            },
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return FadeTransition(
            opacity: _animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: Offset(0.0, 0.2),
                end: Offset.zero,
              ).animate(_animation),
              child: child,
            ),
          );
        },
        child: ListView(
          children: [
            Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Makanan Utama',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  _buildMenuCard(
                    'Nasi Goreng',
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR39CiUalSn50P2eXCsGSj8ec2JULutPqqncCRIKgTaNifHHfnzujqru9uWzdXd',
                    'Rp 25.000',
                  ),
                  _buildMenuCard(
                    'Ayam Bakar',
                    'https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcQpdqJghJ2Wdra3-3aQqtfVU1UsAZjLs37A61cJ6eCHYcpl2y7FRrfqr1iJES0i',
                    'Rp 30.000',
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