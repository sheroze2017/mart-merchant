// import 'package:ba_merchandise/modules/sync/bloc/sync_bloc.dart';
// import 'package:ba_merchandise/modules/sync/model/user_sync_model.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:get/get.dart';
// import 'package:hive/hive.dart';
// import 'package:intl/intl.dart'; // To format date and time
// import 'package:latlong2/latlong.dart';

// class AttendanceController extends GetxController {
//   Rx<LatLng?> currentLocation = Rx<LatLng?>(null);
//   final double _radius = 50.0; // 50 meters radius
//   var formattedDateTime = ''.obs;
//   var checkOutTime = ''.obs;
//   final SyncController syncController = Get.find();

//   late Box<Attendance> attendanceBox;

//   @override
//   void onInit() {
//     super.onInit();
//     getCurrentLocation();
//     attendanceBox = Hive.box<Attendance>('attendanceBox');
//   }

//   void getCurrentLocation() async {
//     Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);
//     currentLocation.value = LatLng(position.latitude, position.longitude);
//   }

//   Future<void> markAttendance(String today) async {
//     if (currentLocation == null) {
//       Fluttertoast.showToast(msg: "Unable to get current location.");
//       return;
//     }

//     double distanceInMeters = Geolocator.distanceBetween(
//       currentLocation.value!.latitude,
//       currentLocation.value!.longitude,
//       syncController.userLocation[0].latitude,
//       syncController.userLocation[0].longitude,
//     );

//     if (distanceInMeters <= _radius) {
//       Fluttertoast.showToast(msg: "Attendance marked successfully!");
//       DateTime now = DateTime.now();
//       formattedDateTime.value =
//           await DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
//       Attendance attendance = Attendance(
//           date: today,
//           status: true,
//           checkInTime: DateFormat('yyyy-MM-dd HH:mm:ss').format(now));
//       attendanceBox.put(today, attendance);
//     } else {
//       Fluttertoast.showToast(msg: "You are not within the attendance radius.");
//     }
//   }

//   Future<void> checkOut(today) async {
//     if (currentLocation == null) {
//       Fluttertoast.showToast(msg: "Unable to get current location.");
//       return;
//     }

//     double distanceInMeters = Geolocator.distanceBetween(
//       currentLocation.value!.latitude,
//       currentLocation.value!.longitude,
//       syncController.userLocation[0].latitude,
//       syncController.userLocation[0].longitude,
//     );

//     if (distanceInMeters <= _radius) {
//       Fluttertoast.showToast(msg: "Checkout marked successfully!");
//       DateTime now = DateTime.now();
//       checkOutTime.value = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
      // Attendance? attendance =
      //     attendanceBox.get(DateFormat('yyyy-MM-dd').format(now));
      // if (attendance != null) {
      //   attendance.checkOutTime = checkOutTime.value;
      //   attendanceBox.put(today, attendance);
//       }
//     } else {
//       Fluttertoast.showToast(msg: "You are not within the attendance radius.");
//     }
//   }

//   Future<void> markAbsent(String todayDate) async {
//     Attendance attendance = Attendance(date: todayDate, status: false);
//     attendanceBox.put(todayDate, attendance);
//     Get.back();
//   }
// }
