import 'package:flutter/material.dart';

// Kelas ProfilPage yang merupakan StatelessWidget, artinya tidak memiliki state yang berubah.
class ProfilPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Scaffold memberikan struktur dasar untuk layar aplikasi.
    return Scaffold(
      // AppBar menampilkan bar di bagian atas dengan judul dan styling.
      appBar: AppBar(
        title: Text(
          'Profil', // Judul AppBar
          style: TextStyle(
            fontFamily: 'Poppins', // Font keluarga yang digunakan
            fontWeight: FontWeight.bold, // Ketebalan font
            color: Colors.white, // Warna teks
          ),
        ),
        centerTitle: true, // Judul di tengah AppBar
        backgroundColor: Colors.deepOrange, // Warna latar AppBar
      ),
      // Body dari Scaffold yang menggunakan SingleChildScrollView untuk mengizinkan pengguliran.
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0), // Padding di sekitar kolom
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Rata kiri untuk teks dan widget
            children: [
              Center(
                // CircleAvatar untuk menampilkan gambar profil.
                child: CircleAvatar(
                  radius: 70.0, // Ukuran radius avatar
                  backgroundImage: AssetImage('assets/orang1.jpeg'), // Sumber gambar dari assets
                  backgroundColor: Colors.deepOrange.shade100, // Warna latar belakang avatar
                ),
              ),
              SizedBox(height: 20.0), // Jarak antar elemen
              // Memanggil fungsi _buildInfoField untuk setiap field informasi.
              _buildInfoField(
                label: 'Nama', // Label
                value: 'Putra', // Nilai
              ),
              _buildInfoField(
                label: 'Email',
                value: 'putra@email.com',
              ),
              _buildInfoField(
                label: 'Nomor Telepon',
                value: '+62 812 3456 7890',
              ),
              _buildInfoField(
                label: 'Alamat',
                value: 'Jl. Ir. H. Juanda ',
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Fungsi _buildInfoField untuk membangun widget yang menampilkan label dan nilai.
  Widget _buildInfoField({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // Rata kiri
      children: [
        Text(
          label, // Teks label
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 18.0, // Ukuran font
            fontWeight: FontWeight.bold, // Ketebalan font
            color: Colors.deepOrange, // Warna teks
          ),
        ),
        SizedBox(height: 8.0), // Jarak antar teks label dan field
        TextFormField(
          initialValue: value, // Nilai awal untuk field
          readOnly: true, // Field hanya untuk dibaca, tidak untuk di-edit
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16.0, // Ukuran font
            color: Colors.black54, // Warna teks
          ),
          decoration: InputDecoration(
            border: OutlineInputBorder(), // Border field
            isDense: true, // Kepadatan field
            contentPadding: EdgeInsets.all(12.0), // Padding dalam field
            fillColor: Colors.orange.shade50, // Warna latar field
            filled: true, // Field diisi dengan warna
          ),
        ),
        SizedBox(height: 16.0), // Jarak setelah field
      ],
    );
  }
}
