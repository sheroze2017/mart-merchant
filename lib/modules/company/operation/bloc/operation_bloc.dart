import 'package:ba_merchandise/common/utils/function.dart';
import 'package:ba_merchandise/modules/admin/operation/bloc/operation_api.dart';
import 'package:ba_merchandise/modules/admin/operation/model/company_mart_product_model.dart';
import 'package:ba_merchandise/modules/company/operation/bloc/company_operation_api.dart';
import 'package:ba_merchandise/modules/company/operation/model/company_model.dart';
import 'package:ba_merchandise/modules/company/operation/model/mart_model.dart';
import 'package:ba_merchandise/widgets/custom/error_toast.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../model/operation_model.dart';

class CompanyOperationBloc extends GetxController {
  var addProductLoader = false.obs;
  var addCategoryLoader = false.obs;
  var fetchProductCompanyLoader = false.obs;

  CompanyOperationService _companyOperationService = CompanyOperationService();
  final AdminOperationService _adminOperationService = AdminOperationService();

  RxList<ProductCMData> productList = RxList();
  List<String> employeeRole = [];
  RxList<Location> locations = RxList();
  RxList<Employee> employees = RxList();
  RxList<CategoryData> categories = RxList();
  RxList<MartData> marts = RxList();

  @override
  void onInit() async {
    super.onInit();
    getAllCategory();
    getAllMart();
  }

  Future<void> getAllCategory() async {
    AllCategoryModel response =
        await _companyOperationService.getAllCategories();
    if (response.data != null && response.code == 200) {
      categories.value = response.data ?? [];
    }
  }

  Future<void> getAllMart() async {
    AllMart response = await _companyOperationService.getAllMart();
    if (response.data != null && response.code == 200) {
      marts.value = response.data ?? [];
    }
  }

  Future<void> addNewProduct(
      categoryId, name, desc, price, qty, varient, martId, context) async {
    addProductLoader.value = true;
    final response = await _companyOperationService.createNewProduct(
        categoryId: categoryId,
        name: name,
        desc: desc,
        price: price,
        qty: qty,
        varient: varient,
        martId: martId);
    if (response['data'] != null && response['code'] == 200) {
      addProductLoader.value = false;
      AnimatedSnackbar.showSnackbar(
        context: context,
        message: response['message'], // Fallback message
        icon: Icons.info,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 14.0,
      );
      Get.back();
    } else {
      addProductLoader.value = false;
      AnimatedSnackbar.showSnackbar(
        context: context,
        message: response['message'],
        icon: Icons.error,
        backgroundColor: const Color.fromARGB(255, 241, 235, 235),
        textColor: Colors.black,
        fontSize: 14.0,
      );
    }
  }

  Future<void> addNewCategory(name, context) async {
    addCategoryLoader.value = true;
    final response = await _companyOperationService.createNewCategory(
      name: name,
    );
    if (response['data'] != null && response['code'] == 200) {
      addCategoryLoader.value = false;
      AnimatedSnackbar.showSnackbar(
        context: context,
        message: response['message'], // Fallback message
        icon: Icons.info,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 14.0,
      );
      Get.back();
    } else {
      addCategoryLoader.value = false;
      AnimatedSnackbar.showSnackbar(
        context: context,
        message: response['message'],
        icon: Icons.error,
        backgroundColor: const Color.fromARGB(255, 241, 235, 235),
        textColor: Colors.black,
        fontSize: 14.0,
      );
    }
  }

  Future<void> deleteLocation(String LocationId) async {
    locations.removeWhere((location) => location.placeId == LocationId);
    Get.back();
    Fluttertoast.showToast(msg: 'Location deleted');
  }

  Future<void> addNewLocation(
    String placeId,
    String placeName,
    double latitude,
    double longitude,
    String address,
  ) async {
    locations.add(Location(
        placeId: placeId,
        placeName: placeName,
        latitude: latitude,
        longitude: longitude));
    Get.back();
    Get.back();
    Fluttertoast.showToast(msg: 'New location added');
  }

  Future<void> getAllProductByCompanyMart(
      int? companyId, int? martId, BuildContext context) async {
    productList.clear();
    var userId = await Utils.getUserId();

    try {
      fetchProductCompanyLoader.value = true;
      AllCompanyProductData response = await _adminOperationService
          .getAllProducts(companyId ?? userId!.toInt(), martId);
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
}

// Sample List of Brands
List<Brand> brandsList = [
  Brand(brandId: 1, brandName: 'Colanext'),
  Brand(brandId: 2, brandName: 'Colgate'),
];
