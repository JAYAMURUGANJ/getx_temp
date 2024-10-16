import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/splash_controller.dart';

class SplashScreen extends StatelessWidget {
  final SplashScreenController controller = Get.find();

  SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Add your splash screen content here (logo, animation, etc.)
            Icon(
              Icons.store,
              size: 100,
            ),
            SizedBox(height: 20),
            Text(
              'Welcome to CashCow!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            CircularProgressIndicator(), // Optional loading indicator
          ],
        ),
      ),
    );
  }
}
