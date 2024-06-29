// Import library Flutter untuk membangun UI.
import 'package:flutter/material.dart';
// Import library untuk menggunakan shared preferences, menyimpan data kecil secara lokal.
import 'package:shared_preferences/shared_preferences.dart';
// Import library Dart untuk konversi JSON.
import 'dart:convert';
// Import library untuk melakukan HTTP requests.
import 'package:http/http.dart' as http;
// Import file lain dalam proyek ini, menu_makanan.dart.
import 'menu_makanan.dart';

// Definisikan kelas CheckoutPage yang merupakan StatefulWidget.
class CheckoutPage extends StatefulWidget {
  // Deklarasi variabel yang akan diinisialisasi saat kelas ini dipanggil.
  final List<Map<String, dynamic>> cartItems; // Daftar item dalam keranjang.
  final double totalPrice; // Total harga dari semua item dalam keranjang.

  // Konstruktor untuk inisialisasi variabel cartItems dan totalPrice.
  CheckoutPage(this.cartItems, this.totalPrice);

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

// Definisikan state untuk kelas CheckoutPage.
class _CheckoutPageState extends State<CheckoutPage> {
  String? _selectedDeliveryMethod; // Variabel untuk menyimpan metode pengiriman yang dipilih.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[50], // Warna latar belakang halaman.
      appBar: AppBar(
        title: Text('Checkout'), // Judul di AppBar.
        backgroundColor: Colors.orange, // Warna latar belakang AppBar.
        leading: IconButton(
          icon: Icon(Icons.arrow_back), // Ikon tombol kembali.
          onPressed: () {
            // Aksi ketika tombol kembali ditekan.
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => MenuMakanan()),
              (Route<dynamic> route) => false,
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 30), // Padding untuk konten halaman.
        child: Column(
          children: <Widget>[
            // Baris untuk pengaturan pengiriman.
            _buildCheckoutRow("Pengiriman", trailingWidget: _buildDropdown()),
            _buildDivider(), // Garis pemisah.
            // Baris untuk informasi pembayaran.
            _buildCheckoutRow("Pembayaran", trailingText: "Pembayaran Ditempat"),
            _buildDivider(), // Garis pemisah.
            // Baris untuk total biaya.
            _buildCheckoutRow("Total Biaya", trailingText: "Rp${widget.totalPrice.toStringAsFixed(2)}"),
            _buildDivider(), // Garis pemisah.
            SizedBox(height: 30), // Jarak antara komponen.
            _buildPlaceOrderButton(), // Tombol untuk memesan sekarang.
          ],
        ),
      ),
    );
  }

  // Membuat widget Divider (garis pemisah).
  Widget _buildDivider() {
    return Divider(thickness: 1, color: Colors.orange.shade200);
  }

  // Membuat baris untuk item checkout.
  Widget _buildCheckoutRow(String label, {String? trailingText, Widget? trailingWidget}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 18, color: Colors.orange, fontWeight: FontWeight.w500),
          ),
          Spacer(),
          trailingText == null 
            ? (trailingWidget ?? Container()) 
            : Text(
                trailingText,
                style: TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.w500),
              ),
        ],
      ),
    );
  }

  // Membuat dropdown untuk memilih metode pengiriman.
  Widget _buildDropdown() {
    return DropdownButton<String>(
      value: _selectedDeliveryMethod,
      hint: Text('Pilih Metode', style: TextStyle(color: Colors.orange)),
      onChanged: (newValue) {
        setState(() {
          _selectedDeliveryMethod = newValue;
        });
      },
      items: <String>['Kurir JAK', 'Spekudelivery', 'Antaraja', 'Jastipsmr']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  // Membuat tombol untuk memesan sekarang.
  Widget _buildPlaceOrderButton() {
    return ElevatedButton(
      onPressed: onPlaceOrderClicked, // Aksi ketika tombol ditekan.
      child: Text('Pesan Sekarang'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 80),
        textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 5,
      ),
    );
  }

  // Fungsi ketika tombol "Pesan Sekarang" ditekan.
  void onPlaceOrderClicked() {
    _saveToHistory(widget.cartItems); // Simpan pesanan ke histori.
    _clearCartItems(); // Hapus item dari keranjang.
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => MenuMakanan()),
      (Route<dynamic> route) => false,
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Pesanan Diterima'),
          content: Text('Pesanan Anda telah berhasil diproses.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK', style: TextStyle(color: Colors.orange)),
            ),
          ],
        );
      },
    );
  }

  // Fungsi untuk menyimpan pesanan ke histori.
  void _saveToHistory(List<Map<String, dynamic>> cartItems) async {
    final url = Uri.parse('http://127.0.0.1:8000/api/purchase-history/');
    
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'items': cartItems.map((item) => {
          'title': item['title'],
          'image': item['imageUrl'], // Pastikan key sesuai dengan yang diharapkan oleh API
          'price': item['price'],
        }).toList(),
      }),
    );

    if (response.statusCode == 201) {
      print('Histori disimpan: ${response.body}');
    } else {
      print('Gagal menyimpan histori: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }

  // Fungsi untuk menghapus item dari keranjang.
  void _clearCartItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('cartItems');
    setState(() {
      widget.cartItems.clear();
    });
    print("Keranjang dikosongkan");
  }
}
