import 'package:get/get.dart';

class AdminOperation extends GetxController {
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
    // Initialize the list of companies with products
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
