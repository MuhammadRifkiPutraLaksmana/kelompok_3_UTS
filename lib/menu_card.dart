import 'package:flutter/material.dart';

class MenuCard extends StatelessWidget {
  // Deklarasi variabel `imageUrl` untuk menyimpan URL gambar.
  final String imageUrl;
  // Deklarasi variabel `borderRadius` untuk menentukan radius pembulatan sudut pada container.
  final double borderRadius;

  // Konstruktor yang memerlukan parameter `imageUrl` dan `borderRadius`.
  MenuCard({required this.imageUrl, required this.borderRadius});

  @override
  Widget build(BuildContext context) {
    return Container(
      // Mengatur lebar container agar sesuai dengan lebar layar.
      width: MediaQuery.of(context).size.width,
      // Margin horizontal untuk memberikan jarak pada sisi kiri dan kanan.
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      // Dekorasi untuk container, termasuk borderRadius dan boxShadow.
      decoration: BoxDecoration(
        // Mengatur borderRadius dengan nilai yang diberikan pada konstruktor.
        borderRadius: BorderRadius.circular(borderRadius),
        // BoxShadow untuk memberikan efek bayangan pada container.
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5), // Warna bayangan.
            spreadRadius: 2, // Seberapa jauh bayangan menyebar.
            blurRadius: 5, // Seberapa buram bayangan.
            offset: Offset(0, 3), // Posisi bayangan.
          ),
        ],
      ),
      // ClipRRect digunakan untuk memotong gambar sesuai dengan borderRadius.
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Stack(
          children: [
            // Widget Image.network untuk menampilkan gambar dari URL.
            Image.network(
              imageUrl,
              fit: BoxFit.cover, // Mengatur gambar agar menutupi seluruh area.
              width: double.infinity, // Lebar gambar diatur maksimal.
              height: double.infinity, // Tinggi gambar diatur maksimal.
            ),
            // Container tambahan untuk gradient overlay.
            Container(
              decoration: BoxDecoration(
                // Gradient dari hitam transparan di bawah ke transparan di atas.
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
