import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cucimobil_app/pages/create/product_create.dart';
import 'package:cucimobil_app/pages/create/users_create.dart';
import 'package:cucimobil_app/pages/detail/product_detail.dart';
import 'package:cucimobil_app/pages/detail/user_detail.dart';
import 'package:cucimobil_app/pages/theme/coloring.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class User extends StatefulWidget {
  const User({super.key});

  @override
  State<User> createState() => _UserState();
}

class _UserState extends State<User> {
  final currencyFormatter =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');
  final CollectionReference UsersCollection =
      FirebaseFirestore.instance.collection('users');
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
            'Users',
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
                  'All User',
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
            child: StreamBuilder<QuerySnapshot>(
              stream: UsersCollection.snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                final List<DocumentSnapshot> users = snapshot.data!.docs;

                final filteredusers = searchQuery.isEmpty
                    ? users
                    : users.where((users) {
                        final username =
                            users['username'].toString().toLowerCase();
                        return username.contains(searchQuery);
                      }).toList();
                if (filteredusers.isEmpty) {
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
                          'Users tidak ditemukan',
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
                  itemCount: filteredusers.length,
                  itemBuilder: (context, index) {
                    var usersData =
                        filteredusers[index].data() as Map<String, dynamic>;
                    String username = usersData['username'] ?? 'No Name';
                    String nama = usersData['name'] ?? 'No Name';
                    String role = usersData['role'];

                    return GestureDetector(
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white,
                        ),
                        padding: const EdgeInsets.all(20),
                        height: 110,
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
                                      Icons.person_2_rounded,
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
                                        nama,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: "Poppins",
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        username,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                          fontFamily: "Poppins",
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        role,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                          fontFamily: "Poppins",
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 10),
                            IconButton(
                              onPressed: () {
                                Get.to(() => UserDetail(), arguments: {
                                  'id': filteredusers[index].id,
                                  'username': username,
                                  'name': nama,
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
          Get.to(() => UserCreate());
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
