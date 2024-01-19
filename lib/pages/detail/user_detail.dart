import 'package:cucimobil_app/controller/AuthController.dart';
import 'package:cucimobil_app/controller/logController.dart';
import 'package:cucimobil_app/pages/theme/coloring.dart';
import 'package:cucimobil_app/pages/view/users.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserDetail extends StatefulWidget {
  const UserDetail({Key? key}) : super(key: key);

  @override
  State<UserDetail> createState() => _UserDetailState();
}

class _UserDetailState extends State<UserDetail> {
  final AuthController _authController = Get.put(AuthController());
  final TextEditingController nameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final LogController logController = LogController();

  String? _selectedRole;

  List<String> _roles = ['Admin', 'Kasir', 'Owner'];

  @override
  void initState() {
    super.initState();
    final Map<String, dynamic>? args = Get.arguments;
    _selectedRole = args?['role'] ?? null;
  }

  bool _isObscure = true;

  void togglePasswordVisibility() {
    setState(() {
      _isObscure = !_isObscure;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? args = Get.arguments;
    final String id = args?['id'] ?? '';
    final String name = args?['name'] ?? '';
    final String username = args?['username'] ?? '';
    final String password = args?['password'] ?? '';

    nameController.text = name;
    usernameController.text = username;
    passwordController.text = password;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: warna.background,
      appBar: AppBar(
        leading: IconButton(
          color: Colors.black,
          icon: Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            Get.back();
          },
        ),
        backgroundColor: warna.background,
        title: Text(
          'Form Users',
          style: TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: 'Exm. Renaldi Nurmazid',
                labelText: 'Nama Lengkap',
                labelStyle: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  fontFamily: 'Poppins',
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
              controller: usernameController,
              decoration: InputDecoration(
                hintText: 'Exm. Renaldi Nurmazid',
                labelText: 'Username',
                labelStyle: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  fontFamily: 'Poppins',
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
              controller: passwordController,
              obscureText: _isObscure,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: Icon(
                      _isObscure ? Icons.visibility : Icons.visibility_off),
                  onPressed: togglePasswordVisibility,
                ),
                hintText: '***',
                labelText: 'Password',
                labelStyle: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  fontFamily: 'Poppins',
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
              width: double.infinity,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButton<String>(
                hint: Text('Pilih Role'),
                value: _selectedRole,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedRole = newValue;
                  });
                },
                items: _roles.map((role) {
                  return DropdownMenuItem<String>(
                    value: role,
                    child: Text(role),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  String password = passwordController.text.trim();
                  String name = nameController.text.trim();
                  String username = usernameController.text.trim();
                  String updated_at = DateTime.now().toString();

                  if (username.isNotEmpty &&
                      name.isNotEmpty &&
                      _selectedRole != null) {
                    String userId = id;
                    _authController.updateUser(userId, _selectedRole!, name,
                        password, username, updated_at);
                    Get.back();
                    _addLog("Updated users with title: $username");
                  } else {
                    Get.snackbar('Error', 'Please fill all fields');
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
            SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  bool success = await _authController.deleteUser(id);
                  if (success) {
                    Get.back();
                    Get.snackbar('Success', 'User deleted successfully!');
                    _addLog("Deleted users with title: $username");
                  } else {
                    Get.snackbar('Failed', 'Failed to delete user');
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
