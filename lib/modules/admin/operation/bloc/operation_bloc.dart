import 'package:ba_merchandise/common/utils/function.dart';
import 'package:ba_merchandise/modules/admin/operation/bloc/operation_api.dart';
import 'package:ba_merchandise/modules/admin/operation/model/all_attendance_model.dart';
import 'package:ba_merchandise/modules/admin/operation/model/company_mart_product_model.dart';
import 'package:ba_merchandise/modules/admin/operation/model/createUser_model.dart';
import 'package:ba_merchandise/modules/admin/operation/model/sales_model.dart';
import 'package:ba_merchandise/modules/admin/operation/model/user_by_role_model.dart';
import 'package:ba_merchandise/modules/company/operation/bloc/company_operation_api.dart';
import 'package:ba_merchandise/modules/company/operation/model/company_model.dart';
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
  var salesLoader = false.obs;

  var getAllBaAttendanceLoader = false.obs;
  var isBASelected = false.obs;
  var newMartLoader = false.obs;
  RxList<ProductCMData> productList = RxList();
  RxList<ByUserRoleData> companyNameList = RxList();
  Rxn<ByUserRoleData> companyIndividual = Rxn();
  RxList<ByUserRoleData> baNameList = RxList();
  RxList<ByUserRoleData> MerchantNameList = RxList();

  RxList<IndividualUserAttendance> userAttendance = RxList();
  RxList<IndividualSalesData> individualSales = RxList();

  Rxn<ByUserRoleData> selectedCompanyIndividual = Rxn();
  RxList<MartData> marts = RxList();
  CompanyOperationService _companyOperationService = CompanyOperationService();
  final AdminOperationService _adminOperationService = AdminOperationService();

  var selectedCompany = Rxn<ByUserRoleData>(); // Currently selected company
  var selectedCategory = Rxn<CategoryData>(); // Currently selected company

  var selectedba = Rxn<ByUserRoleData>(); // Currently selected company
  var selectedMart = Rxn<MartData>();
  RxList<CategoryData> categories = RxList();
  // Currently selected company

  @override
  void onInit() {
    super.onInit();
    getAllCompany();
    getAllBa();
    getAllMart();
    getAllMerchant();
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
        getAllCompany();
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
        getAllBa();
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

  Future<void> addNewSupervisor(
      {required String email,
      required String password,
      required String location,
      required String image,
      required String phoneNo,
      required String name,
      required BuildContext context}) async {
    try {
      newBALoader.value = true;
      var companyId = await Utils.getUserId();
      CreateUserModel response = await _adminOperationService.createSupervisor(
          companyId: companyId.toString(),
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
        getAllMerchant();
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

  void selectCompanyByName(String companyName) {
    final company = companyNameList.firstWhere(
      (company) => company.name == companyName,
      orElse: () => throw Exception('Company not found'),
    );
    selectedCompany.value = company;
  }

  void selectCategoryByName(String category) {
    final cate = categories.firstWhere(
      (cat) => cat.name == category,
      orElse: () => throw Exception('Company not found'),
    );
    selectedCategory.value = cate;
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
          await _adminOperationService.getAllProducts(companyId);
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

  Future<void> getAllMerchant() async {
    MerchantNameList.clear();
    try {
      AllUserByRole response =
          await _adminOperationService.getAllUserByRole('MERCHANT');
      if (response.data != null && response.code == 200) {
        MerchantNameList.value = response.data ?? [];
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
      String userId, BuildContext context, bool isMerchant) async {
    if (selectedCompany.value != null ||
            selectedCategory.value != null ||
            isMerchant
        ? true
        : selectedMart.value != null) {
      assignBaLoader.value = true;
      try {
        final response = await _adminOperationService.assignEmployeeToBa(
            userId,
            selectedCompany.value!.userId!,
            !isMerchant ? selectedMart.value!.martId! : 2,
            selectedCategory.value!.categoryId);
        if (response['data'] != null && response['code'] == 200) {
          assignBaLoader.value = false;
          Get.back();
          AnimatedSnackbar.showSnackbar(
            context: context,
            message: isMerchant
                ? 'Merchant assign to new Company successfully'
                : 'B.A assign to new Company successfully',
            icon: Icons.info,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 14.0,
          );
          getAllMerchant();
          getAllBa();
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
        message: 'Please look if you are missing any field',
        icon: Icons.info,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 14.0,
      );
    }
  }

  Future<void> getSalesforMartCompany(String companyId, String martId) async {
    salesLoader.value = true;
    try {
      SalesModel response =
          await _adminOperationService.getSales(companyId, martId, null);
      if (response.data != null && response.code == 200) {
        getAllBaAttendanceLoader.value = false;
        individualSales.value = response.data ?? [];
        update();
      } else {
        salesLoader.value = false;
      }
    } catch (e) {
      salesLoader.value = false;
    }
  }

  Future<void> getAllCategory(String companyId) async {
    AllCategoryModel response =
        await _companyOperationService.getAllCategories(companyId: companyId);
    if (response.data != null && response.code == 200) {
      categories.value = response.data ?? [];
    }
  }
}
