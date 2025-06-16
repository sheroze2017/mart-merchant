import 'package:ba_merchandise/core/local/hive_db/hive.dart';
import 'package:ba_merchandise/main.dart';
import 'package:ba_merchandise/modules/admin/operation/bloc/media_bloc.dart';
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

  Future<void> markAttendanceApi(double latitude, double longitude,
      BuildContext context, String imagePath) async {
    martAttendanceLoader.value = true;
    String todayDateTime =
        DateFormat('yyyy MMM dd HH:mm:ss').format(DateTime.now());

    try {
      final MediaBloc mediaBloc = Get.put(MediaBloc());
      await mediaBloc.uploadPhoto(imagePath, context);
      String uploadedImageUrl = mediaBloc.imgUrl.value;
      if (uploadedImageUrl.isEmpty) {
        AnimatedSnackbar.showSnackbar(
          context: context,
          message: 'Error uploading image',
          icon: Icons.info,
          backgroundColor: const Color.fromARGB(255, 241, 235, 235),
          textColor: Colors.black,
          fontSize: 14.0,
        );
        martAttendanceLoader.value = false;
        return;
      }
      final response = await _attendanceService.attendance(
        lat: latitude.toString(),
        lng: longitude.toString(),
        imageUrl: uploadedImageUrl,
        time: todayDateTime,
      );

      if (response['data'] != null && response['code'] == 200) {
        martAttendanceLoader.value = false;
        DateTime now = DateTime.now();
        Attendance attendance = Attendance(
          date: today,
          status: true,
          checkOutTime: '',
          checkInTime: DateFormat('yyyy-MM-dd HH:mm:ss').format(now),
        );
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
          backgroundColor: const Color.fromARGB(255, 241, 235, 235),
          textColor: Colors.black,
          fontSize: 14.0,
        );
      }
    } catch (e) {
      martAttendanceLoader.value = false;
      debugPrint('Attendance API error: $e');
    }
  }

  Future<void> markWeeklyOff(BuildContext context) async {
    martAttendanceLoader.value = true;

    try {
      final response = await _attendanceService.weeklyOff();

      if (response['data'] != null && response['code'] == 200) {
        martAttendanceLoader.value = false;
        DateTime now = DateTime.now();
        Attendance attendance = Attendance(
          date: today,
          status: false,
          checkOutTime: '',
          checkInTime: DateFormat('yyyy-MM-dd HH:mm:ss').format(now),
        );
        attenToday.value = attendance;
        attendanceBox.put(today, attendance);
        AnimatedSnackbar.showSnackbar(
          context: context,
          message: 'Weekly off marked',
          icon: Icons.info,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 14.0,
        );
      } else {
        martAttendanceLoader.value = false;
        AnimatedSnackbar.showSnackbar(
          context: context,
          message: response['message'].toString(),
          icon: Icons.info,
          backgroundColor: const Color.fromARGB(255, 241, 235, 235),
          textColor: Colors.black,
          fontSize: 14.0,
        );
      }
    } catch (e) {
      martAttendanceLoader.value = false;
      debugPrint('Attendance API error: $e');
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

  Future<void> markCheckoutApi(double latitude, double longitude,
      BuildContext context, String imagePath) async {
    martAttendanceLoader.value = true;
    String todayDateTime =
        DateFormat('yyyy MMM dd HH:mm:ss').format(DateTime.now());

    try {
      // Upload image using MediaBloc
      final MediaBloc mediaBloc = Get.put(MediaBloc());
      await mediaBloc.uploadPhoto(imagePath, context);
      String uploadedImageUrl = mediaBloc.imgUrl.value;
      if (uploadedImageUrl.isEmpty) {
        AnimatedSnackbar.showSnackbar(
          context: context,
          message: 'Error uploading image',
          icon: Icons.info,
          backgroundColor: const Color.fromARGB(255, 241, 235, 235),
          textColor: Colors.black,
          fontSize: 14.0,
        );
        martAttendanceLoader.value = false;
        return;
      }
      Get.back();
      final response = await _attendanceService.attendance(
        lat: latitude.toString(),
        lng: longitude.toString(),
        imageUrl: uploadedImageUrl,
        time: todayDateTime,
      );

      if (response['data'] != null && response['code'] == 200) {
        martAttendanceLoader.value = false;
        DateTime now = DateTime.now();
        Attendance? at = attendanceBox.get(today);
        if (at != null) {
          at.checkOutTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
          attendanceBox.put(today, at);
          attenToday.value = at;

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
          backgroundColor: const Color.fromARGB(255, 241, 235, 235),
          textColor: Colors.black,
          fontSize: 14.0,
        );
      }
    } catch (e) {
      martAttendanceLoader.value = false;
      debugPrint('Checkout API error: $e');
    }
  }

  Future<void> markAbsent(String todayDate) async {
    attenToday.value = Attendance(date: todayDate, status: false);
    attendanceBox.put(todayDate, attenToday.value);
    Get.back();
  }
}
