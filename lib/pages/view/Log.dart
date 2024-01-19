import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cucimobil_app/pages/theme/coloring.dart';
import 'package:flutter/material.dart';

class Log extends StatefulWidget {
  const Log({super.key});

  @override
  State<Log> createState() => _LogState();
}

class _LogState extends State<Log> {
  final CollectionReference logsCollection =
      FirebaseFirestore.instance.collection('logs');
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
            'Log',
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
                  'All Log',
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
              stream: logsCollection.snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                final List<DocumentSnapshot> logs = snapshot.data!.docs;

                final filteredlogs = searchQuery.isEmpty
                    ? logs
                    : logs.where((logs) {
                        final name = logs['userName'].toString().toLowerCase();
                        return name.contains(searchQuery);
                      }).toList();
                if (filteredlogs.isEmpty) {
                  return Center(
                    child: Text(
                      'Log tidak ditemukan',
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: filteredlogs.length,
                  itemBuilder: (context, index) {
                    var logsData =
                        filteredlogs[index].data() as Map<String, dynamic>;
                    String name = logsData['userName'];
                    String activity = logsData['activity'];

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
                                      Icons.history,
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
                                        name,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: "Poppins",
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        activity,
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
    );
  }
}
