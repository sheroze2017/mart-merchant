import 'package:ba_merchandise/common/style/custom_textstyle.dart';
import 'package:ba_merchandise/modules/attendence/widget/status_container.dart';
import 'package:ba_merchandise/modules/sync/bloc/sync_bloc.dart';
import 'package:ba_merchandise/widgets/appbar/custom_appbar.dart';
import 'package:ba_merchandise/widgets/dailog/mark_absent_dailog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// ignore: depend_on_referenced_packages
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart'; // To format date and time
import 'package:location/location.dart' as locat;

import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';
import '../../b.a/dashboard/view/dashboard.dart';
import '../bloc/attendance_bloc.dart';

class AttendanceScreen extends StatefulWidget {
  @override
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final locat.Location _location = locat.Location();
  final Map<String, Marker> _markers = {};
  double _latitude = 0.00;
  double _longitude = 0.00;
  final double _zoom = 15;

  GoogleMapController? _mapController;
  BitmapDescriptor _markerIcon = BitmapDescriptor.defaultMarker;

  String _placeName = '';
  String _placeId = '';
  final attendanceController = Get.put(AttendanceController());
  final SyncController syncController = Get.find();

  // LatLng? _currentLocation;
  // final LatLng _targetLocation =
  //     LatLng(24.929681, 67.039365); // Example: San Francisco
  // final double _radius = 50.0; // 50 meters radius
  // String formattedDateTime = '';
  // String checkOutTime = '';

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  getCurrentLocation() async {
    bool serviceEnabled;
    locat.PermissionStatus permissionGranted;

    serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await _location.hasPermission();
    if (permissionGranted == locat.PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != locat.PermissionStatus.granted) {
        return;
      }
    }

    locat.LocationData currentPosition = await _location.getLocation();
    _latitude = currentPosition.latitude!;
    _longitude = currentPosition.longitude!;
    final marker = Marker(
      icon: _markerIcon,
      markerId: const MarkerId('myLocation'),
      position: LatLng(_latitude, _longitude),
      infoWindow: const InfoWindow(
        title: 'you can add any message here',
      ),
    );
    setState(() {
      _markers['myLocation'] = marker;
      _mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(_latitude, _longitude), zoom: _zoom),
        ),
      );
    });
  }

  Future<void> _checkPermission() async {
    var status = await Permission.location.status;
    if (status.isGranted) {
      attendanceController.getCurrentLocation();
    } else if (status.isDenied) {
      if (await Permission.location.request().isGranted) {
        attendanceController.getCurrentLocation();
      } else {
        Fluttertoast.showToast(msg: "Location permission denied.");
      }
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  @override
  Widget build(BuildContext context) {
    final String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Attendance',
        accType: 'Merchant',
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 40.h,
            width: 100.w,
            child: Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(_latitude, _longitude),
                    zoom: _zoom,
                  ),
                  onMapCreated: (controller) {
                    _mapController = controller;
                  },
                  markers: _markers.values.toSet(),
                ),
                Positioned(
                    bottom: 30,
                    left: 10,
                    child: InkWell(
                      onTap: () {
                        getCurrentLocation();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Column(
                            children: [
                              Icon(Icons.pin_drop),
                              Text(
                                'Point Your Location',
                                style:
                                    CustomTextStyles.lightTextStyle(size: 10),
                              )
                            ],
                          ),
                        ),
                      ),
                    ))
              ],
            ),
          ),
          Obx(
            () => attendanceController.formattedDateTime.value.isNotEmpty ||
                    (syncController.userAttendance.last.date!
                            .contains(todayDate) &&
                        (syncController.userAttendance.last.status == false ||
                            syncController.userAttendance.last.status == true))
                ? Container()
                : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              attendanceController.markAttendance(todayDate);
                            },
                            child: StatusContainer(
                              img: 'assets/images/present.png',
                              number: '',
                              label: 'Mark attendence',
                              color: Colors.green,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
          InkWell(
              child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Obx(
              () => Row(
                children: [
                  syncController.userAttendance.last.date!
                              .contains(todayDate) &&
                          syncController.userAttendance.last.status == true &&
                          syncController.userAttendance.last.checkOutTime ==
                              null
                      ? Expanded(
                          child: InkWell(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => MarkAbsentDialog(
                                  dailogText:
                                      'Are you certain you wish to mark off today?',
                                  onMarkAbsent: () async {
                                    await attendanceController.checkOut();
                                    Get.back();
                                  },
                                  markAbsentText: 'Mark Off',
                                ),
                              );
                            },
                            child: StatusContainer(
                              img: 'assets/images/timeoff.png',
                              number: '',
                              label: 'Time Off',
                              color: Colors.red,
                            ),
                          ),
                        )
                      : Container(),
                  syncController.userAttendance.last.date!.contains(todayDate)
                      ? Container()
                      : Expanded(
                          child: InkWell(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => MarkAbsentDialog(
                                  dailogText:
                                      'Are you certain you wish to mark today as absent?',
                                  onMarkAbsent: () {
                                    attendanceController.markAbsent(todayDate);
                                  },
                                  markAbsentText: 'Mark Absent',
                                ),
                              );
                            },
                            child: StatusContainer(
                              img: 'assets/images/absent.png',
                              number: '',
                              label: 'Absent',
                              color: Colors.red,
                            ),
                          ),
                        )
                ],
              ),
            ),
          )),
          SizedBox(
            height: 1.h,
          ),
          Row(
            children: [
              heading(
                title: ' Dated:',
              ),
              heading(title: todayDate),
            ],
          ),
          Obx(
            () => syncController.userAttendance.last.date!.contains(todayDate)
                ? Row(
                    children: [
                      Text(
                        '   Attendance Status ',
                        style: CustomTextStyles.darkHeadingTextStyle(
                            color: Colors.black),
                      ),
                      Obx(
                        () => Text(
                          syncController.userAttendance.last.status.toString(),
                          style: CustomTextStyles.lightTextStyle(),
                        ),
                      )
                    ],
                  )
                : Container(),
          ),
          Obx(
            () =>
                syncController.userAttendance.last.date!.contains(todayDate) &&
                        syncController.userAttendance.last.status!
                    ? Row(
                        children: [
                          Text(
                            '   checkin time ',
                            style: CustomTextStyles.darkHeadingTextStyle(
                                color: Colors.green),
                          ),
                          Obx(
                            () => Text(
                              syncController.userAttendance.last.checkInTime
                                  .toString(),
                              style: CustomTextStyles.lightTextStyle(),
                            ),
                          )
                        ],
                      )
                    : Container(),
          ),
          Obx(() =>
              syncController.userAttendance.last.date!.contains(todayDate) &&
                      syncController.userAttendance.last.checkOutTime != null
                  ? Row(
                      children: [
                        Text(
                          '   checkout time ',
                          style: CustomTextStyles.darkHeadingTextStyle(
                              color: Colors.red),
                        ),
                        Text(
                          syncController.userAttendance.last.checkOutTime
                              .toString(),
                          style: CustomTextStyles.lightTextStyle(),
                        ),
                      ],
                    )
                  : Container())

          // formattedDateTime.isNotEmpty || checkOutTime.isNotEmpty
          //     ? Padding(
          //         padding: const EdgeInsets.all(16.0),
          //         child: StatusContainer(
          //             img: 'assets/images/present.png',
          //             number: '',
          //             label:
          //                 'time in : ${formattedDateTime}\ntime out: ${checkOutTime}',
          //             color: Colors.grey),
          //       )
          //     : Container()
        ],
      ),
    );
  }
}
