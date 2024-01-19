import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cucimobil_app/controller/logController.dart';
import 'package:cucimobil_app/controller/transactionController.dart';
import 'package:cucimobil_app/pages/theme/coloring.dart';
import 'package:cucimobil_app/pages/view/transaction.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TransaksiDetail extends StatefulWidget {
  @override
  State<TransaksiDetail> createState() => _TransaksiDetailState();
}

class _TransaksiDetailState extends State<TransaksiDetail> {
  final currencyFormatter =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');
  String? _selectedProduct;
  List<String> produkList = [];
  double hargaproduk = 0.0;
  double totalbelanja = 0.0;

  final TextEditingController _namaPelangganController =
      TextEditingController();
  final TextEditingController _qtyController = TextEditingController();
  final TextEditingController _uangBayarController = TextEditingController();
  final TextEditingController _hargaProdukController = TextEditingController();
  final LogController logController = LogController();

  @override
  void initState() {
    super.initState();
    fetchProducts();
    final Map<String, dynamic>? args = Get.arguments;
    _selectedProduct = args?['namaproduk'] ?? null;
    if (_selectedProduct != null) {
      fetchBookPrice(_selectedProduct);
      calculateTotalBelanja(); // Panggil calculateTotalBelanja di initState
    }
  }

  Future<void> fetchBookPrice(String? selectedBook) async {
    if (selectedBook != null) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('products')
          .where('namaproduk', isEqualTo: selectedBook)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        double hargaProduk = querySnapshot.docs.first['hargaproduk'];

        setState(() {
          hargaproduk =
              hargaProduk; // Perbaiki inisialisasi hargaproduk di sini
          _hargaProdukController.text = currencyFormatter.format(hargaProduk);
          calculateTotalBelanja(); // Hitung total belanja setelah hargaproduk berubah
        });
      }
    } else {
      setState(() {
        hargaproduk = 0.0;
        _hargaProdukController.text = '';
        calculateTotalBelanja(); // Hitung total belanja saat produk dihapus
      });
    }
  }

  void calculateTotalBelanja() {
    int qty = int.tryParse(_qtyController.text) ?? 0;
    setState(() {
      totalbelanja = hargaproduk * qty;
    });
  }

  final TransaksiController _transaksiController =
      Get.put(TransaksiController());

  Future<void> updateTransaction() async {
    String id = Get.arguments['id'];
    String namapelanggan = _namaPelangganController.text.trim();
    int qty = int.tryParse(_qtyController.text.trim()) ?? 0;
    double uangbayar = double.tryParse(
            _uangBayarController.text.replaceAll(RegExp('[^0-9]'), '')) ??
        0;
    double totalbelanja = hargaproduk * qty;
    double uangkembali = uangbayar - totalbelanja;
    String updated_at = DateTime.now().toString();

    if (_selectedProduct != null &&
        qty > 0 &&
        uangbayar > 0 &&
        namapelanggan.isNotEmpty &&
        uangbayar >= totalbelanja) {
      await _transaksiController.updateTransaksi(
          id,
          namapelanggan,
          _selectedProduct!,
          hargaproduk,
          qty,
          uangbayar,
          totalbelanja,
          uangkembali,
          updated_at);

      _namaPelangganController.clear();
      _qtyController.clear();
      _uangBayarController.clear();
      _hargaProdukController.clear();
      setState(() {
        _selectedProduct = null;
      });

      Get.back();
      Get.snackbar('Success', 'Transaksi updated successfully!');
    } else {
      Get.snackbar('Failed', 'Failed update transaksi gagal!');
    }
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
    final Map<String, dynamic>? args = Get.arguments;
    final String id = args?['id'] ?? '';
    final String namapelanggan = args?['namapelanggan'] ?? '';
    final double uangbayar = args?['uangbayar'] ?? 0.0;
    final int qty = args?['qty'] ?? 0;

    _namaPelangganController.text = namapelanggan;
    _qtyController.text = qty.toString();
    _uangBayarController.text = uangbayar.toStringAsFixed(0);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          color: Colors.black,
          icon: Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            Get.back();
          },
        ),
        elevation: 0,
        backgroundColor: warna.background,
        title: Text(
          'Form Transaksi',
          style: TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        color: warna.background,
        padding: const EdgeInsets.all(20),
        child: ListView(
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
            SizedBox(height: 20),
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
            SizedBox(height: 20),
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
            SizedBox(height: 20),
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
            SizedBox(height: 20),
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
                    "${currencyFormatter.format(totalbelanja)}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  updateTransaction();
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
            SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  bool success = await _transaksiController.deleteTransaksi(id);
                  if (success) {
                    _transaksiController.shouldUpdate.value = true;

                    Get.back();
                    Get.snackbar(
                        'Success', 'Transaction deleted successfully!');
                    _addLog("Deleted transaction with title: $namapelanggan");
                  } else {
                    Get.snackbar('Failed', 'Failed to delete transaction');
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(
                      255, 255, 255, 255), // Set background color to orange
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    side: BorderSide(
                      color: warna.ungu, // Set border color
                      width: 2.0, // Set border width
                    ),
                    // Set border radius to 25%
                  ),
                  minimumSize:
                      Size(double.infinity, 50.0), // Set the height to 50.0
                ),
                child: Text(
                  "Delete",
                  style: TextStyle(
                    color: warna.ungu, // Set text color to white
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
    int qty = int.tryParse(_qtyController.text) ?? 0;
    totalbelanja = hargaproduk * qty;
    setState(() {
      totalbelanja = totalbelanja;
    });
  }

  Future<void> _addLog(String activity) async {
    try {
      await logController.addLog(activity);
      print('Log added successfully!');
    } catch (e) {
      print('Failed to add log: $e');
    }
  }
}
