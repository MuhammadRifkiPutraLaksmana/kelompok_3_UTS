import 'package:carousel_slider/carousel_slider.dart'; // Import untuk carousel slider
import 'package:flutter/material.dart'; // Import untuk material design
import 'package:shared_preferences/shared_preferences.dart'; // Import untuk shared preferences
import 'dart:convert'; // Import untuk konversi JSON
import 'menu_item.dart'; // Import untuk komponen menu item
import 'menu_card.dart'; // Import untuk komponen menu card
import 'bottom_navigation_bar.dart'; // Import untuk komponen bottom navigation bar
import 'semua_menu_page.dart'; // Import untuk halaman semua menu
import 'package:http/http.dart' as http; // Import untuk HTTP request

class MenuMakanan extends StatefulWidget {
  @override
  _MenuMakananState createState() => _MenuMakananState();
}

class _MenuMakananState extends State<MenuMakanan> with SingleTickerProviderStateMixin {
  late AnimationController _animationController; // Controller untuk animasi
  late Animation<double> _animation; // Animasi untuk transisi
  List<Map<String, dynamic>> _cartItems = []; // Daftar item di keranjang
  final List<Map<String, dynamic>> _menuItems = []; // Daftar item menu

  @override
  void initState() {
    super.initState();
    _loadCartItems(); // Memuat item keranjang dari shared preferences
    _fetchMenuItems(); // Mengambil item menu dari API
    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 500)); // Inisialisasi controller animasi
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut)); // Inisialisasi animasi
    _animationController.forward(); // Memulai animasi
  }

  @override
  void dispose() {
    _animationController.dispose(); // Membersihkan controller animasi
    _saveCartItems(); // Menyimpan item keranjang ke shared preferences
    _savePurchaseHistory(); // Menyimpan riwayat pembelian ke shared preferences
    super.dispose();
  }

  void _loadCartItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance(); // Mendapatkan instance shared preferences
    String? cartItemsJson = prefs.getString('cartItems'); // Mengambil data item keranjang dalam bentuk JSON
    if (cartItemsJson != null) {
      List<dynamic> cartItemsData = jsonDecode(cartItemsJson); // Mengonversi JSON ke list
      _cartItems = cartItemsData.map((item) => Map<String, dynamic>.from(item)).toList(); // Mengonversi list ke map
    }
  }

  void _saveCartItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance(); // Mendapatkan instance shared preferences
    String cartItemsJson = jsonEncode(_cartItems); // Mengonversi item keranjang ke JSON
    prefs.setString('cartItems', cartItemsJson); // Menyimpan JSON ke shared preferences
  }

  void _savePurchaseHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance(); // Mendapatkan instance shared preferences
    String purchaseHistoryJson = jsonEncode(_cartItems); // Mengonversi item keranjang ke JSON
    prefs.setString('purchaseHistory', purchaseHistoryJson); // Menyimpan JSON ke shared preferences
  }

  Future<void> _fetchMenuItems() async {
    try {
      final response = await http.get(Uri.parse('http://127.0.0.1:8000/api/menu-items/')); // Mengambil data dari API
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body); // Mengonversi response body ke list
        setState(() {
          _menuItems.clear(); // Membersihkan daftar item menu
          for (var item in data) {
            _menuItems.add({'title': item['title'], 'imageUrl': item['image'], 'price': item['price']}); // Menambahkan item ke daftar menu
          }
        });
      } else {
        throw Exception('Failed to load menu items'); // Menangani error jika gagal mengambil data
      }
    } catch (e) {
      print('Error fetching menu items: $e'); // Menangani error jika terjadi exception
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu Makanan', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold)), // Judul di AppBar
        backgroundColor: Colors.orange, // Warna latar belakang AppBar
        centerTitle: true, // Menengahkan judul
      ),
      backgroundColor: Colors.orange[50], // Warna latar belakang Scaffold
      body: AnimatedBuilder(
        animation: _animation, // Animasi yang digunakan
        builder: (context, child) {
          return Center(
            child: Container(
              padding: EdgeInsets.all(20.0), // Padding untuk container
              child: FadeTransition(
                opacity: _animation, // Transisi memudar
                child: SlideTransition(
                  position: Tween<Offset>(begin: Offset(0.0, 0.2), end: Offset.zero).animate(_animation), // Transisi geser
                  child: child,
                ),
              ),
            ),
          );
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center, // Menengahkan konten
            children: [
              SizedBox(height: 16.0), // Jarak vertikal
              Text('Menu Populer', style: TextStyle(fontFamily: 'Poppins', fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.orange)), // Teks judul
              SizedBox(height: 16.0), // Jarak vertikal
              CarouselSlider(
                options: CarouselOptions(height: 300, autoPlay: true, enlargeCenterPage: true), // Opsi untuk carousel
                items: _menuItems.map((item) {
                  return MenuCard(imageUrl: item['imageUrl'], borderRadius: 10.0); // Item dalam carousel
                }).toList(),
              ),
              SizedBox(height: 32.0), // Jarak vertikal
              Text('Menu Lengkap', style: TextStyle(fontFamily: 'Poppins', fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.orange)), // Teks judul
              SizedBox(height: 16.0), // Jarak vertikal
              GridView.builder(
                shrinkWrap: true, // Mengatur agar grid view tidak mengambil seluruh ruang
                physics: NeverScrollableScrollPhysics(), // Menonaktifkan scroll pada grid view
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.8, crossAxisSpacing: 16.0, mainAxisSpacing: 16.0), // Konfigurasi grid view
                itemCount: _menuItems.length > 4 ? 4 : _menuItems.length, // Jumlah item yang ditampilkan
                itemBuilder: (context, index) {
                  final item = _menuItems[index]; // Mendapatkan item dari daftar menu
                  return MenuItem(title: item['title'], imageUrl: item['imageUrl'], price: item['price'], addToCart: _addToCart); // Komponen menu item
                },
              ),
              SizedBox(height: 20.0), // Jarak vertikal
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SemuaMenuPage(menuItems: _menuItems))); // Menavigasi ke halaman semua menu
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange), // Warna tombol
                child: Text('Lihat Lebih Banyak Menu', style: TextStyle(color: Colors.white)), // Teks tombol
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(_cartItems), // Bottom navigation bar dengan daftar item keranjang
    );
  }

  void _addToCart(String title, String imageUrl, String price) {
    setState(() {
      _cartItems.add({'title': title, 'imageUrl': imageUrl, 'price': price}); // Menambahkan item ke daftar keranjang
    });
    _saveCartItems(); // Menyimpan daftar keranjang ke shared preferences
  }
}
