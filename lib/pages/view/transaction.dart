import 'package:cucimobil_app/pages/theme/coloring.dart';
import 'package:cucimobil_app/pages/detail/transactions_detail.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:cucimobil_app/model/Transaction.dart';
import 'package:cucimobil_app/pages/create/transactions_create.dart';

class Transactions extends StatefulWidget {
  const Transactions({super.key});

  @override
  State<Transactions> createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {
  final currencyFormatter =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');
  final CollectionReference transaksiCollection =
      FirebaseFirestore.instance.collection('transactions');
  var searchQuery = '';

  DateTime? selectedDate;
  List<DocumentSnapshot> transaksiList = [];
  List<DocumentSnapshot> filteredTransaksi = [];

  @override
  void initState() {
    super.initState();
    getTransaksi();
  }

  void queryProduk(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
      cariTransaksi();
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
        cariTransaksi();
      });
    }
  }

  void getTransaksi() {
    transaksiCollection.snapshots().listen((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        setState(() {
          transaksiList = snapshot.docs;
          cariTransaksi();
        });
      } else {
        setState(() {
          transaksiList = [];
          filteredTransaksi = [];
        });
      }
    }, onError: (error) {
      print('Error getting transaksi: $error');
    });
  }

  void cariTransaksi() {
    filteredTransaksi = transaksiList.where((transactions) {
      final namapelanggan =
          transactions['namapelanggan'].toString().toLowerCase();
      final tanggalTransaksiString = transactions['created_at'];
      final tanggalTransaksi = DateTime.parse(tanggalTransaksiString);

      final isTanggalSelected = selectedDate != null
          ? (tanggalTransaksi.day == selectedDate!.day &&
              tanggalTransaksi.month == selectedDate!.month &&
              tanggalTransaksi.year == selectedDate!.year)
          : true;

      return namapelanggan.contains(searchQuery) && isTanggalSelected;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: warna.background,
      appBar: AppBar(
        backgroundColor: warna.appbar,
        automaticallyImplyLeading: false,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15), // Atur nilai sesuai keinginan
          ),
        ),
        title: Center(
          child: Text(
            'Transaksi',
            style: TextStyle(
              fontFamily: 'OpenSans',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: warna.putih,
            ),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  onChanged: (value) {
                    queryProduk(value);
                  },
                  style: TextStyle(
                    color: Colors.black54,
                    fontFamily: 'Poppins',
                  ),
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: 'Search',
                    labelStyle: TextStyle(
                      color: Colors.black,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: IconButton(
                        onPressed: () {
                          _selectDate(context);
                        },
                        icon: Icon(
                          Icons.date_range,
                          color: warna.ungu,
                        ),
                      ),
                    ),
                    Text(
                      "Filtering by Tanggal",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  'All Transaksi',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
          Expanded(
            child: filteredTransaksi.isEmpty
                ? Center(
                    child: Column(
                      children: [
                        SizedBox(height: 100),
                        Icon(
                          Icons.sentiment_dissatisfied_outlined,
                          size: 50,
                          color: warna.ungu,
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Transaksi tidak ditemukan',
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredTransaksi.length,
                    itemBuilder: (context, index) {
                      var transaksiData = filteredTransaksi[index].data()
                          as Map<String, dynamic>;
                      String namapelanggan = transaksiData['namapelanggan'];
                      String namaproduk = transaksiData['namaproduk'];
                      int qty = transaksiData['qty'];
                      double uangbayar =
                          transaksiData['uangbayar']?.toDouble() ?? 0.0;
                      double totalbelanja =
                          transaksiData['totalbelanja']?.toDouble() ?? 0.0;

                      return GestureDetector(
                        child: Container(
                          margin:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white,
                          ),
                          padding: const EdgeInsets.all(20),
                          height: 94,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(width: 10),
                              Expanded(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // Circle with shopping icon
                                    Container(
                                      margin: EdgeInsets.only(right: 8.0),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        color: warna.ungu,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                      ),
                                      padding: EdgeInsets.all(8.0),
                                      child: Icon(
                                        Icons.swap_horizontal_circle,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          namapelanggan,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: "Poppins",
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          "$namaproduk x $qty",
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey,
                                            fontFamily: "Poppins",
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 10),
                              IconButton(
                                onPressed: () {
                                  Get.to(() => TransaksiDetail(), arguments: {
                                    'id': filteredTransaksi[index].id,
                                    'namapelanggan': namapelanggan,
                                    'namaproduk': namaproduk,
                                    'qty': qty,
                                    'uangbayar': uangbayar,
                                    'totalbelanja': totalbelanja,
                                  });
                                },
                                icon: Icon(Icons.more_horiz),
                                color: warna.ungu,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: warna.ungu,
        onPressed: () {
          Get.to(() => TransactionsCreate());
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
