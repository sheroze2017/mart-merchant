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
  CompanyOperationService _companyOperationService = CompanyOperationService();
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

  Future<void> deleteLocation(String LocationId) async {
    locations.removeWhere((location) => location.placeId == LocationId);
    Get.back();
    Fluttertoast.showToast(msg: 'Location deleted');
  }

  Future<void> addNewEmployee(String name, String email, String phoneNo,
      String age, String gender, String brand, String location) async {
    final Location loc = locations.firstWhere((p0) => p0.placeName == location);
    if (loc != null) {
      employees.add(Employee(
          userId: 6,
          name: name,
          email: email,
          phone: phoneNo,
          age: int.parse(age),
          role: 'B.A.',
          gender: gender,
          location: loc,
          imageUrl: ''));
      Fluttertoast.showToast(msg: 'Employee Added');
    } else {
      Fluttertoast.showToast(
          msg: 'Error adding employee', backgroundColor: Colors.red);
    }
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
}

// Sample List of Brands
List<Brand> brandsList = [
  Brand(brandId: 1, brandName: 'Colanext'),
  Brand(brandId: 2, brandName: 'Colgate'),
];
