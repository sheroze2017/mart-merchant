import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:ba_merchandise/modules/admin/dashboard/bloc/dashboard_controller.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:ba_merchandise/modules/merchandiser/operation/bloc/operation_api.dart';
import 'package:ba_merchandise/widgets/custom/error_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MediaBloc extends GetxController {
  MerchantOperationService merchantservice = MerchantOperationService();

  var imgUploaded = false.obs;
  var imgUrl = ''.obs;
  var proimgUploaded = false.obs;
  var proimgUrl = ''.obs;
  final DashBoardController controller = Get.find();

  Future<void> uploadPhoto(imagePath, BuildContext context) async {
    imgUploaded.value = true;
    imgUrl.value = '';

    try {
      imgUrl.value = '';
      String base64Image = await imageToBase64(imagePath);
      print("Base64 string length: ${base64Image.length}");
      final response = await merchantservice.uploadPhoto(base64Image);
      if (response.isNotEmpty) {
        imgUrl.value = response;
        AnimatedSnackbar.showSnackbar(
          context: context,
          message: 'Image added',
          icon: Icons.info,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 14.0,
        );
      } else {
        AnimatedSnackbar.showSnackbar(
          context: context,
          message: 'Error adding image',
          icon: Icons.info,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 14.0,
        );
      }
    } catch (e) {
      AnimatedSnackbar.showSnackbar(
        context: context,
        message: 'Error adding image',
        icon: Icons.info,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 14.0,
      );
      imgUploaded.value = false;
      throw (e);
    } finally {
      imgUploaded.value = false;
    }
  }

  Future<String> imageToBase64(String imagePath) async {
    final imageFile = File(imagePath);
    if (!imageFile.existsSync()) {
      throw Exception('Image file not found');
    }
    final compressedBytes = await FlutterImageCompress.compressWithFile(
      imagePath,
      minWidth: 800,
      minHeight: 800,
      quality: 75,
      format: CompressFormat.jpeg,
    );
    if (compressedBytes == null) {
      throw Exception('Failed to compress image');
    }
    return base64Encode(compressedBytes);
  }

  Future<void> updateProfilePhoto(imagePath, BuildContext context) async {
    proimgUploaded.value = true;
    proimgUrl.value = '';
    try {
      proimgUrl.value = '';
      String base64Image = await imageToBase64(imagePath);
      final response = await merchantservice.updateProfilePhoto(base64Image);
      if (response.isNotEmpty) {
        proimgUrl.value = response;
        controller.updateUserImage(proimgUrl.value);
        AnimatedSnackbar.showSnackbar(
          context: context,
          message: 'Image updated',
          icon: Icons.info,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 14.0,
        );
        Get.back();
      } else {
        AnimatedSnackbar.showSnackbar(
          context: context,
          message: 'Error updating image',
          icon: Icons.info,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 14.0,
        );
        Get.back();
      }
    } catch (e) {
      AnimatedSnackbar.showSnackbar(
        context: context,
        message: 'Error updating image',
        icon: Icons.info,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 14.0,
      );
      proimgUploaded.value = false;
      throw (e);
    } finally {
      proimgUploaded.value = false;
    }
  }
}
