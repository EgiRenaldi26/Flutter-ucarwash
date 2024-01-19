import 'package:cucimobil_app/auth/Login.dart';
import 'package:cucimobil_app/controller/AuthController.dart';
import 'package:cucimobil_app/firebase_options.dart';
import 'package:cucimobil_app/pages/dashboard.dart';
import 'package:cucimobil_app/pages/splash.dart';
import 'package:cucimobil_app/pages/theme/coloring.dart';
import 'package:cucimobil_app/pages/view/Log.dart';
import 'package:cucimobil_app/pages/view/product.dart';
import 'package:cucimobil_app/pages/view/transaction.dart';
import 'package:cucimobil_app/pages/view/users.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print("Firebase initialized successfully!");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    Get.put(AuthController());
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: warna.ungu),
        scaffoldBackgroundColor: warna.background,
        appBarTheme: AppBarTheme(
          backgroundColor: warna.appbar,
        ),
        inputDecorationTheme: InputDecorationTheme(
          fillColor: warna.input,
        ),
        useMaterial3: true,
      ),
      initialRoute: '/splash',
      getPages: [
        GetPage(name: '/splash', page: () => Splash()),
        GetPage(name: '/login', page: () => Login()),
        GetPage(name: '/dashboard', page: () => MyHomePage()),
        GetPage(name: '/produk', page: () => Product()),
        GetPage(name: '/transaksi', page: () => Transactions()),
        GetPage(name: '/users', page: () => User()),
        GetPage(name: '/log', page: () => Log()),
      ],
    );
  }
}

class MyHomePage extends StatelessWidget {
  final AuthController _authController = Get.find<AuthController>();

  final List<List<IconData>> _roleIcons = [
    [Icons.dashboard_outlined, Icons.person, Icons.car_crash_rounded],
    [Icons.dashboard_outlined, Icons.swap_horizontal_circle],
    [Icons.dashboard_outlined, Icons.swap_horizontal_circle, Icons.history],
    [
      Icons.dashboard_outlined,
      Icons.swap_horizontal_circle,
      Icons.car_crash_rounded,
      Icons.person_2_rounded,
      Icons.history
    ],
  ];

  final List<Widget> _adminOptions = <Widget>[
    Dashboard(),
    User(),
    Product(),
  ];

  final List<Widget> _kasirOptions = <Widget>[
    Dashboard(),
    Transactions(),
  ];

  final List<Widget> _ownerOptions = <Widget>[
    Dashboard(),
    Transactions(),
    Log(),
  ];

  final List<Widget> _defaultOptions = <Widget>[
    Dashboard(),
    Transactions(),
    Product(),
    User(),
    Log(),
  ];

  final RxInt _selectedIndex = 0.obs;

  void _onItemTapped(int index) {
    _selectedIndex.value = index;
  }

  @override
  Widget build(BuildContext context) {
    List<List<Widget>> rolesOptions = [
      _adminOptions,
      _kasirOptions,
      _ownerOptions,
      _defaultOptions,
    ];

    return Scaffold(
      body: Obx(() {
        final int roleIndex = _authController.getCurrentUserRole().index;
        final List<Widget> selectedOptions = rolesOptions[roleIndex];
        return selectedOptions[_selectedIndex.value];
      }),
      bottomNavigationBar: Obx(() {
        final int roleIndex = _authController.getCurrentUserRole().index;
        final List<Widget> selectedOptions = rolesOptions[roleIndex];
        final List<IconData> selectedIcons = _roleIcons[roleIndex];
        return CurvedNavigationBar(
          backgroundColor: warna.putih,
          items: List.generate(selectedOptions.length, (index) {
            return Icon(
              selectedIcons[index],
              size: 30,
              color: warna.ungu,
            );
          }),
          onTap: _onItemTapped,
          index: _selectedIndex.value,
        );
      }),
    );
  }
}
