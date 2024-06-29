import 'package:flutter/material.dart';

class MenuItem extends StatelessWidget {
  final String title; // Judul item menu
  final String imageUrl; // URL gambar item menu
  final String price; // Harga item menu
  final Function(String, String, String) addToCart; // Fungsi untuk menambah item ke keranjang belanja

  MenuItem({
    required this.title,
    required this.imageUrl,
    required this.price,
    required this.addToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Card( // Menggunakan widget Card untuk menampilkan item menu
      elevation: 4.0, // Elevation (bayangan) pada card
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0), // Mengatur border radius card
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch, // Memposisikan children secara horizontal
        children: [
          Expanded(
            child: ClipRRect( // Menggunakan ClipRRect untuk memotong gambar
              borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)), // Mengatur border radius gambar atas
              child: Image.network( // Menampilkan gambar dari URL
                imageUrl,
                fit: BoxFit.cover, // Menyesuaikan gambar agar muat di kotak yang tersedia
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0), // Padding di dalam card
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title, // Menampilkan judul item menu
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.0), // Spasi vertikal antara judul dan harga
                Text(
                  price, // Menampilkan harga item menu
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16.0,
                    color: Colors.grey[600], // Warna abu-abu untuk harga
                  ),
                ),
                SizedBox(height: 12.0), // Spasi vertikal antara harga dan tombol
                Align(
                  alignment: Alignment.center, // Membuat tombol berada di tengah
                  child: ElevatedButton.icon(
                    onPressed: () {
                      addToCart(title, imageUrl, price); // Memanggil fungsi addToCart saat tombol ditekan
                    },
                    icon: Icon(Icons.add_shopping_cart_outlined), // Menampilkan ikon keranjang belanja
                    label: Text('Tambahkan'), // Label pada tombol
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, // Warna teks
                      backgroundColor: Colors.orange, // Warna latar belakang tombol
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0), // Mengatur border radius tombol
                      ),
                    ),
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
