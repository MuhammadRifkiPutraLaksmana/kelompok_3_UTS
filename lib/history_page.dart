import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<Map<String, dynamic>> _purchaseHistory = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  void _loadHistory() async {
    final url = Uri.parse('http://127.0.0.1:8000/api/purchase-history/');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        _purchaseHistory = data.map((item) => Map<String, dynamic>.from(item)).toList();
      });
      print('Histori diambil: $_purchaseHistory');
    } else {
      print('Gagal mengambil histori: ${response.statusCode}');
    }
  }

  void _clearHistory() async {
    final url = Uri.parse('http://127.0.0.1:8000/api/purchase-history/delete-all/');

    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 204) {
      setState(() {
        _purchaseHistory = [];
      });
      print('Histori dihapus');
    } else {
      print('Gagal menghapus histori: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[50],
      appBar: AppBar(
        title: Text('Histori Pembelian'),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: _clearHistory,
          ),
        ],
      ),
      body: _purchaseHistory.isEmpty
          ? Center(
              child: Text(
                'Tidak ada histori pembelian.',
                style: TextStyle(fontSize: 18.0, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: _purchaseHistory.length,
              itemBuilder: (context, index) {
                final item = _purchaseHistory[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  elevation: 5,
                  child: ListTile(
                    contentPadding: EdgeInsets.all(10.0),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        item['image'],
                        width: 60.0,
                        height: 60.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(
                      item['title'],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      item['price'],
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
