import 'package:cashcow/utils/constants/images.dart';
import 'package:cashcow/utils/extension/sizedbox.dart';
import 'package:cashcow/utils/widgets/orientation_wrapper.dart';
import 'package:cashcow/view/widgets/login_props.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/localization_controller.dart';
import '../../controllers/theme_controller.dart';
import '../../utils/widgets/appbar.dart';

class LoginPage extends StatelessWidget {
  final ThemeController themeController =
      Get.find(); // Get the ThemeController instance
  final LocalizationController localizationController =
      Get.find(); // Get the LocalizationController instance

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: kAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: OrientationWrapper(
          portraitMode: Column(
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
              10.ph, // Custom extension method for spacing (SizedBox)
              kPhoneNumberTextField(),
              10.ph,
              kPasswordTextField(),
              10.ph,
              kLoginButton(context),
            ],
          ),
          landscapeMode: _landscapeLoginLayout(context),
        ),
      ),
    );
  }

  // Define a custom layout for landscape mode
  Widget _landscapeLoginLayout(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Image.asset(
            LocalImages().kLogin,
            fit: BoxFit.fill,
          ),
        ),
        const VerticalDivider(), // Optional divider to separate the two sides

        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 200,
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.store,
                      color: Theme.of(context).colorScheme.primary,
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
              kLoginButton(context)
            ],
          ),
        ),
      ],
    );
  }
}
