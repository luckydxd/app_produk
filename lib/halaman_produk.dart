import 'dart:convert';import 'package:app_produk/detail_produk.dart';
import 'package:app_produk/edit_produk.dart';
import 'package:app_produk/tambah_produk.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HalamanProduk extends StatefulWidget {
  const HalamanProduk({Key? key}) : super(key: key);

  @override
  State<HalamanProduk> createState() => _HalamanProdukState();
}

class _HalamanProdukState extends State<HalamanProduk> {
  List _listdata = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _getdata();
  }

  Future<void> _getdata() async {
    try {
      final response = await http.get(Uri.parse('http://127.0.0.1/api_produk/read.php'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _listdata = data;
          _loading = false;
        });
      } else {
        print('Failed to load data. Status code: ${response.statusCode}');
        setState(() {
          _loading = false;
        });
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        _loading = false;
      });
    }
  }

  Future<bool> _hapus(String idProduk) async {
    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1/api_produk/delete.php'),
        body: {"id_produk": idProduk},
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  void _deleteProduct(String idProduk) async {
    bool success = await _hapus(idProduk);
    if (success) {
      setState(() {
        _listdata.removeWhere((item) => item['id_produk'] == idProduk);
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Produk berhasil dihapus')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal menghapus produk')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Produk'),
        backgroundColor:Color.fromARGB(255, 0, 140, 255), // Ubah warna latar belakang appbar
      ),
      body: _loading 
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _listdata.length,
              itemBuilder: (context, index) {
                return Card(
                  child: InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => DetailProduk(
                        ListData: {
                          'id_produk':_listdata[index]['id_produk'],
                          'nama_produk':_listdata[index]['nama_produk'],
                          'harga_produk':_listdata[index]['harga_produk'],
                        },
                      )));
                    },
                    child: ListTile(
                      title: Text(
                        _listdata[index]['nama_produk'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold, // Teks tebal
                        ),
                      ),
                      subtitle: Text(
                        'Harga: ${_listdata[index]['harga_produk']}',
                        style: TextStyle(
                          fontStyle: FontStyle.italic, // Teks miring
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => UbahProduk(
                                ListData: {
                                  'id_produk':_listdata[index]['id_produk'],
                                  'nama_produk':_listdata[index]['nama_produk'],
                                  'harga_produk':_listdata[index]['harga_produk'],
                                },
                              )));
                            }, 
                            icon: Icon(Icons.edit)
                          ),
                          IconButton(
                            onPressed: () {
                              showDialog(context: context, 
                              barrierDismissible: false,
                              builder: ((context){
                                return AlertDialog(
                                  content: Text('Hapus data ini?'),
                                  actions: [
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(); // Tutup dialog
                                        _deleteProduct(_listdata[index]['id_produk']); // Hapus produk
                                      }, 
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:Color.fromARGB(255, 0, 140, 255), // Ubah warna latar belakang tombol
                                      ),
                                      child: Text('Hapus')
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(); // Tutup dialog
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:Color.fromARGB(255, 0, 140, 255), // Ubah warna latar belakang tombol
                                      ),
                                      child: Text('Batal')
                                    ),
                                  ],
                                );
                              }));
                            }, 
                            icon: Icon(Icons.delete)
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
floatingActionButton: FloatingActionButton(
  child: Icon(Icons.add),
  backgroundColor:Color.fromARGB(255, 0, 140, 255), 
  onPressed: () {
    print('FloatingActionButton clicked'); 
    Navigator.push(context, MaterialPageRoute(builder: (context) => TambahProduk()));
  },
),
); // menambahkan kurung penutup
  }
}