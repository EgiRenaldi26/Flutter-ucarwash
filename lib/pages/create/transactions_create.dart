import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cucimobil_app/controller/logController.dart';
import 'package:cucimobil_app/model/Transaction.dart';
import 'package:cucimobil_app/controller/transactionController.dart';
import 'package:cucimobil_app/pages/succestransaction.dart';
import 'package:cucimobil_app/pages/view/transaction.dart';
import 'package:cucimobil_app/pages/theme/coloring.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TransactionsCreate extends StatefulWidget {
  const TransactionsCreate({super.key});

  @override
  State<TransactionsCreate> createState() => _TransactionsCreateState();
}

class _TransactionsCreateState extends State<TransactionsCreate> {
  final TransaksiController _transaksiController =
      Get.put(TransaksiController());
  final currencyFormatter =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');
  String? _selectedProduct;
  List<String> produkList = [];
  double _hargaProduk = 0.0;
  double _totalBelanja = 0.0;

  final TextEditingController _namaPelangganController =
      TextEditingController();
  final TextEditingController _qtyController = TextEditingController();
  final TextEditingController _uangBayarController = TextEditingController();
  final TextEditingController _hargaProdukController = TextEditingController();
  final LogController logController = LogController();

  void calculateTotalBelanja() {
    int qty = int.tryParse(_qtyController.text) ?? 0;
    setState(() {
      _totalBelanja = _hargaProduk * qty;
    });
  }

  void fetchBookPrice(String? selectedBook) async {
    if (selectedBook != null) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('products')
          .where('namaproduk', isEqualTo: selectedBook)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        double hargaproduk = querySnapshot.docs.first['hargaproduk'];

        setState(() {
          _hargaProduk = hargaproduk;
          _hargaProdukController.text =
              "Rp. ${_hargaProduk.toStringAsFixed(2)}";
        });
      }
    } else {
      setState(() {
        _hargaProduk = 0.0;
        _hargaProdukController.text = '';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('products').get();

    setState(() {
      produkList = querySnapshot.docs
          .map((doc) => doc['namaproduk'])
          .toList()
          .cast<String>();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: warna.background,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            Get.back();
          },
        ),
        title: Center(
          child: Text(
            "Form Transaksi",
            style:
                TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
          ),
        ),
      ),
      body: Container(
        color: warna.background,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _namaPelangganController,
              decoration: InputDecoration(
                hintText: 'Exm. Renaldi Nurmazid',
                label: Text(
                  'Nama Pembeli',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    fontFamily: 'Poppins',
                  ),
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              width: double.infinity,
              padding: EdgeInsets.all(10),
              height: 50,
              child: DropdownButton<String>(
                hint: Text('Pilih Produk'),
                value: _selectedProduct,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedProduct = newValue;
                    fetchBookPrice(newValue);
                  });
                },
                dropdownColor: Colors
                    .white, // Atur warna dropdown sesuai dengan latar belakang Container
                items: produkList.map<DropdownMenuItem<String>>(
                  (String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  },
                ).toList(),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: _hargaProdukController,
              enabled: false,
              decoration: InputDecoration(
                hintText: 'Exm. Rp. 100.000',
                label: Text(
                  'Harga Produk',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    fontFamily: 'Poppins',
                  ),
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: _qtyController,
              keyboardType: TextInputType.number,
              onChanged: (value) {
                calculateTotalBelanja(); // Panggil calculateTotalBelanja ketika _qtyController berubah
              },
              decoration: InputDecoration(
                hintText: 'Exm. 50',
                label: Text(
                  'QTY',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    fontFamily: 'Poppins',
                  ),
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: _uangBayarController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Exm. Rp. 100.000',
                label: Text(
                  'Uang Bayar',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    fontFamily: 'Poppins',
                  ),
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total Belanja",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    "${currencyFormatter.format(_totalBelanja)}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  String namapembeli = _namaPelangganController.text.trim();
                  int qty = int.tryParse(_qtyController.text.trim()) ?? 0;
                  double uangbayar = double.tryParse(_uangBayarController.text
                          .replaceAll(RegExp('[^0-9]'), '')) ??
                      0;

                  if (_selectedProduct != null &&
                      qty > 0 &&
                      uangbayar > 0 &&
                      namapembeli.isNotEmpty &&
                      uangbayar >= _totalBelanja) {
                    double totalbelanja = _hargaProduk * qty;
                    double uangkembali = uangbayar - totalbelanja;

                    int _nomorunik = Random().nextInt(1000000000);
                    String created_at = DateTime.now().toString();
                    String updated_at = DateTime.now().toString();

                    TransactionsM newTransaksi = TransactionsM(
                      nomorunik: _nomorunik,
                      namapelanggan: namapembeli,
                      namaproduk: _selectedProduct!,
                      hargaproduk: _hargaProduk,
                      qty: qty,
                      uangbayar: uangbayar,
                      totalbelanja: totalbelanja,
                      uangkembali: uangkembali,
                      created_at: created_at,
                      updated_at: updated_at,
                    );
                    _addLog("Updated book with title: $namapembeli");
                    Get.to(() => TransaksiSukses(
                          nomorunik: _nomorunik,
                          namapelanggan: namapembeli,
                          namabarang: _selectedProduct!,
                          hargasatuan: _hargaProduk,
                          qty: qty,
                          totalbelanja: totalbelanja,
                          uangbayar: uangbayar,
                          uangkembali: uangkembali,
                          created_at: created_at,
                        ));

                    Get.snackbar('Success', 'Transaksi added successfully');

                    bool success =
                        await _transaksiController.addTransaksi(newTransaksi);

                    if (success) {
                      _namaPelangganController.clear();
                      _qtyController.clear();
                      _uangBayarController.clear();
                      _hargaProdukController.clear();
                      _totalBelanja = 0;
                      setState(() {
                        _selectedProduct = null;
                      });
                    } else {
                      print('Failed to add transaction to the database');
                    }
                  } else {
                    Get.snackbar(
                        'Failed', 'Silakan periksa kembali transaksi.');
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: warna.ungu, // Set background color to orange
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    // Set border radius to 25%
                  ),
                  minimumSize:
                      Size(double.infinity, 50.0), // Set the height to 50.0
                ),
                child: Text(
                  "Submit",
                  style: TextStyle(
                    color: Colors.white, // Set text color to white
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void updateTotalBelanja() {
    double hargaProduk = _hargaProduk;
    int qty = int.tryParse(_qtyController.text) ?? 0;
    double totalBelanja = hargaProduk * qty;

    setState(() {
      _totalBelanja = totalBelanja;
    });
  }

  Future<void> _addLog(String activity) async {
    try {
      await logController
          .addLog(activity); // Menambahkan log saat tombol ditekan
      print('Log added successfully!');
    } catch (e) {
      print('Failed to add log: $e');
    }
  }
}
