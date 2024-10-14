import 'package:cashcow/utils/extension/sizedbox.dart';
import 'package:cashcow/view/widgets/login_props.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/localization_controller.dart';
import '../../controllers/theme_controller.dart';
import '../../utils/widgets/appbar.dart';

class LoginPage extends StatelessWidget {
  final ThemeController themeController =
      Get.find(); // Get the ThemeController instance
  final LocalizationController localizationController = Get.find();

  LoginPage({super.key}); // Get the LocalizationController instance

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: kAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 200,
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.store,
                    color: Colors.deepOrange,
                    size: 50,
                  ),
                  Text(
                    "Cashcow",
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium!
                        .copyWith(fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            10.ph,
            kPhoneNumberTextField(),
            10.ph,
            kPasswordTextField(),
            10.ph,
            kLoginButton(context),
          ],
        ),
      ),
    );
  }
}
