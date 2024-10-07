import 'package:ba_merchandise/common/utils/function.dart';
import 'package:ba_merchandise/modules/admin/operation/bloc/operation_api.dart';
import 'package:ba_merchandise/modules/admin/operation/model/company_mart_product_model.dart';
import 'package:ba_merchandise/modules/admin/operation/model/user_by_role_model.dart';
import 'package:ba_merchandise/modules/b.a/record_data/bloc/ba_operation_api.dart';
import 'package:ba_merchandise/widgets/custom/error_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InsertSalesRecord extends GetxController {
  var fetchProductCompanyLoader = false.obs;
  var statusRecordLoader = false.obs;
  var updatePriceLoader = false.obs;
  RxList<ByUserRoleData> companyNameList = RxList();
  RxList<ByUserRoleData> compititorNameList = RxList();

  Rxn<ByUserRoleData> selectedCompanyIndividual = Rxn();

  BaOperationService baOperationService = BaOperationService();
  final AdminOperationService _adminOperationService = AdminOperationService();
  RxList<ProductCMData> productList = RxList();
  RxList<ProductCMData> competitorProductList = RxList();

  RxList<TextEditingController> textControllers = RxList();

  @override
  void onInit() {
    super.onInit();
    getAllProductByCompanyMart();
    getAllCompany();
    getAllCompititor();
  }

  Future<void> insertSalesRecord(BuildContext context) async {
    statusRecordLoader.value = true;
    final List<Map<String, String>> salesRecords = List.generate(
      productList.length,
      (index) => {
        "product_id": productList[index].productId.toString(),
        "qty": textControllers[index].text.toString(),
      },
    ).where((record) {
      final qty = record["qty"];
      // Exclude records where qty is empty, null, or "0"
      return qty != null && qty.isNotEmpty && qty != "0";
    }).toList();
    if (salesRecords.isEmpty) {
      statusRecordLoader.value = false;
      AnimatedSnackbar.showSnackbar(
        context: context,
        message: 'Please record sales for any item', // Fallback message
        icon: Icons.info,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 14.0,
      );
    } else {
      try {
        final response =
            await baOperationService.insertSalesRecord(salesRecords);

        if (response != null &&
            response['data'] != null &&
            response['code'] == 200) {
          statusRecordLoader.value = false;
          // Success message
          Get.back();
          AnimatedSnackbar.showSnackbar(
            context: context,
            message: response['message'] ??
                'Sales record inserted successfully', // Fallback message
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
                'Failed to insert sales record', // Fallback error message
            icon: Icons.error,
            backgroundColor: const Color.fromARGB(255, 241, 235, 235),
            textColor: Colors.black,
            fontSize: 14.0,
          );
        }
      } catch (error) {
        statusRecordLoader.value = false;
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
  }

  Future<void> getAllCompetitorProductByCompanyMart(companyId) async {
    competitorProductList.clear();
    try {
      fetchProductCompanyLoader.value = true;
      AllCompanyProductData response =
          await _adminOperationService.getAllProducts(
        companyId,
      );
      if (response.data != null && response.code == 200) {
        fetchProductCompanyLoader.value = false;
        competitorProductList.value = response.data ?? [];
        textControllers.value = List.generate(
            response.data!.length, (index) => TextEditingController(text: ''));
      } else {
        fetchProductCompanyLoader.value = false;
      }
    } catch (e) {
      fetchProductCompanyLoader.value = false;
    }
  }

  Future<void> getAllProductByCompanyMart() async {
    productList.clear();
    var companyId = await Utils.getCompanyId();
    print(companyId);
    var martId = await Utils.getMartId();
    try {
      fetchProductCompanyLoader.value = true;
      AllCompanyProductData response =
          await _adminOperationService.getAllProducts(
        selectedCompanyIndividual.value == null
            ? int.parse(companyId!)
            : int.parse(selectedCompanyIndividual.value!.userId.toString()),
      );
      if (response.data != null && response.code == 200) {
        fetchProductCompanyLoader.value = false;
        productList.value = response.data ?? [];
        textControllers.value = List.generate(
            response.data!.length, (index) => TextEditingController(text: ''));
      } else {
        fetchProductCompanyLoader.value = false;
      }
    } catch (e) {
      fetchProductCompanyLoader.value = false;
    }
  }

  Future<void> updateProductPrice(context, String price, String id) async {
    try {
      updatePriceLoader.value = true;
      final response = await baOperationService.updateProductPrice(price, id);
      if (response['data'] != null && response['code'] == 200) {
        updatePriceLoader.value = false;
        AnimatedSnackbar.showSnackbar(
          context: context,
          message: response['message'],
          icon: Icons.info,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 14.0,
        );
        getAllProductByCompanyMart();
        Get.back();
      } else {
        updatePriceLoader.value = false;
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
      updatePriceLoader.value = false;
    }
  }

  Future<void> getAllCompany() async {
    companyNameList.clear();
    try {
      AllUserByRole response =
          await _adminOperationService.getAllUserByRole('COMPANY');
      if (response.data != null && response.code == 200) {
        companyNameList.value = response.data ?? [];
      } else {}
    } catch (e) {}
  }

  Future<void> getAllCompititor() async {
    compititorNameList.clear();
    try {
      AllUserByRole response =
          await _adminOperationService.getAllUserByRole('COMPITITOR');
      if (response.data != null && response.code == 200) {
        compititorNameList.value = response.data ?? [];
      } else {}
    } catch (e) {}
  }
}
