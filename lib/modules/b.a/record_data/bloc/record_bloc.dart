import 'package:ba_merchandise/common/utils/function.dart';
import 'package:ba_merchandise/main.dart';
import 'package:ba_merchandise/modules/b.a/record_data/bloc/ba_operation_api.dart';
import 'package:ba_merchandise/modules/b.a/record_data/model/record_model.dart';
import 'package:ba_merchandise/modules/b.a/record_data/model/restock_data_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

import '../../../../core/local/hive_db/hive.dart';
import 'package:intl/intl.dart';

import '../../../../widgets/custom/error_toast.dart'; // To format date and time

class RecordController extends GetxController {
  RxList records = <RecordModelData>[].obs;
  RxList restockRecord = <IndividualRestockData>[].obs;
  BaOperationService baOperationService = BaOperationService();
  var stockRequest = false.obs;
  var allRestockLoader = false.obs;

  var statusRecordLoader = false.obs;
  String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
  RxList<RecordModel> recordData = <RecordModel>[].obs;
  @override
  void onInit() {
    super.onInit();
    getallRestockRequest();
  }

  Future<void> recordIntercept(BuildContext context, String count) async {
    statusRecordLoader.value = true;
    try {
      final response = await baOperationService.insertInterceptRecord(count);
      if (response != null &&
          response['data'] != null &&
          response['code'] == 200) {
        statusRecordLoader.value = false;
        Get.back();
        AnimatedSnackbar.showSnackbar(
          context: context,
          message: 'Intercept recorded successfully', // Fallback message
          icon: Icons.info,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 14.0,
        );
      } else {
        statusRecordLoader.value = false;
        // Failure message
        AnimatedSnackbar.showSnackbar(
          context: context,
          message: response['message']?.toString() ??
              'Failed to record intercept', // Fallback error message
          icon: Icons.error,
          backgroundColor: const Color.fromARGB(255, 241, 235, 235),
          textColor: Colors.black,
          fontSize: 14.0,
        );
      }
    } catch (error) {
      statusRecordLoader.value = false;
      Get.back();
      AnimatedSnackbar.showSnackbar(
        context: context,
        message: 'An error occurred: ${error.toString()}',
        icon: Icons.error,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 14.0,
      );
    }
  }

  Future<void> restockRequest(String productID, context) async {
    stockRequest.value = true;
    try {
      final response = await baOperationService.restockRequest(productID);

      if (response != null &&
          response['data'] != null &&
          response['code'] == 200) {
        stockRequest.value = false;
        AnimatedSnackbar.showSnackbar(
          context: context,
          message: 'Product restock request sended', // Fallback message
          icon: Icons.info,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 14.0,
        );
      } else {
        stockRequest.value = false;
        // Failure message
        AnimatedSnackbar.showSnackbar(
          context: context,
          message: response['message']?.toString() ??
              'Failed to send request', // Fallback error message
          icon: Icons.error,
          backgroundColor: const Color.fromARGB(255, 241, 235, 235),
          textColor: Colors.black,
          fontSize: 14.0,
        );
      }
    } catch (error) {
      stockRequest.value = false;
      Get.back();
      AnimatedSnackbar.showSnackbar(
        context: context,
        message: 'An error occurred: ${error.toString()}',
        icon: Icons.error,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 14.0,
      );
    }
  }

  Future<void> removeRestockRequest(
      String restockId, String status, context) async {
    stockRequest.value = true;
    try {
      final response =
          await baOperationService.removeRestockRequest(restockId, status);

      if (response != null &&
          response['data'] != null &&
          response['code'] == 200) {
        stockRequest.value = false;
        Get.back();
        AnimatedSnackbar.showSnackbar(
          context: context,
          message: 'Restock status updated', // Fallback message
          icon: Icons.info,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 14.0,
        );
      } else {
        stockRequest.value = false;
        // Failure message
        AnimatedSnackbar.showSnackbar(
          context: context,
          message: response['message']?.toString() ??
              'Failed to update status', // Fallback error message
          icon: Icons.error,
          backgroundColor: const Color.fromARGB(255, 241, 235, 235),
          textColor: Colors.black,
          fontSize: 14.0,
        );
      }
    } catch (error) {
      stockRequest.value = false;
      Get.back();
      AnimatedSnackbar.showSnackbar(
        context: context,
        message: 'An error occurred: ${error.toString()}',
        icon: Icons.error,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 14.0,
      );
    }
  }

  Future<void> getallRestockRequest() async {
    var martId = await Utils.getMartId();
    var companyId = await Utils.getCompanyId();
    allRestockLoader.value = true;
    try {
      RestockDataModel? response = await baOperationService
          .getAllRestockRequest(companyId.toString(), martId.toString());

      if (response!.data != null && response.code == 200) {
        allRestockLoader.value = false;
        restockRecord.value = response.data ?? [];
        update(); // Notify listeners to rebuild UI
      } else {
        allRestockLoader.value = false;
        update();
      }
    } catch (e) {
      allRestockLoader.value = false;
      update();
    }
  }

  // Close the Hive box when not needed
  void dispose() {
    salesRecord.close();
  }
}
