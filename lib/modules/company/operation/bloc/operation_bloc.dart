import 'package:ba_merchandise/common/utils/function.dart';
import 'package:ba_merchandise/modules/admin/operation/bloc/operation_api.dart';
import 'package:ba_merchandise/modules/admin/operation/model/all_attendance_model.dart';
import 'package:ba_merchandise/modules/admin/operation/model/company_mart_product_model.dart';
import 'package:ba_merchandise/modules/admin/operation/model/user_by_role_model.dart';
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
  var delProductLoader = false.obs;
  var updateProductLoader = false.obs;

  var addCategoryLoader = false.obs;
  var fetchProductCompanyLoader = false.obs;
  var getAllBaAttendanceLoader = false.obs;

  CompanyOperationService _companyOperationService = CompanyOperationService();
  final AdminOperationService _adminOperationService = AdminOperationService();

  RxList<ProductCMData> productList = RxList();
  List<String> employeeRole = [];
  RxList<ByUserRoleData> baNameList = RxList();
  RxList<ByUserRoleData> merchantNameList = RxList();
  RxList<ByUserRoleData> supervisorNameList = RxList();

  RxList<Location> locations = RxList();
  RxList<Employee> employees = RxList();
  RxList<dynamic> competitorActivity = RxList();
  RxList<CategoryData> categories = RxList();
  RxList<MartData> marts = RxList();
  RxList<IndividualUserAttendance> userAttendance = RxList();
  Rxn<ByUserRoleData> companyIndividual = Rxn();
  RxInt selectedCategoryId = 0.obs;

  @override
  void onInit() async {
    super.onInit();
    getAllCategory();
    getAllMart();
    getAllMerchant();
    getAllBa();
    getAllSupervisor();
  }

  RxInt selectedMartId = 0.obs;

  List<CategoryData> get availableCategories {
    final filteredBas = filteredBaList;
    print(categories);
    final categoryIds = filteredBas
        .map((e) => int.tryParse(e.categoryId ?? ''))
        .whereType<int>()
        .toSet();

    return categories.where((c) => categoryIds.contains(c.categoryId)).toList();
  }

  List<ByUserRoleData> get filteredBaList {
    final selectedMart = selectedMartId.value;
    final selectedCategory = selectedCategoryId.value;

    return baNameList.where((e) {
      final matchesMart =
          selectedMart == 0 || e.martId == selectedMart.toString();
      final matchesCategory =
          selectedCategory == 0 || e.categoryId == selectedCategory.toString();
      return e.status == 'active' && matchesMart && matchesCategory;
    }).toList();
  }

  void clearMartSelection() {
    selectedMartId.value = 0;
  }

  void selectMartByName(String martName) {
    final index = marts.indexWhere((m) => m.martName == martName);
    if (index != -1) {
      selectedMartId.value = marts[index].martId ?? 0;
    }
  }

  Future<void> getAllCategory() async {
    AllCategoryModel response =
        await _companyOperationService.getAllCategories();
    if (response.data != null && response.code == 200) {
      categories.value = response.data ?? [];
    }
  }

  Future<void> getAllBaAttendance(startDate, endDate) async {
    getAllBaAttendanceLoader.value = true;
    userAttendance.clear();
    try {
      var userId = await Utils.getUserId();

      AllUserAttendance response =
          await _adminOperationService.getAllUserAttendance(startDate, endDate);
      if (response.data != null && response.code == 200) {
        getAllBaAttendanceLoader.value = false;
        userAttendance.value = response.data!
            .where((company) => company.companyId == userId.toString())
            .toList();
        update();
      } else {
        getAllBaAttendanceLoader.value = false;
      }
    } catch (e) {
      getAllBaAttendanceLoader.value = false;
    }
  }

  Future<void> getAllMart() async {
    AllMart response = await _companyOperationService.getAllMart();
    if (response.data != null && response.code == 200) {
      marts.value = response.data ?? [];
    }
  }

  Future<void> addNewProduct(
      categoryId, name, desc, price, qty, varient, size, context) async {
    addProductLoader.value = true;
    final response = await _companyOperationService.createNewProduct(
        categoryId: categoryId,
        name: name,
        desc: desc,
        price: price,
        qty: qty,
        varient: varient,
        size: size);
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

  Future<void> updateProduct(categoryId, name, desc, price, qty, varient, size,
      productId, context) async {
    updateProductLoader.value = true;
    try {
      final response = await _companyOperationService.editProduct(
          productId: productId,
          categoryId: categoryId,
          name: name,
          desc: desc,
          price: price,
          qty: qty,
          varient: varient,
          size: size);
      if (response['data'] != null && response['code'] == 200) {
        updateProductLoader.value = false;
        AnimatedSnackbar.showSnackbar(
          context: context,
          message: 'Product updated', // Fallback message
          icon: Icons.info,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 14.0,
        );
        Get.back();
      } else {
        updateProductLoader.value = false;
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
      updateProductLoader.value = false;
    } finally {
      updateProductLoader.value = false;
    }
  }

  Future<void> deleteProduct(productId, context) async {
    delProductLoader.value = true;
    final response = await _companyOperationService.deleteProduct(
        productId: productId.toString());
    if (response['data'] != null && response['code'] == 200) {
      delProductLoader.value = false;
      AnimatedSnackbar.showSnackbar(
        context: context,
        message: 'Product Deleted', // Fallback message
        icon: Icons.info,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 14.0,
      );
      getAllProductByCompanyMart(null, context);
      Get.back();
    } else {
      delProductLoader.value = false;
      AnimatedSnackbar.showSnackbar(
        context: context,
        message: response['message'],
        icon: Icons.error,
        backgroundColor: const Color.fromARGB(255, 241, 235, 235),
        textColor: Colors.black,
        fontSize: 14.0,
      );
      Get.back();
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
      int? companyId, BuildContext context) async {
    productList.clear();
    var userId = await Utils.getUserId();

    try {
      fetchProductCompanyLoader.value = true;
      AllCompanyProductData response = await _adminOperationService
          .getAllProducts(companyId ?? userId!.toInt());
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

  Future<void> getAllBa() async {
    baNameList.clear();
    try {
      AllUserByRole response =
          await _adminOperationService.getAllUserByRole('BA');
      if (response.data != null && response.code == 200) {
        var userId = await Utils.getUserId();
        baNameList.value = response.data
                ?.where((ba) => ba.companyId.toString() == userId.toString())
                .toList() ??
            [];
      } else {}
    } catch (e) {}
  }

  Future<void> getAllSupervisor() async {
    supervisorNameList.clear();
    try {
      AllUserByRole response =
          await _adminOperationService.getAllUserByRole('supervisor');
      if (response.data != null && response.code == 200) {
        var userId = await Utils.getUserId();
        supervisorNameList.value = response.data
                ?.where((ba) => ba.companyId.toString() == userId.toString())
                .toList() ??
            [];
      } else {}
    } catch (e) {}
  }

  Future<void> getAllMerchant() async {
    merchantNameList.clear();
    try {
      AllUserByRole response =
          await _adminOperationService.getAllUserByRole('MERCHANT');
      if (response.data != null && response.code == 200) {
        var userId = await Utils.getUserId();
        merchantNameList.value = response.data
                ?.where((merchant) =>
                    merchant.companyId.toString() == userId.toString())
                .toList() ??
            [];
      } else {}
    } catch (e) {}
  }
}

// Sample List of Brands
List<Brand> brandsList = [
  Brand(brandId: 1, brandName: 'Colanext'),
  Brand(brandId: 2, brandName: 'Colgate'),
];
