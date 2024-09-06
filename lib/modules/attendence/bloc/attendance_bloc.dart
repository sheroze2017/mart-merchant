import 'package:ba_merchandise/modules/sync/bloc/sync_bloc.dart';
import 'package:ba_merchandise/modules/sync/model/user_sync_model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart'; // To format date and time
// ignore: depend_on_referenced_packages
import 'package:latlong2/latlong.dart';

class AttendanceController extends GetxController {
  Rx<LatLng?> currentLocation = Rx<LatLng?>(null);
  final double _radius = 50.0;
  // var formattedDateTime = ''.obs;
  // var checkOutTime = ''.obs;
  final SyncController syncController = Get.find();
  late Rx<Attendance> attenToday = Attendance().obs;
  @override
  void onInit() {
    super.onInit();
    getCurrentLocation();
    getTodayAttendance();
  }

  void getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentLocation.value = LatLng(position.latitude, position.longitude);
  }

  getTodayAttendance() {
    String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    attenToday.value = syncController.userAttendance.firstWhere(
      (att) => att.date == today,
      orElse: () => Attendance(),
    );
  }

  Future<void> markAttendance(
      String today, double latitude, double longitude) async {
    double distanceInMeters = Geolocator.distanceBetween(
      latitude,
      longitude,
      syncController.userLocation[0].latitude,
      syncController.userLocation[0].longitude,
    );

    if (distanceInMeters <= _radius) {
      Fluttertoast.showToast(msg: "Attendance marked successfully!");
      DateTime now = DateTime.now();
      // formattedDateTime.value =
      //     await DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
      syncController.userAttendance.add(Attendance(
          date: today,
          status: true,
          checkInTime: DateFormat('yyyy-MM-dd HH:mm:ss').format(now)));
    } else {
      Fluttertoast.showToast(msg: "You are not within the attendance radius.");
    }
  }

  Future<void> checkOut(latitude, longitude, today) async {
    double distanceInMeters = Geolocator.distanceBetween(
      latitude,
      longitude,
      syncController.userLocation[0].latitude,
      syncController.userLocation[0].longitude,
    );

    if (distanceInMeters <= _radius) {
      Fluttertoast.showToast(msg: "checkout marked successfully!");
      DateTime now = DateTime.now();
      //checkOutTime.value = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
      final attendanceIndex =
          syncController.userAttendance.indexWhere((att) => att.date == today);

      if (attendanceIndex != -1) {
        // Get the existing attendance
        final existingAttendance =
            syncController.userAttendance[attendanceIndex];

        // Create a new Attendance object with updated checkout time
        Attendance updatedAttendance = Attendance(
          date: existingAttendance.date,
          status: existingAttendance.status,
          checkInTime: existingAttendance.checkInTime,
          checkOutTime: DateFormat('yyyy-MM-dd HH:mm:ss')
              .format(now), // Set the new checkout time
        );

        // Update the attendance entry in the list
        syncController.userAttendance[attendanceIndex] = updatedAttendance;
      } else {
        // If no attendance found for today, handle the case
        Fluttertoast.showToast(msg: "No attendance record found for today!");
      }
      // syncController.userAttendance
      // syncController.userAttendance.last.checkOutTime =
      //     DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    } else {
      Fluttertoast.showToast(msg: "You are not within the attendance radius.");
    }
  }

  Future<void> markAbsent(String todayDate) async {
    syncController.userAttendance
        .add(Attendance(date: todayDate, status: false));

    Get.back();
  }
}
