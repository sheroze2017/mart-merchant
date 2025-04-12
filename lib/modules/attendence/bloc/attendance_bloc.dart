import 'package:ba_merchandise/core/local/hive_db/hive.dart';
import 'package:ba_merchandise/main.dart';
import 'package:ba_merchandise/modules/attendence/bloc/attendance_api.dart';
import 'package:ba_merchandise/modules/sync/bloc/sync_bloc.dart';
import 'package:ba_merchandise/widgets/custom/error_toast.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart'; // To format date and time
// ignore: depend_on_referenced_packages
import 'package:latlong2/latlong.dart';

class AttendanceController extends GetxController {
  final AttendanceService _attendanceService = AttendanceService();
  var martAttendanceLoader = false.obs;
  Rx<LatLng?> currentLocation = Rx<LatLng?>(null);
  final double _radius = 50.0;
  final SyncController syncController = Get.find();
  late Rx<Attendance> attenToday = Attendance().obs;
  String today = DateFormat('yyyy-MMM-dd').format(DateTime.now());

  @override
  void onInit() async {
    super.onInit();
    getCurrentLocation();
    // getTodayAttendance();
    checkAttendanceApi();
  }

  Future<void> markAttendanceApi(
      double latitude, double longitude, context) async {
    martAttendanceLoader.value = true;
    try {
      final response = await _attendanceService.attendance(
          lat: latitude.toString(), lng: longitude.toString());
      if (response['data'] != null && response['code'] == 200) {
        martAttendanceLoader.value = false;
        DateTime now = DateTime.now();
        Attendance attendance = Attendance(
            date: today,
            status: true,
            checkOutTime: '',
            checkInTime: DateFormat('yyyy-MM-dd HH:mm:ss').format(now));
        attenToday.value = attendance;
        attendanceBox.put(today, attendance);
        AnimatedSnackbar.showSnackbar(
          context: context,
          message: response['message'].toString(),
          icon: Icons.info,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 14.0,
        );
      } else {
        martAttendanceLoader.value = false;
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
      martAttendanceLoader.value = false;
    }
  }

  Future<void> checkAttendanceApi() async {
    try {
      final response = await _attendanceService.checkAttendance();
      if (response['data'] != null && response['code'] == 200) {
        Attendance attendance = Attendance(
          date: today,
          status: true,
          checkOutTime: response['data']['checkout_time'] ?? '',
          checkInTime: response['data']['checkin_time'] ?? '',
        );
        attenToday.value = attendance;
        attendanceBox.put(today, attendance);
      } else {}
    } catch (e) {}
  }

  void getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentLocation.value = LatLng(position.latitude, position.longitude);
  }

  // void getTodayAttendance() async {
  //   Attendance? attendance = attendanceBox.get(today);
  //   if (attendance != null) {
  //     attenToday.value = attendance;
  //     print(attendance.checkInTime);
  //   }
  // }

  Future<void> markAttendance(double latitude, double longitude) async {
    double distanceInMeters = Geolocator.distanceBetween(
      latitude,
      longitude,
      syncController.userLocation[0].latitude,
      syncController.userLocation[0].longitude,
    );

    if (distanceInMeters <= _radius) {
      DateTime now = DateTime.now();
      Attendance attendance = Attendance(
          date: today,
          status: true,
          checkOutTime: '',
          checkInTime: DateFormat('yyyy-MM-dd HH:mm:ss').format(now));

      attenToday.value = attendance;
      attendanceBox.put(today, attendance);
      Fluttertoast.showToast(msg: "Attendance marked successfully!");
      Attendance? at = attendanceBox.get(today);
      print(at!.checkInTime.toString());
    } else {
      Fluttertoast.showToast(msg: "You are not within the attendance radius.");
    }
  }

  Future<void> checkOut(double latitude, double longitude) async {
    double distanceInMeters = Geolocator.distanceBetween(
      latitude,
      longitude,
      syncController.userLocation[0].latitude,
      syncController.userLocation[0].longitude,
    );

    if (distanceInMeters <= _radius) {
      DateTime now = DateTime.now();
      Attendance? at = attendanceBox.get(today);
      if (at != null) {
        at.checkOutTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
        attendanceBox.put(today, at);
        attenToday.value = at;
        Fluttertoast.showToast(msg: "Checkout marked successfully!");
        Get.back();
      } else {
        Fluttertoast.showToast(msg: "No attendance record found for today!");
      }
    } else {
      Fluttertoast.showToast(msg: "You are not within the attendance radius.");
    }
  }

  Future<void> markCheckoutApi(
      double latitude, double longitude, context) async {
    martAttendanceLoader.value = true;
    try {
      final response = await _attendanceService.attendance(
          lat: latitude.toString(), lng: longitude.toString());
      if (response['data'] != null && response['code'] == 200) {
        martAttendanceLoader.value = false;
        DateTime now = DateTime.now();
        Attendance? at = attendanceBox.get(today);
        if (at != null) {
          at.checkOutTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
          attendanceBox.put(today, at);
          attenToday.value = at;
          Get.back();
          AnimatedSnackbar.showSnackbar(
            context: context,
            message: response['message'].toString(),
            icon: Icons.info,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 14.0,
          );
        }
      } else {
        martAttendanceLoader.value = false;
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
      martAttendanceLoader.value = false;
    }
  }

  Future<void> markAbsent(String todayDate) async {
    attenToday.value = Attendance(date: todayDate, status: false);
    attendanceBox.put(todayDate, attenToday.value);
    Get.back();
  }
}
