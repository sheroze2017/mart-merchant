import 'dart:convert';

import 'package:ba_merchandise/modules/sync/model/user_sync_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // To format date and time
import 'package:shared_preferences/shared_preferences.dart';

import '../model/user_detail.dart';

class SyncController extends GetxController with WidgetsBindingObserver {
  var username = ''.obs;
  var userRole = ''.obs;

  Rx<AppData> appData = AppData().obs;

  RxList<Location> userLocation = <Location>[].obs;
  RxList<Product> userProducts = <Product>[].obs;
  RxList<Sales> userSales = <Sales>[].obs;
  RxList<AttendanceAll> userAttendance = <AttendanceAll>[].obs;
  RxList<ULocations> uLocation = <ULocations>[].obs;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    loadJsonUserData();
    loadJsonData();
  }

  void loadAppData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonData = prefs.getString('appData');
    if (jsonData != null) {
      appData.value = await AppData.fromJson(json.decode(jsonData));
      userRole.value = appData.value.personalInfo!.userRole;
      username.value = appData.value.personalInfo!.name;
      userLocation.value = appData.value.locations;
      userProducts.value = appData.value.products;
      userAttendance.value = appData.value.attendance;
      userSales.value = appData.value.sales;
    } else {
      initializeEmptyData();
    }
  }

  void initializeEmptyData() async {
    DateTime now = DateTime.now();
    DateTime yesterday = now.subtract(Duration(days: 1));

    String date = await DateFormat('yyyy-MM-dd').format(yesterday);

    appData.value = await AppData(
      personalInfo: PersonalInfo(),
      attendance: [
        AttendanceAll(
            date: date,
            checkInTime: '00:00:00',
            checkOutTime: '00:00:00',
            status: false)
      ],
      locations: [],
      products: [],
      sales: [],
    );
    userRole.value = appData.value.personalInfo!.userRole;
    username.value = appData.value.personalInfo!.name;
    userLocation.value = appData.value.locations;
    userProducts.value = appData.value.products;
    userAttendance.value = appData.value.attendance;
    userSales.value = appData.value.sales;
  }

  void saveAppData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    appData.value = await AppData(
      sales: userSales,
      personalInfo:
          PersonalInfo(age: 0, userRole: userRole.value, name: username.value),
      attendance: userAttendance,
      locations: userLocation,
      products: userProducts,
    );
    prefs.setString('appData', json.encode(appData.value.toJson()));
  }

  Future<void> loadJsonUserData() async {
    final String userDetail = await rootBundle.loadString('assets/data1.json');
    final userData = json.decode(userDetail);
    var userInfo = UserDetails.fromJson(userData);
    var location = userInfo.locations;
    var products = userInfo.products;
    var personalInfo = userInfo.userInfo;
    uLocation.value = location!.toList();
  }

  Future<void> loadJsonData() async {
    final String response = await rootBundle.loadString('assets/data.json');
    final data = json.decode(response);
    var personalInfo = PersonalInfo.fromJson(data['personalInfo']);
    var locations = (data['locations'] as List)
        .map((loc) => Location.fromJson(loc))
        .toList();
    var products = (data['products'] as List)
        .map((prod) => Product.fromJson(prod))
        .toList();
    var sales =
        (data['sales'] as List).map((sale) => Sales.fromJson(sale)).toList();

    var attendance = (data['attendance'] as List)
        .map((atten) => AttendanceAll.fromJson(atten))
        .toList();

    userRole.value = personalInfo.userRole;
    username.value = personalInfo.name;
    userLocation.value = locations;
    userProducts.value = products;
    userAttendance.value = attendance;
    userSales.value = sales;
  }

  @override
  void onClose() {
    saveAppData();
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      saveAppData();
    }
  }
}
