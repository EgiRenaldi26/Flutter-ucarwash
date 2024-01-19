import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cucimobil_app/pages/create/product_create.dart';
import 'package:cucimobil_app/pages/detail/product_detail.dart';
import 'package:cucimobil_app/pages/theme/coloring.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class Product extends StatefulWidget {
  const Product({super.key});

  @override
  State<Product> createState() => _ProductState();
}

class _ProductState extends State<Product> {
  final currencyFormatter =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');
  final CollectionReference productsCollection =
      FirebaseFirestore.instance.collection('products');
  var refreshFlag = false;
  var searchQuery = '';

  void queryProduk(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
    });
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
            'Produk',
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
                Text(
                  'All Produk',
                  textAlign: TextAlign.left,
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
            child: StreamBuilder<QuerySnapshot>(
              stream: productsCollection.snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                final List<DocumentSnapshot> products = snapshot.data!.docs;

                final filteredProducts = searchQuery.isEmpty
                    ? products
                    : products.where((products) {
                        final namaproduk =
                            products['namaproduk'].toString().toLowerCase();
                        return namaproduk.contains(searchQuery);
                      }).toList();
                if (filteredProducts.isEmpty) {
                  return Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.sentiment_dissatisfied_outlined,
                          size: 50,
                          color: warna.ungu,
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Produk tidak ditemukan',
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: filteredProducts.length,
                  itemBuilder: (context, index) {
                    var productsData =
                        filteredProducts[index].data() as Map<String, dynamic>;
                    String nama_produk =
                        productsData['namaproduk'] ?? 'No Name';
                    double harga_produk =
                        productsData['hargaproduk']?.toDouble() ?? 0.0;
                    String formattedPrice =
                        currencyFormatter.format(harga_produk);

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
                                    margin: EdgeInsets.only(
                                        right:
                                            8.0), // Adjust the margin as needed
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: warna
                                          .ungu, // You can change the color as desired
                                    ),
                                    padding: EdgeInsets.all(
                                        8.0), // Adjust the padding as needed
                                    child: Icon(
                                      Icons.car_crash_rounded,
                                      color: Colors
                                          .white, // You can change the color as desired
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        nama_produk,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: "Poppins",
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        formattedPrice,
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
                                Get.to(() => ProductDetail(), arguments: {
                                  'id': filteredProducts[index].id,
                                  'namaproduk': nama_produk,
                                  'hargaproduk': harga_produk,
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
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: warna.ungu,
        onPressed: () {
          Get.to(() => ProductCreate());
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
