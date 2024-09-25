import 'package:ba_merchandise/common/utils/function.dart';
import 'package:ba_merchandise/core/routes/routes.dart';
import 'package:ba_merchandise/widgets/custom/error_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _init();
  }

  _init() async {
    await Future.delayed(Duration(seconds: 3)); // wait for 3 seconds
    _checkLoginStatus();
  }

  _checkLoginStatus() async {
    // check if user is logged in
    String? userRole = await Utils.getUserRole();
    if (userRole != null && userRole.isNotEmpty) {
      userRoute(userRole, context);
    } else {
      Get.offAllNamed(Routes.USERROLE);
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));

    return Scaffold(
      body: Center(
        child: Image.asset('assets/images/logo.png'),
      ),
    );
  }

  userRoute(String role, context) {
    if (role == 'ADMIN') {
      Get.offAllNamed(Routes.ADMIN_HOME);
    } else if (role == 'COMPANY') {
      Get.offAllNamed(Routes.COMPANY_HOME);
    } else if (role == 'BA') {
      Get.offAllNamed(Routes.BAHOME);
    } else if (role == 'MERCHANT') {
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
