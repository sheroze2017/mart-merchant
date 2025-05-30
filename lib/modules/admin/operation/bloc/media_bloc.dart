import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:ba_merchandise/modules/merchandiser/operation/bloc/operation_api.dart';
import 'package:ba_merchandise/widgets/custom/error_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MediaBloc extends GetxController {
  MerchantOperationService merchantservice = MerchantOperationService();

  var imgUploaded = false.obs;
  var imgUrl = ''.obs;

  Future<void> uploadPhoto(imagePath, BuildContext context) async {
    imgUploaded.value = true;
    imgUrl.value = '';
    try {
      imgUrl.value = '';
      String base64Image = await imageToBase64(imagePath);
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

}
