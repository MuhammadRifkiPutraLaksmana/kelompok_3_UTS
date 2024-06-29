import 'package:flutter/material.dart'; // Mengimpor paket Flutter untuk membuat antarmuka pengguna.
import 'package:http/http.dart' as http; // Mengimpor paket HTTP untuk melakukan permintaan HTTP.
import 'package:shared_preferences/shared_preferences.dart'; // Mengimpor paket SharedPreferences untuk menyimpan data secara lokal.
import 'dart:convert'; // Mengimpor paket Dart untuk mengonversi data JSON.
import 'menu_makanan.dart'; // Mengimpor file menu_makanan.dart untuk navigasi setelah login.

class LoginPage extends StatefulWidget { // Mendefinisikan kelas LoginPage sebagai StatefulWidget.
  @override
  _LoginPageState createState() => _LoginPageState(); // Membuat state untuk LoginPage.
}

class _LoginPageState extends State<LoginPage> { // Mendefinisikan state untuk LoginPage.
  final TextEditingController _usernameController = TextEditingController(); // Membuat controller untuk input username.
  final TextEditingController _passwordController = TextEditingController(); // Membuat controller untuk input password.
  bool _isLoading = false; // Variabel untuk menandai apakah sedang dalam proses login.

  Future<void> _login() async { // Fungsi untuk melakukan login.
    setState(() {
      _isLoading = true; // Menandai bahwa proses login sedang berlangsung.
    });

    final response = await http.post( // Melakukan permintaan POST ke server.
      Uri.parse('http://127.0.0.1:8000/api/token/'), // URL endpoint untuk login.
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8', // Header untuk permintaan HTTP.
      },
      body: jsonEncode(<String, String>{ // Mengonversi data username dan password ke format JSON.
        'username': _usernameController.text, // Mengambil nilai dari input username.
        'password': _passwordController.text, // Mengambil nilai dari input password.
      }),
    );

    if (response.statusCode == 200) { // Jika login berhasil (status code 200).
      final data = jsonDecode(response.body); // Mengonversi respons JSON ke Map.
      final String token = data['access']; // Mengambil token dari respons.

      // Menyimpan token ke SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);

      // Navigasi ke halaman MenuMakanan
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MenuMakanan()),
      );
    } else { // Jika login gagal.
      // Menampilkan pesan error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed')),
      );
    }

    setState(() {
      _isLoading = false; // Menandai bahwa proses login telah selesai.
    });
  }

  @override
  Widget build(BuildContext context) { // Fungsi untuk membangun antarmuka pengguna.
    return Scaffold(
      backgroundColor: Colors.orange[50], // Mengatur warna latar belakang.
      appBar: AppBar(
        backgroundColor: Colors.orange, // Mengatur warna AppBar.
        title: Text('Login'), // Mengatur judul AppBar.
        centerTitle: true, // Mengatur judul di tengah.
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0), // Mengatur padding.
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Mengatur posisi kolom di tengah.
            children: <Widget>[
              Icon(
                Icons.lock, // Menampilkan ikon kunci.
                size: 100,
                color: Colors.orange,
              ),
              SizedBox(height: 20), // Menambahkan jarak.
              Text(
                'Welcome Back', // Menampilkan teks selamat datang.
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
              SizedBox(height: 20), // Menambahkan jarak.
              Container(
                decoration: BoxDecoration(
                  color: Colors.white, // Mengatur warna latar belakang.
                  borderRadius: BorderRadius.circular(10), // Mengatur sudut border.
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.withOpacity(0.2), // Mengatur bayangan.
                      spreadRadius: 2,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: TextField(
                  controller: _usernameController, // Menghubungkan controller username.
                  decoration: InputDecoration(
                    labelText: 'Username', // Label untuk input username.
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: Icon(Icons.person), // Ikon di depan input.
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 20), // Menambahkan jarak.
              Container(
                decoration: BoxDecoration(
                  color: Colors.white, // Mengatur warna latar belakang.
                  borderRadius: BorderRadius.circular(10), // Mengatur sudut border.
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.withOpacity(0.2), // Mengatur bayangan.
                      spreadRadius: 2,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: TextField(
                  controller: _passwordController, // Menghubungkan controller password.
                  decoration: InputDecoration(
                    labelText: 'Password', // Label untuk input password.
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: Icon(Icons.lock), // Ikon di depan input.
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  obscureText: true, // Menyembunyikan teks input.
                ),
              ),
              SizedBox(height: 20), // Menambahkan jarak.
              _isLoading
                  ? CircularProgressIndicator() // Menampilkan indikator loading jika sedang login.
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _login, // Menghubungkan tombol dengan fungsi login.
                        child: Text('Login'), // Teks pada tombol.
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange, // Mengatur warna tombol.
                          padding: EdgeInsets.symmetric(vertical: 15), // Mengatur padding tombol.
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10), // Mengatur sudut tombol.
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
