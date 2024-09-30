import 'package:ba_merchandise/common/utils/function.dart';
import 'package:ba_merchandise/core/routes/routes.dart';
import 'package:ba_merchandise/modules/auth/bloc/auth_api.dart';
import 'package:ba_merchandise/modules/auth/model/auth_model.dart';
import 'package:ba_merchandise/services/local_storage/auth_storage.dart';
import 'package:ba_merchandise/widgets/custom/error_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthenticationController extends GetxController {
  var isLoading = false.obs;
  final AuthService _authService = AuthService();
  final AuthStorage _authStorage = AuthStorage();

  Future<void> login(
      {required String email,
      required String password,
      required BuildContext context}) async {
    try {
      isLoading.value = true;
      AuthResponse response = await _authService.login(
        email: email,
        password: password,
      );
      if (response.data != null && response.code == 200) {
        // ignore: use_build_context_synchronously
        var token = await Utils.getToken();
        print(token);
        await updateToken(
            userId: response.data!.userId.toString(), token: token);
        await _authStorage.set(response);
        userRoute(response.data!.role ?? '', context);
        isLoading.value = false;
      } else {
        AnimatedSnackbar.showSnackbar(
          context: context,
          message: response.message.toString(),
          icon: Icons.info,
          backgroundColor: Color.fromARGB(255, 241, 235, 235),
          textColor: Colors.black,
          fontSize: 14.0,
        );
        isLoading.value = false;
      }
    } catch (e) {
      isLoading.value = false;
    }
  }

  Future<void> updateToken({
    required String userId,
    required String token,
  }) async {
    try {
      await _authService.updateToken(userId: userId, token: token);
      print('sheroze');
    } catch (e) {
      throw e;
    }
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
