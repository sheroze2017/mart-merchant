import 'package:ba_merchandise/modules/admin/operation/bloc/operation_api.dart';
import 'package:ba_merchandise/modules/admin/operation/model/createUser_model.dart';
import 'package:ba_merchandise/widgets/custom/error_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminOperation extends GetxController {
  var newCompanyLoader = false.obs;
  var newBALoader = false.obs;
  var isBASelected = false.obs;
  var newMartLoader = false.obs;

  final AdminOperationService _adminOperationService = AdminOperationService();

  var companies = <Company>[].obs; // List of companies
  var selectedCompany = Rxn<Company>(); // Currently selected company
  final RxList<Employee> _employees = [
    Employee(
      name: 'John Doe',
      age: 30,
      phoneNumber: '123-456-7890',
      address: '123 Main St, Anytown, USA',
      status: true,
    ),
    Employee(
      name: 'Jane Smith',
      age: 25,
      phoneNumber: '098-765-4321',
      address: '456 Elm St, Othertown, USA',
      status: false,
    ),
    Employee(
      name: 'Bob Johnson',
      age: 40,
      phoneNumber: '555-123-4567',
      address: '789 Oak St, Thistown, USA',
      status: true,
    ),
    Employee(
      name: 'Alice Brown',
      age: 28,
      phoneNumber: '901-234-5678',
      address: '321 Pine St, Thatown, USA',
      status: false,
    ),
    Employee(
      name: 'Mike Davis',
      age: 35,
      phoneNumber: '111-222-3333',
      address: '901 Maple St, Thiscity, USA',
      status: true,
    ),
  ].obs;

  RxList<Employee> get employees => _employees;

  @override
  void onInit() {
    super.onInit();
    companies.value = [
      Company(
        name: 'Company A',
        products: [
          Product(name: 'Product 1', quantity: 10, price: 5.0),
          Product(name: 'Product 2', quantity: 5, price: 3.0),
        ],
      ),
      Company(
        name: 'Company B',
        products: [
          Product(name: 'Product 3', quantity: 8, price: 4.5),
          Product(name: 'Product 4', quantity: 12, price: 6.0),
        ],
      ),
    ];
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
          deviceToken: '',
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
          deviceToken: '',
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
          location: location,
          name: name,
          image: image,
          deviceToken: '',
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

  void changeEmployeeStatus(Employee employee) {
    employee.status = !employee.status;
    update();
    Get.back();
  }

  void selectCompanyByName(String companyName) {
    final company = companies.firstWhere(
      (company) => company.name == companyName,
      orElse: () => throw Exception('Company not found'),
    );
    selectedCompany.value = company;
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
