import 'package:ba_merchandise/common/style/custom_textstyle.dart';
import 'package:ba_merchandise/modules/attendence/widget/status_container.dart';
import 'package:ba_merchandise/modules/sync/bloc/sync_bloc.dart';
import 'package:ba_merchandise/widgets/appbar/custom_appbar.dart';
import 'package:ba_merchandise/widgets/dailog/mark_absent_dailog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:intl/intl.dart'; // To format date and time
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import '../../b.a/dashboard/view/dashboard.dart';
import '../../b.a/dashboard/widget/gradient_card.dart';
import '../bloc/attendance_bloc.dart';

class AttendanceScreen extends StatefulWidget {
  @override
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
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
    _checkPermission();
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
                FlutterMap(
                  options: MapOptions(
                      initialCenter:
                          attendanceController.currentLocation.value ??
                              LatLng(24.929681, 67.039365),
                      initialZoom: 15),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                      subdomains: ['a', 'b', 'c'],
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          width: 80.0,
                          height: 80.0,
                          point: LatLng(24.929681, 67.039365),
                          child: Icon(Icons.location_on, color: Colors.red),
                        ),
                        if (attendanceController.currentLocation.value != null)
                          Marker(
                            width: 80.0,
                            height: 80.0,
                            point: attendanceController.currentLocation.value!,
                            child: Icon(Icons.location_on, color: Colors.blue),
                          ),
                      ],
                    ),
                  ],
                ),
                Positioned(
                    bottom: 10,
                    right: 10,
                    child: InkWell(
                      onTap: () {
                        _checkPermission();
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
                          syncController
                              .userAttendance.last.checkOutTime!.isEmpty
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
                title: ' Your Today Timing',
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
                            color: Colors.green),
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
          Obx(() => syncController.userAttendance.last.date!
                      .contains(todayDate) &&
                  syncController.userAttendance.last.checkOutTime!.isNotEmpty
              ? Row(
                  children: [
                    Text(
                      '   checkout time ',
                      style: CustomTextStyles.darkHeadingTextStyle(
                          color: Colors.red),
                    ),
                    Obx(
                      () => Text(
                        syncController.userAttendance.last.checkOutTime
                            .toString(),
                        style: CustomTextStyles.lightTextStyle(),
                      ),
                    )
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
