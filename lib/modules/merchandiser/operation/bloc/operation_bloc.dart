import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:ba_merchandise/common/utils/function.dart';
import 'package:ba_merchandise/main.dart';
import 'package:ba_merchandise/modules/admin/operation/bloc/operation_api.dart';
import 'package:ba_merchandise/modules/admin/operation/model/company_mart_product_model.dart';
import 'package:ba_merchandise/modules/b.a/record_data/model/record_model.dart';
import 'package:ba_merchandise/modules/company/operation/bloc/company_operation_api.dart';
import 'package:ba_merchandise/modules/company/operation/model/mart_model.dart';
import 'package:ba_merchandise/modules/merchandiser/operation/bloc/operation_api.dart';
import 'package:ba_merchandise/widgets/custom/error_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:location/location.dart' as locat;

import '../../../../core/local/hive_db/hive.dart';
import 'package:intl/intl.dart'; // To format date and time

class MerchantOperationBloc extends GetxController {
  RxList records = <RecordModelData>[].obs;
  RxList<ProductCMData> productList = RxList();
  RxList<MartData> marts = RxList();
  RxList restockRecord = <RecordModelData>[].obs;

  CompanyOperationService _companyOperationService = CompanyOperationService();
  final AdminOperationService _adminOperationService = AdminOperationService();

  var restockLoader = false.obs;
  var fetchProductCompanyLoader = false.obs;
  var updateQuantityLoader = false.obs;
  var imgUploaded = false.obs;

  String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
  RxList<RecordModel> recordData = <RecordModel>[].obs;
  var imgUrl = ''.obs;
  double _latitude = 0.00;
  double _longitude = 0.00;
  final locat.Location _location = locat.Location();

  getCurrentLocation(context) async {
    bool serviceEnabled;
    locat.PermissionStatus permissionGranted;
    serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        AnimatedSnackbar.showSnackbar(
          context: context,
          message: 'Please enable location',
          icon: Icons.info,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 14.0,
        );
        return;
      }
    }
    permissionGranted = await _location.hasPermission();
    if (permissionGranted == locat.PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != locat.PermissionStatus.granted) {
        return;
      }
    }
    locat.LocationData currentPosition = await _location.getLocation();
    _latitude = currentPosition.latitude!;
    _longitude = currentPosition.longitude!;
    return true;
  }

  MerchantOperationService merchantservice = MerchantOperationService();
  @override
  void onInit() {
    super.onInit();
    getAllMart();
  }

  Future<void> uploadPhoto(imagePath, BuildContext context) async {
    imgUploaded.value = true;
    imgUrl.value = '';
    try {
      imgUrl.value = '';
      String base64Image = await imageToBase64(imagePath);
      print('Base64 Image: $base64Image');
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
    File imageFile = File(imagePath);
    if (!imageFile.existsSync()) {
      throw Exception('Image file not found');
    }
    Uint8List imageBytes = await imageFile.readAsBytes();
    String base64Image = base64Encode(imageBytes);
    return base64Image;
  }

  Future<void> getAllMart() async {
    AllMart response = await _companyOperationService.getAllMart();
    if (response.data != null && response.code == 200) {
      marts.value = response.data ?? [];
    }
  }

  Future<void> getAllProductByCompanyMart(
      int? martId, BuildContext context) async {
    productList.clear();
    var userId = await Utils.getUserId();
    var companyId = await Utils.getCompanyId();

    try {
      fetchProductCompanyLoader.value = true;
      AllCompanyProductData response = await _adminOperationService
          .getAllProducts(int.parse(companyId.toString()));
      if (response.data != null && response.code == 200) {
        fetchProductCompanyLoader.value = false;
        productList.value = response.data ?? [];
      } else {
        fetchProductCompanyLoader.value = false;
      }
    } catch (e) {
      fetchProductCompanyLoader.value = false;
    }
  }

  Future<void> uploadRestockRecord(
      String desc, String martId, BuildContext context) async {
    if (imgUrl.value.isEmpty) {
      AnimatedSnackbar.showSnackbar(
        context: context,
        message: 'Please select image',
        icon: Icons.info,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 14.0,
      );
    } else {
      restockLoader.value = true;
      var userId = await Utils.getUserId();
      var companyId = await Utils.getCompanyId();
      try {
        final resp = await getCurrentLocation(context);
        if (resp == true) {
          final response = await merchantservice.uploadRestockRecord(
              desc,
              imgUrl.value,
              martId,
              companyId.toString(),
              userId.toString(),
              _latitude,
              _longitude);
          if (response['code'] == 200 && response['sucess'] == true) {
            AnimatedSnackbar.showSnackbar(
              context: context,
              message: 'Restock Done Successfully',
              icon: Icons.info,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 14.0,
            );
            Get.back();
          } else {
            AnimatedSnackbar.showSnackbar(
              context: context,
              message: response['message'],
              icon: Icons.info,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 14.0,
            );
          }
        } else {
          AnimatedSnackbar.showSnackbar(
            context: context,
            message: 'Error uploading data',
            icon: Icons.info,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 14.0,
          );
          restockLoader.value = false;
        }
      } catch (e) {
        AnimatedSnackbar.showSnackbar(
          context: context,
          message: e.toString(),
          icon: Icons.info,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 14.0,
        );
        restockLoader.value = false;
      } finally {
        restockLoader.value = false;
      }
    }
  }

  Future<void> updateQuantiy(context, String qty, String id) async {
    try {
      updateQuantityLoader.value = true;
      final response = await merchantservice.updateProductQuantity(qty, id);
      if (response['data'] != null && response['code'] == 200) {
        updateQuantityLoader.value = false;
        AnimatedSnackbar.showSnackbar(
          context: context,
          message: 'Product Quantity Updated Successfully',
          icon: Icons.info,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 14.0,
        );
        Get.back();
      } else {
        updateQuantityLoader.value = false;
        // Failure message
        AnimatedSnackbar.showSnackbar(
          context: context,
          message: response['message'],
          icon: Icons.error,
          backgroundColor: const Color.fromARGB(255, 241, 235, 235),
          textColor: Colors.black,
          fontSize: 14.0,
        );
      }
    } catch (e) {
      AnimatedSnackbar.showSnackbar(
        context: context,
        message: 'An error occured ${e}',
        icon: Icons.error,
        backgroundColor: const Color.fromARGB(255, 241, 235, 235),
        textColor: Colors.black,
        fontSize: 14.0,
      );
      updateQuantityLoader.value = false;
    }
  }

  // Close the Hive box when not needed
  void dispose() {
    salesRecord.close();
  }
}
