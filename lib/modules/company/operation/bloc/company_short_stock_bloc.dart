import 'package:ba_merchandise/common/utils/function.dart';
import 'package:ba_merchandise/modules/b.a/record_data/bloc/ba_operation_api.dart';
import 'package:ba_merchandise/modules/b.a/record_data/model/restock_data_model.dart';
import 'package:ba_merchandise/modules/company/operation/bloc/company_operation_api.dart';
import 'package:ba_merchandise/modules/company/operation/model/merchant_restock_model.dart';
import 'package:ba_merchandise/widgets/custom/error_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShortStockController extends GetxController {
  BaOperationService baOperationService = BaOperationService();
  CompanyOperationService _companyOperationService = CompanyOperationService();

  var allRestockLoader = false.obs;
  var merchantstockDetailLoader = false.obs;

  RxList restockRecordCompany = <IndividualRestockData>[].obs;
  RxList merchantRestockRecordList = <MerchantIndividualRestockDetail>[].obs;

  Future<void> getallRestockRequest(martId) async {
    var companyId = await Utils.getUserId();
    allRestockLoader.value = true;

    try {
      RestockDataModel? response = await baOperationService
          .getAllRestockRequest(companyId.toString(), martId.toString());

      if (response!.data != null && response.code == 200) {
        allRestockLoader.value = false;
        restockRecordCompany.value =
            response.data!.where((e) => e.status == 'pending').toList() ?? [];
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

  Future<void> getAllMerchantRestockDetail(martId) async {
    merchantstockDetailLoader.value = true;
    try {
      MerchantRestockDetailModel? response = await _companyOperationService
          .getAllMerchantRestockRequest(martId.toString());

      if (response!.data != null && response.code == 200) {
        merchantRestockRecordList.value = response.data ?? [];
        merchantstockDetailLoader.value = false;
        update(); // Notify listeners to rebuild UI
      } else {}
    } catch (e) {
      merchantstockDetailLoader.value = false;
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
    getallRestockRequest('');
  }
}
