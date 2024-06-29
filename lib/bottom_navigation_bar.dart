import 'package:flutter/material.dart';
import 'cart_page.dart'; // Mengimpor halaman keranjang belanja
import 'profil_page.dart'; // Mengimpor halaman profil pengguna
import 'history_page.dart'; // Mengimpor halaman histori pembelian

// Mendefinisikan widget CustomBottomNavigationBar yang tidak berubah-ubah (stateless)
class CustomBottomNavigationBar extends StatelessWidget {
  final List<Map<String, dynamic>> cartItems; // Daftar item dalam keranjang

  // Konstruktor untuk menerima data item keranjang
  CustomBottomNavigationBar(this.cartItems);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: 0, // Menetapkan index awal yang aktif (0 adalah halaman keranjang)
      items: [
        // Menambahkan item navigasi untuk halaman keranjang
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart_outlined),
          label: 'Keranjang',
        ),
        // Menambahkan item navigasi untuk halaman profil
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: 'Profil',
        ),
        // Menambahkan item navigasi untuk halaman histori
        BottomNavigationBarItem(
          icon: Icon(Icons.history),
          label: 'Histori',
        ),
      ],
      // Fungsi yang dipanggil ketika sebuah item di tap
      onTap: (int index) {
        if (index == 0) {
          // Jika item pertama (keranjang) di tap, navigasikan ke halaman keranjang
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CartPage(cartItems), // Membuka CartPage dengan item keranjang
            ),
          );
        } else if (index == 1) {
          // Jika item kedua (profil) di tap, navigasikan ke halaman profil
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProfilPage(), // Membuka ProfilPage
            ),
          );
        } else if (index == 2) {
          // Jika item ketiga (histori) di tap, navigasikan ke halaman histori
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HistoryPage(), // Membuka HistoryPage
            ),
          );
        }
      },
    );
  }
}
