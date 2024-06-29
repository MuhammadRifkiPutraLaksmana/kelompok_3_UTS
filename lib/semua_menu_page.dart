import 'package:flutter/material.dart';
import 'menu_item.dart'; // Import widget item menu
import 'bottom_navigation_bar.dart'; // Import bottom navigation bar
import 'package:shared_preferences/shared_preferences.dart'; // Import shared preferences
import 'dart:convert'; // Import untuk konversi JSON

class SemuaMenuPage extends StatefulWidget {
  final List<Map<String, dynamic>> menuItems; // List untuk menyimpan semua item menu

  SemuaMenuPage({required this.menuItems}); // Constructor dengan parameter menuItems yang harus disediakan

  @override
  _SemuaMenuPageState createState() => _SemuaMenuPageState();
}

class _SemuaMenuPageState extends State<SemuaMenuPage> {
  List<Map<String, dynamic>> _cartItems = []; // Daftar item di keranjang

  List<Map<String, dynamic>> get _menuItems => widget.menuItems; // Mendapatkan daftar semua item menu dari properti widget

  @override
  void initState() {
    super.initState();
    _loadCartItems(); // Memuat item keranjang dari shared preferences
  }

  void _loadCartItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance(); // Mendapatkan instance shared preferences
    String? cartItemsJson = prefs.getString('cartItems'); // Mengambil data item keranjang dalam bentuk JSON
    if (cartItemsJson != null) {
      List<dynamic> cartItemsData = jsonDecode(cartItemsJson); // Mengonversi JSON ke list
      setState(() {
        _cartItems = cartItemsData.map((item) => Map<String, dynamic>.from(item)).toList(); // Mengonversi list ke map
      });
    }
  }

  void _saveCartItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance(); // Mendapatkan instance shared preferences
    String cartItemsJson = jsonEncode(_cartItems); // Mengonversi item keranjang ke JSON
    prefs.setString('cartItems', cartItemsJson); // Menyimpan JSON ke shared preferences
  }

  void _addToCart(String title, String imageUrl, String price) {
    setState(() {
      _cartItems.add({'title': title, 'imageUrl': imageUrl, 'price': price}); // Menambahkan item ke daftar keranjang
    });
    _saveCartItems(); // Menyimpan daftar keranjang ke shared preferences
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[50],
      appBar: AppBar(
        title: Text('Semua Menu'), // Judul halaman
        backgroundColor: Colors.orange, // Warna latar belakang appbar
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(16.0), // Padding grid
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Jumlah kolom dalam grid
          childAspectRatio: 0.8, // Rasio aspek setiap item dalam grid
          crossAxisSpacing: 16.0, // Jarak antar kolom
          mainAxisSpacing: 16.0, // Jarak antar baris
        ),
        itemCount: _menuItems.length, // Jumlah item dalam grid
        itemBuilder: (context, index) {
          final item = _menuItems[index]; // Mendapatkan item pada indeks tertentu
          return MenuItem(
            title: item['title'],
            imageUrl: item['imageUrl'],
            price: item['price'],
            addToCart: _addToCart, // Panggil fungsi _addToCart saat tombol ditekan
          ); // Menampilkan item menu menggunakan widget MenuItem
        },
      ),
      bottomNavigationBar: CustomBottomNavigationBar(_cartItems), // Tambahkan bottom navigation bar dengan daftar item keranjang
    );
  }
}
