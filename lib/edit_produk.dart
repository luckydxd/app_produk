import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:app_produk/halaman_produk.dart';

class UbahProduk extends StatefulWidget {
  final Map ListData;
  const UbahProduk({Key? key, required this.ListData});

  @override
  State<UbahProduk> createState() => _UbahProdukState();
}

class _UbahProdukState extends State<UbahProduk> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _namaProdukController = TextEditingController();
  final TextEditingController _hargaProdukController = TextEditingController();

  Future<bool> _ubah() async {
    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1/api_produk/edit.php'),
        body: {
          'id_produk': widget.ListData['id_produk'],
          'nama_produk': _namaProdukController.text,
          'harga_produk': _hargaProdukController.text,
        },
      );
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    _namaProdukController.text = widget.ListData['nama_produk'];
    _hargaProdukController.text = widget.ListData['harga_produk'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ubah Produk'),
        backgroundColor: Color.fromARGB(255, 0, 140, 255), // Ubah warna latar belakang appbar
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _namaProdukController,
                  decoration: InputDecoration(
                    labelText: 'Nama Produk',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Nama Produk tidak boleh kosong!';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _hargaProdukController,
                  decoration: InputDecoration(
                    labelText: 'Harga Produk',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Harga Produk tidak boleh kosong!';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _ubah().then((success) {
                        final snackBar = SnackBar(
                          content: Text(
                            success ? 'Data Berhasil Diubah' : 'Gagal mengubah data',
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        if (success) {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => HalamanProduk()),
                            (route) => false,
                          );
                        }
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 0, 140, 255), // Ubah warna latar belakang tombol
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text('Ubah'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
