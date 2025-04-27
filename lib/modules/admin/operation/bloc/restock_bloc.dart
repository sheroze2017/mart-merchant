import 'package:ba_merchandise/modules/b.a/record_data/bloc/ba_operation_api.dart';
import 'package:ba_merchandise/modules/b.a/record_data/model/restock_data_model.dart';
import 'package:ba_merchandise/widgets/custom/error_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShortStockControllerAdmin extends GetxController {
  BaOperationService baOperationService = BaOperationService();
  var allRestockLoader = false.obs;
  RxList restockRecordCompany = <IndividualRestockData>[].obs;
  RxList merchantRestockDetail = <IndividualRestockData>[].obs;

  Future<void> getAllMerchantRestockRequest(
      String companyId, String martId) async {
    allRestockLoader.value = true;
    try {
      RestockDataModel? response = await baOperationService
          .getAllRestockRequest(companyId.toString(), martId.toString(), null);

      if (response!.data != null && response.code == 200) {
        allRestockLoader.value = false;
        restockRecordCompany.value = response.data!
                .where((e) => e.status!.toLowerCase() == 'pending')
                .toList() ??
            [];
        update();
      } else {
        allRestockLoader.value = false;
        update();
      }
    } catch (e) {
      allRestockLoader.value = false;
      update();
    }
  }

  Future<void> getallRestockRequest(String companyId, String martId) async {
    allRestockLoader.value = true;

    try {
      RestockDataModel? response = await baOperationService
          .getAllRestockRequest(companyId.toString(), martId.toString(), null);

      if (response!.data != null && response.code == 200) {
        allRestockLoader.value = false;
        restockRecordCompany.value = response.data!
                .where((e) => e.status!.toLowerCase() == 'pending')
                .toList() ??
            [];
        update();
      } else {
        allRestockLoader.value = false;
        update();
      }
    } catch (e) {
      allRestockLoader.value = false;
      update();
    }
  }

  Future<void> removeRestockRequest(
      String restockId, String status, context) async {
    try {
      final response =
          await baOperationService.removeRestockRequest(restockId, status);

      if (response != null &&
          response['data'] != null &&
          response['code'] == 200) {
        getallRestockRequest('', '');
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

  @override
  void onInit() {
    super.onInit();
    getallRestockRequest('', '');
  }
}
