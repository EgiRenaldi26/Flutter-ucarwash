import 'package:cucimobil_app/controller/AuthController.dart';
import 'package:cucimobil_app/controller/logController.dart';
import 'package:cucimobil_app/controller/productController.dart';
import 'package:cucimobil_app/controller/transactionController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final AuthController _authController = Get.find<AuthController>();
  final ProductController _productController = Get.put(ProductController());
  final AuthController _userController = Get.put(AuthController());
  final LogController _logController = Get.put(LogController());
  final TransaksiController _transaksiController =
      Get.put(TransaksiController());

  @override
  Widget build(BuildContext context) {
    UserRole currentUserRole = _authController.getCurrentUserRole();
    return Scaffold(
      backgroundColor: Colors.purple.shade50,
      appBar: AppBar(
        backgroundColor: Colors.purple.shade50,
        title: Center(
          child: Text(
            "Dashboard",
            style: TextStyle(
                fontSize: 16,
                fontFamily: "Poppins",
                fontWeight: FontWeight.bold),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.person_outline,
              color: Colors.purple,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              onPressed: () {
                _authController.signOut();
              },
              icon: Icon(Icons.logout),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "List Menu",
              style: TextStyle(
                fontFamily: "Poppins",
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),

            // Hak Akses Untuk Admin
            if (currentUserRole == UserRole.Admin) ...[
              FutureBuilder<int>(
                future: ProductController()
                    .countProducts(), // Change to direct instantiation
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    int productsCount = snapshot.data ?? 0;
                    return DashboardList(
                      title: 'Data Products',
                      icon: Icons.car_crash_rounded,
                      dataCount: productsCount,
                    );
                  }
                },
              ),
              SizedBox(
                height: 15,
              ),
              FutureBuilder<int>(
                future: AuthController()
                    .countUser(), // Change to direct instantiation
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    int usersCount = snapshot.data ?? 0;
                    return DashboardList(
                      title: 'Data Users',
                      icon: Icons.person_2,
                      dataCount: usersCount,
                    );
                  }
                },
              ),
            ],
            // Hak Akses Untuk Kasir
            if (currentUserRole == UserRole.Kasir) ...[
              FutureBuilder<int>(
                future: TransaksiController()
                    .countTransactions(), // Change to direct instantiation
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    int transcrionsCount = snapshot.data ?? 0;
                    return DashboardList(
                      title: 'Data Transaksi',
                      icon: Icons.swap_horizontal_circle,
                      dataCount: transcrionsCount,
                    );
                  }
                },
              ),
            ],

            // Hak Akses Untuk Kasir
            if (currentUserRole == UserRole.Owner) ...[
              FutureBuilder<int>(
                future: TransaksiController()
                    .countTransactions(), // Change to direct instantiation
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    int transcrionsCount = snapshot.data ?? 0;
                    return DashboardList(
                      title: 'Data Transaksi',
                      icon: Icons.swap_horizontal_circle,
                      dataCount: transcrionsCount,
                    );
                  }
                },
              ),
              SizedBox(
                height: 15,
              ),
              FutureBuilder<int>(
                future: LogController()
                    .countLog(), // Change to direct instantiation
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    int logCount = snapshot.data ?? 0;
                    return DashboardList(
                      title: 'Data Log',
                      icon: Icons.history,
                      dataCount: logCount,
                    );
                  }
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class DashboardList extends StatelessWidget {
  final String title;
  final IconData icon; // Change from String to IconData
  final int dataCount;

  const DashboardList({
    required this.title,
    required this.icon,
    required this.dataCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      height: 80,
      width: 340,
      decoration: BoxDecoration(
        color: Color(0xFF573F7B),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(color: Colors.white),
        ),
        subtitle: Text(
          dataCount.toString(),
          style: TextStyle(color: Colors.white),
        ),
        trailing: Icon(
          icon,
          size: 42,
          color: Colors.white,
        ),
      ),
    );
  }
}
