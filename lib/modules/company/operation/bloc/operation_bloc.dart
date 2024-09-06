import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../model/operation_model.dart';

class OperationBloc extends GetxController {
  List<String> employeeRole = ['B.A', 'Merchant'];
  RxList<Location> locations = [
    Location(
      placeId: '1',
      placeName: 'Central Park',
      latitude: 40.785091,
      longitude: -73.968285,
    ),
    Location(
      placeId: '2',
      placeName: 'Eiffel Tower',
      latitude: 48.858844,
      longitude: 2.294351,
    ),
    Location(
      placeId: '3',
      placeName: 'Sydney Opera House',
      latitude: -33.856784,
      longitude: 151.213108,
    ),
    Location(
        placeId: '4',
        placeName: 'Great Wall of China',
        latitude: 40.431908,
        longitude: 116.570)
  ].obs;

  RxList<Employee> employees = [
    Employee(
      userId: 1,
      name: 'Alice Johnson',
      email: 'alice.johnson@example.com',
      phone: '+1-555-1234',
      age: 29,
      role: 'Store Supervisor',
      gender: 'Female',
      location: Location(
        placeId: '101',
        placeName: 'Central Park',
        latitude: 40.785091,
        longitude: -73.968285,
      ),
      imageUrl: 'assets/images/person.jpeg',
    ),
    Employee(
      userId: 2,
      name: 'Bob Williams',
      email: 'bob.williams@example.com',
      phone: '+1-555-5678',
      age: 34,
      role: 'Floor Manager',
      gender: 'Male',
      location: Location(
        placeId: '102',
        placeName: 'Eiffel Tower',
        latitude: 48.858844,
        longitude: 2.294351,
      ),
      imageUrl: 'assets/images/bob_williams.png',
    ),
    Employee(
      userId: 3,
      name: 'Catherine Lee',
      email: 'catherine.lee@example.com',
      phone: '+1-555-8765',
      age: 27,
      role: 'Inventory Supervisor',
      gender: 'Female',
      location: Location(
        placeId: '103',
        placeName: 'Sydney Opera House',
        latitude: -33.856784,
        longitude: 151.213108,
      ),
      imageUrl: 'assets/images/catherine_lee.png',
    ),
    Employee(
      userId: 4,
      name: 'Daniel Martinez',
      email: 'daniel.martinez@example.com',
      phone: '+1-555-4321',
      age: 40,
      role: 'Regional Manager',
      gender: 'Male',
      location: Location(
        placeId: '104',
        placeName: 'Great Wall of China',
        latitude: 40.431908,
        longitude: 116.570374,
      ),
      imageUrl: 'assets/images/daniel_martinez.png',
    ),
    Employee(
      userId: 5,
      name: 'Emma Davis',
      email: 'emma.davis@example.com',
      phone: '+1-555-3456',
      age: 31,
      role: 'Cashier Supervisor',
      gender: 'Female',
      location: Location(
        placeId: '105',
        placeName: 'Machu Picchu',
        latitude: -13.163141,
        longitude: -72.544963,
      ),
      imageUrl: 'assets/images/emma_davis.png',
    ),
  ].obs;
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
