import 'package:flutter/material.dart';

class DetailProduk extends StatefulWidget {
  final Map ListData;
  DetailProduk({Key? key, required this.ListData}) : super(key: key);

  @override
  State<DetailProduk> createState() => _DetailProdukState();
}

class _DetailProdukState extends State<DetailProduk> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Produk'),
        backgroundColor:Color.fromARGB(255, 0, 140, 255), // Ubah warna latar belakang appbar
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Card(
          elevation: 12,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DetailItem(title: 'ID Produk', subtitle: widget.ListData['id_produk']),
                DetailItem(title: 'Nama Produk', subtitle: widget.ListData['nama_produk']),
                DetailItem(title: 'Harga Produk', subtitle: widget.ListData['harga_produk']),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DetailItem extends StatelessWidget {
  final String title;
  final String subtitle;

  DetailItem({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold, // Teks tebal
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(
              fontStyle: FontStyle.italic, // Teks miring
              color: Colors.grey[700], // Warna teks abu-abu
            ),
          ),
        ],
      ),
    );
  }
}
