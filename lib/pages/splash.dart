import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 3), () {
      Get.offNamed('/login');
    });
    return Material(
      child: Container(
        height: 740,
        width: 360,
        color: Color(0xFF573F7B),
        child: Column(
          children: [
            Center(
              child: Image(
                width: 250,
                height: 250,
                image: AssetImage("image/splashscreen.png"),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Text(
              "Egi Renaldi",
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }
}
