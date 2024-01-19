import 'package:cucimobil_app/controller/AuthController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final AuthController _authController = Get.find<AuthController>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isObscure = true;

  void togglePasswordVisibility() {
    setState(() {
      _isObscure = !_isObscure;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFB9A0C9),
      body: Center(
        child: Container(
          width: 294,
          height: 500,
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 255, 255, 255),
            borderRadius: BorderRadius.circular(25.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                  width: 150,
                  height: 150,
                  image: AssetImage("image/U.png"),
                ),
                SizedBox(height: 20),
                Container(
                  width: 241,
                  height: 58,
                  decoration: ShapeDecoration(
                    color: Color(0xFFD9D9D9),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      controller: usernameController,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Username',
                        hintStyle: TextStyle(color: Color(0xFF918F8F)),
                        border: InputBorder.none,
                        suffixIcon: IconButton(
                          onPressed: () {
                            usernameController.clear();
                          },
                          icon: Icon(Icons.clear),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Container(
                  width: 241,
                  height: 58,
                  decoration: ShapeDecoration(
                    color: Color(0xFFD9D9D9),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      controller: passwordController,
                      obscureText: _isObscure,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Password',
                        hintStyle: TextStyle(color: Color(0xFF918F8F)),
                        border: InputBorder.none,
                        suffixIcon: IconButton(
                          onPressed: () {
                            togglePasswordVisibility();
                          },
                          icon: Icon(_isObscure
                              ? Icons.visibility
                              : Icons.visibility_off),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 25),
                Container(
                  width: 241,
                  height: 44,
                  child: ElevatedButton(
                    onPressed: () {
                      String username = usernameController.text.trim();
                      String password = passwordController.text.trim();

                      if (username.isNotEmpty && password.isNotEmpty) {
                        _authController.login(username, password);
                      } else {
                        Get.snackbar('Error', 'Silakan lengkapi form.');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF573F7B),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'LOGIN',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
