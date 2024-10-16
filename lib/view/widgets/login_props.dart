import 'package:cashcow/utils/extension/sizedbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

ElevatedButton kLoginButton(BuildContext context) {
  return ElevatedButton(
    onPressed: () => Get.toNamed('/category'),
    style: ElevatedButton.styleFrom(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ), // Set to zero for a rectangular shape
    ),

    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.login_outlined,
            size: 30,
          ),
          5.pw,
          Text(
            'login'.tr,
            style: Theme.of(context).textTheme.headlineSmall!,
          ),
        ],
      ),
    ), // Using translation key for "login"
  );
}

Container kPasswordTextField() {
  return Container(
    decoration: BoxDecoration(
      // color: Colors.white, // Background color
      borderRadius: BorderRadius.circular(10), // Rounded corners
      border: Border.all(
        color: Colors.black, // Border color
        width: 1, // Border width
      ),
    ),
    child: TextField(
      keyboardType: TextInputType.visiblePassword, // Number keyboard
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        icon: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Icon(Icons.lock),
        ),
        labelText: 'password'.tr, // Translation key for "phone number"
        border: InputBorder.none, // Remove default TextField border
        contentPadding: const EdgeInsets.symmetric(
            horizontal: 8, vertical: 10), // Padding inside TextField
      ),
    ),
  );
}

Container kPhoneNumberTextField() {
  return Container(
    decoration: BoxDecoration(
      // color: Colors.white, // Background color
      borderRadius: BorderRadius.circular(10), // Rounded corners
      border: Border.all(
        color: Colors.black,
        width: 1, // Border width
      ),
    ),
    child: TextField(
      keyboardType: TextInputType.number, // Number keyboard
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly, // Allow only digits
      ],
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        icon: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Icon(Icons.phone),
        ),
        labelText: 'phone_number'.tr, // Translation key for "phone number"
        border: InputBorder.none, // Remove default TextField border
        contentPadding: const EdgeInsets.symmetric(
            horizontal: 8, vertical: 10), // Padding inside TextField
      ),
    ),
  );
}
