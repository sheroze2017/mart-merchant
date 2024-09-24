import 'package:ba_merchandise/core/routes/routes.dart';
import 'package:ba_merchandise/widgets/custom/error_toast.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import 'package:get/get.dart';

class AuthenticationController extends GetxController {
  var isLoading = false.obs;

  void login(String username, String password, context) async {
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 3));
    isLoading.value = false;

    if (username == "admin@gmail.com" && password == "admin123") {
      Get.offAllNamed(Routes.ADMIN_HOME);
    } else if (username == "company@gmail.com" && password == "admin123") {
      Get.offAllNamed(Routes.COMPANY_HOME);
    } else if (username == "ba@gmail.com" && password == "admin123") {
      Get.offAllNamed(Routes.BAHOME);
    } else if (username == "merchant@gmail.com" && password == "admin123") {
      Get.offAllNamed(Routes.MERCHANTDASHBOARD);
    } else {
      AnimatedSnackbar.showSnackbar(
        context: context,
        message: "Invalid email or password",
        icon: Icons.info,
        backgroundColor: Color.fromARGB(255, 241, 235, 235),
        textColor: Colors.black,
        fontSize: 14.0,
      );
    }
  }
}
