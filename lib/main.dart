import 'package:flutter/material.dart'; // Mengimpor paket Flutter untuk membuat aplikasi dengan material design
import 'login_page.dart'; // Mengimpor halaman login

void main() {
  runApp(MyApp()); // Fungsi utama yang menjalankan aplikasi MyApp
}

class MyApp extends StatelessWidget { // Mendefinisikan kelas MyApp yang merupakan turunan dari StatelessWidget
  @override
  Widget build(BuildContext context) { // Metode build untuk membangun UI
    return MaterialApp( // Mengembalikan widget MaterialApp
      title: 'Flutter Demo', // Judul aplikasi
      theme: ThemeData( // Tema aplikasi
        primarySwatch: Colors.orange, // Warna utama aplikasi adalah oranye
      ),
      home: LoginPage(), // Halaman pertama yang ditampilkan adalah LoginPage
    );
  }
}