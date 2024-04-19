import 'package:flutter/material.dart';
import 'menu_makanan.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Menu Makanan',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        hintColor: Colors.orangeAccent,
      ),
      home: MenuMakanan(), // Ganti ke StatefulWidget
    );
  }
}