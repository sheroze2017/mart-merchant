import 'package:ba_merchandise/common/utils/function.dart';
import 'package:ba_merchandise/modules/admin/operation/bloc/operation_api.dart';
import 'package:ba_merchandise/modules/admin/operation/model/all_attendance_model.dart';
import 'package:ba_merchandise/modules/admin/operation/model/company_mart_product_model.dart';
import 'package:ba_merchandise/modules/admin/operation/model/createUser_model.dart';
import 'package:ba_merchandise/modules/admin/operation/model/user_by_role_model.dart';
import 'package:ba_merchandise/modules/company/operation/bloc/company_operation_api.dart';
import 'package:ba_merchandise/modules/company/operation/model/mart_model.dart';
import 'package:ba_merchandise/widgets/custom/error_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminOperation extends GetxController {
  var newCompanyLoader = false.obs;
  var newBALoader = false.obs;
  var fetchProductCompanyLoader = false.obs;
  var changeBaStatusLoader = false.obs;
  var assignBaLoader = false.obs;

  var getAllBaAttendanceLoader = false.obs;
  var isBASelected = false.obs;
  var newMartLoader = false.obs;
  RxList<ProductCMData> productList = RxList();
  RxList<ByUserRoleData> companyNameList = RxList();
  Rxn<ByUserRoleData> companyIndividual = Rxn();
  RxList<ByUserRoleData> baNameList = RxList();
  RxList<IndividualUserAttendance> userAttendance = RxList();
  RxList<MartData> marts = RxList();
  Rxn<ByUserRoleData> selectedCompanyIndividual = Rxn();

  CompanyOperationService _companyOperationService = CompanyOperationService();
  final AdminOperationService _adminOperationService = AdminOperationService();

  var companies = <Company>[].obs; // List of companies
  var selectedCompany = Rxn<ByUserRoleData>(); // Currently selected company
  var selectedba = Rxn<ByUserRoleData>(); // Currently selected company
  var selectedMart = Rxn<MartData>(); // Currently selected company

  @override
  void onInit() {
    super.onInit();
    getAllCompany();
    getAllBa();
    getAllMart();
  }

  Future<void> addNewMart(
      {required String locationName,
      required String address,
      required String latitude,
      required String longitude,
      required BuildContext context}) async {
    try {
      newMartLoader.value = true;
      final response = await _adminOperationService.createMart(
          martName: locationName,
          address: address,
          latitude: latitude,
          longitude: longitude);
      if (response['data'] != null && response['code'] == 200) {
        newMartLoader.value = false;
        AnimatedSnackbar.showSnackbar(
          context: context,
          message: response['message'].toString(),
          icon: Icons.info,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 14.0,
        );
        Get.back();
      } else {
        newMartLoader.value = false;
        AnimatedSnackbar.showSnackbar(
          context: context,
          message: response['message'].toString(),
          icon: Icons.info,
          backgroundColor: Color.fromARGB(255, 241, 235, 235),
          textColor: Colors.black,
          fontSize: 14.0,
        );
      }
    } catch (e) {
      newMartLoader.value = false;
    }
  }

  Future<void> addNewCompany(
      {required String email,
      required String password,
      required String location,
      required String image,
      required String phoneNo,
      required String name,
      required BuildContext context}) async {
    try {
      newCompanyLoader.value = true;
      CreateUserModel response = await _adminOperationService.createCompany(
          location: location,
          name: name,
          image: image,
          email: email,
          password: password,
          phoneNo: phoneNo);
      if (response.data != null && response.code == 200) {
        newCompanyLoader.value = false;

        AnimatedSnackbar.showSnackbar(
          context: context,
          message: response.message.toString(),
          icon: Icons.info,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 14.0,
        );
        Get.back();
      } else {
        newCompanyLoader.value = false;

        AnimatedSnackbar.showSnackbar(
          context: context,
          message: response.message.toString(),
          icon: Icons.info,
          backgroundColor: Color.fromARGB(255, 241, 235, 235),
          textColor: Colors.black,
          fontSize: 14.0,
        );
      }
    } catch (e) {
      newCompanyLoader.value = false;
    }
  }

  Future<void> addNewBA(
      {required String email,
      required String password,
      required String martId,
      required String companyId,
      required String location,
      required String image,
      required String phoneNo,
      required String name,
      required BuildContext context}) async {
    try {
      newBALoader.value = true;
      CreateUserModel response = await _adminOperationService.createBA(
          martId: martId,
          companyId: companyId,
          location: location,
          name: name,
          image: image,
          email: email,
          password: password,
          phoneNo: phoneNo);
      if (response.data != null && response.code == 200) {
        newBALoader.value = false;
        AnimatedSnackbar.showSnackbar(
          context: context,
          message: response.message.toString(),
          icon: Icons.info,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 14.0,
        );
        Get.back();
      } else {
        newBALoader.value = false;
        AnimatedSnackbar.showSnackbar(
          context: context,
          message: response.message.toString(),
          icon: Icons.info,
          backgroundColor: Color.fromARGB(255, 241, 235, 235),
          textColor: Colors.black,
          fontSize: 14.0,
        );
      }
    } catch (e) {
      newBALoader.value = false;
    }
  }

  Future<void> addNewMerchant(
      {required String email,
      required String password,
      required String location,
      required String image,
      required String phoneNo,
      required String name,
      required BuildContext context}) async {
    try {
      newBALoader.value = true;
      CreateUserModel response = await _adminOperationService.createMerchant(
          name: name, email: email, password: password, phoneNo: phoneNo);
      if (response.data != null && response.code == 200) {
        newBALoader.value = false;

        AnimatedSnackbar.showSnackbar(
          context: context,
          message: response.message.toString(),
          icon: Icons.info,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 14.0,
        );
        Get.back();
      } else {
        newBALoader.value = false;

        AnimatedSnackbar.showSnackbar(
          context: context,
          message: response.message.toString(),
          icon: Icons.info,
          backgroundColor: Color.fromARGB(255, 241, 235, 235),
          textColor: Colors.black,
          fontSize: 14.0,
        );
      }
    } catch (e) {
      newBALoader.value = false;
    }
  }

  void changeEmployeeStatus(Employee employee) {
    employee.status = !employee.status;
    update();
    Get.back();
  }

  void selectCompanyByName(String companyName) {
    final company = companyNameList.firstWhere(
      (company) => company.name == companyName,
      orElse: () => throw Exception('Company not found'),
    );
    selectedCompany.value = company;
  }

  void selectBaByName(String companyName) {
    final ba = baNameList.firstWhere(
      (ba) => ba.name == companyName,
      orElse: () => throw Exception('Company not found'),
    );
    selectedba.value = ba;
  }

  void selectMartbyName(String martName) {
    final mart = marts.firstWhere(
      (mart) => mart.martName == martName,
      orElse: () => throw Exception('Company not found'),
    );
    selectedMart.value = mart;
  }

  Future<void> getAllProductByCompanyMart(
      int companyId, int? martId, BuildContext context) async {
    productList.clear();
    try {
      fetchProductCompanyLoader.value = true;
      AllCompanyProductData response =
          await _adminOperationService.getAllProducts(companyId, martId);
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

  Future<void> changeBAStatus(
      String userId, String status, BuildContext context) async {
    productList.clear();
    try {
      changeBaStatusLoader.value = true;
      final response =
          await _adminOperationService.changeBaStatus(userId, status);
      if (response['data'] != null && response['code'] == 200) {
        changeBaStatusLoader.value = false;
        AnimatedSnackbar.showSnackbar(
          context: context,
          message: 'User status changed to ${status}',
          icon: Icons.info,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 14.0,
        );
        getAllBa();
        Get.back();
      } else {
        changeBaStatusLoader.value = false;
        AnimatedSnackbar.showSnackbar(
          context: context,
          message: response['message'],
          icon: Icons.info,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 14.0,
        );
        Get.back();
      }
    } catch (e) {
      changeBaStatusLoader.value = false;
      Get.back();
      AnimatedSnackbar.showSnackbar(
        context: context,
        message: 'Error changing user status',
        icon: Icons.info,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 14.0,
      );
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

  Future<void> getAllBa() async {
    baNameList.clear();
    try {
      AllUserByRole response =
          await _adminOperationService.getAllUserByRole('BA');
      if (response.data != null && response.code == 200) {
        baNameList.value = response.data ?? [];
      } else {}
    } catch (e) {}
  }

  Future<void> getAllMart() async {
    AllMart response = await _companyOperationService.getAllMart();
    if (response.data != null && response.code == 200) {
      marts.value = response.data ?? [];
    }
  }

  Future<void> getAllBaAttendance(startDate, endDate) async {
    getAllBaAttendanceLoader.value = true;
    userAttendance.clear();
    try {
      AllUserAttendance response =
          await _adminOperationService.getAllUserAttendance(startDate, endDate);
      if (response.data != null && response.code == 200) {
        getAllBaAttendanceLoader.value = false;
        userAttendance.value = response.data ?? [];
        update();
      } else {
        getAllBaAttendanceLoader.value = false;
      }
    } catch (e) {
      getAllBaAttendanceLoader.value = false;
    }
  }

  Future<void> assignBAToCompanyMart(
      String userId, BuildContext context) async {
    if (selectedCompany.value != null || selectedMart.value != null) {
      assignBaLoader.value = true;
      try {
        final response = await _adminOperationService.assignEmployeeToBa(userId,
            selectedCompany.value!.userId!, selectedMart.value!.martId!);
        if (response['data'] != null && response['code'] == 200) {
          assignBaLoader.value = false;
          Get.back();
          AnimatedSnackbar.showSnackbar(
            context: context,
            message: 'BA assigned to new Employee',
            icon: Icons.info,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 14.0,
          );
        } else {
          assignBaLoader.value = false;
          AnimatedSnackbar.showSnackbar(
            context: context,
            message: 'Error assiging employee',
            icon: Icons.info,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 14.0,
          );
        }
      } catch (e) {
        assignBaLoader.value = false;
        AnimatedSnackbar.showSnackbar(
          context: context,
          message: 'Error assiging employee',
          icon: Icons.info,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 14.0,
        );
      } finally {
        selectedCompany.value = null;
        selectedMart.value = null; 
      }
    } else {
      AnimatedSnackbar.showSnackbar(
        context: context,
        message: 'Please choose field first',
        icon: Icons.info,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 14.0,
      );
    }
  }
}

class Product {
  String name;
  int quantity;
  double price;

  Product({required this.name, required this.quantity, required this.price});
}

class Company {
  String name;
  List<Product> products;

  Company({required this.name, required this.products});
}

class Employee {
  String name;
  int age;
  String phoneNumber;
  String address;
  bool status;

  Employee({
    required this.name,
    required this.age,
    required this.phoneNumber,
    required this.address,
    required this.status,
  });
}
