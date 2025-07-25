import 'package:ba_merchandise/common/style/color.dart';
import 'package:ba_merchandise/common/style/custom_textstyle.dart';
import 'package:ba_merchandise/common/utils/function.dart';
import 'package:ba_merchandise/modules/attendence/widget/status_container.dart';
import 'package:ba_merchandise/widgets/appbar/custom_appbar.dart';
import 'package:ba_merchandise/widgets/dailog/mark_absent_dailog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
// ignore: depend_on_referenced_packages
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart'; // To format date and time
import 'package:location/location.dart' as locat;
import 'package:responsive_sizer/responsive_sizer.dart';
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
  // final SyncController syncController = Get.find();
  @override
  void initState() {
    super.initState();
    getCurrentLocation();
    attendanceController.checkAttendanceApi();
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

  @override
  Widget build(BuildContext context) {
    final String todayDate = DateFormat('yyyy MMM dd').format(DateTime.now());
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: CustomAppBar(
        title: 'Mark Attendance',
      ),
      body: Stack(
        children: [
          Column(
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
                          child: Image(
                              height: 6.h,
                              width: 6.h,
                              image:
                                  const AssetImage('assets/images/marker.png')),
                        ))
                  ],
                ),
              ),
              Obx(
                () => attendanceController.attenToday.value.checkInTime != ''
                    ? Container()
                    : (attendanceController.attenToday.value.checkInTime ==
                                "" &&
                            attendanceController.attenToday.value.status ==
                                true)
                        ? SizedBox()
                        : Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: InkWell(
                                        onTap: () async {
                                          if (!attendanceController
                                              .martAttendanceLoader.value) {
                                            final XFile? image =
                                                await ImagePicker().pickImage(
                                                    source: ImageSource.camera);
                                            if (image != null) {
                                              await attendanceController
                                                  .markAttendanceApi(
                                                      _latitude,
                                                      _longitude,
                                                      context,
                                                      image.path);
                                            }
                                            attendanceController
                                                .checkAttendanceApi();
                                          }
                                        },
                                        child: StatusContainer(
                                          img: 'assets/images/present.png',
                                          number: '',
                                          label: 'Mark attendance',
                                          color: Colors.green,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: InkWell(
                                        onTap: () async {
                                          await attendanceController
                                              .markWeeklyOff(
                                            context,
                                          );
                                          attendanceController
                                              .checkAttendanceApi();
                                        },
                                        child: StatusContainer(
                                          img: 'assets/images/absent.png',
                                          number: '',
                                          label: 'Weekly Off',
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
              ),
              InkWell(
                  child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Obx(
                      () => (attendanceController
                                      .attenToday.value.checkInTime ==
                                  "" &&
                              attendanceController.attenToday.value.status ==
                                  true)
                          ? SizedBox()
                          : attendanceController
                                          .attenToday.value.checkOutTime ==
                                      '' &&
                                  attendanceController
                                          .attenToday.value.status ==
                                      true
                              ? Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => MarkAbsentDialog(
                                          dailogText:
                                              'Are you certain you wish to mark off today?',
                                          onMarkAbsent: () async {
                                            final XFile? image =
                                                await ImagePicker().pickImage(
                                                    source: ImageSource.camera);
                                            if (image != null) {
                                              await attendanceController
                                                  .markCheckoutApi(
                                                      _latitude,
                                                      _longitude,
                                                      context,
                                                      image.path);
                                            }
                                            setState(() {});
                                            attendanceController
                                                .checkAttendanceApi();
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
                    ),
                  ],
                ),
              )),

              Row(
                children: [
                  heading(
                    title: ' Dated:',
                  ),
                  heading(title: todayDate),
                ],
              ),
              Obx(
                () => attendanceController.attenToday.value.status != null
                    ? Row(
                        children: [
                          Text(
                            '   Attendance Status ',
                            style: CustomTextStyles.darkHeadingTextStyle(
                                color: Colors.black),
                          ),
                          Obx(
                            () => Text(
                              (attendanceController
                                              .attenToday.value.checkInTime ==
                                          "" &&
                                      attendanceController
                                              .attenToday.value.status ==
                                          true)
                                  ? 'Weekly Off'
                                  : attendanceController.attenToday.value.status
                                      .toString(),
                              style: CustomTextStyles.lightTextStyle(size: 15),
                            ),
                          )
                        ],
                      )
                    : Container(),
              ),
              Obx(
                () => (attendanceController.attenToday.value.checkInTime ==
                            "" &&
                        attendanceController.attenToday.value.status == true)
                    ? SizedBox()
                    : attendanceController.attenToday.value.status == true
                        ? Row(
                            children: [
                              Text(
                                '   checkin time ',
                                style: CustomTextStyles.darkHeadingTextStyle(
                                    color: Colors.green),
                              ),
                              Obx(
                                () => Text(
                                  '${Utils.formatDate(attendanceController.attenToday.value.checkInTime.toString())} ${Utils.formatTime(attendanceController.attenToday.value.checkInTime.toString())}',
                                  style: CustomTextStyles.lightTextStyle(),
                                ),
                              )
                            ],
                          )
                        : Container(),
              ),
              Obx(() => attendanceController.attenToday.value.checkOutTime != ''
                  ? Row(
                      children: [
                        Text(
                          '   checkout time ',
                          style: CustomTextStyles.darkHeadingTextStyle(
                              color: Colors.red),
                        ),
                        Text(
                          Utils.formatDate(attendanceController
                                  .attenToday.value.checkOutTime
                                  .toString()) +
                              ' ' +
                              Utils.formatTime(attendanceController
                                  .attenToday.value.checkOutTime
                                  .toString()),
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
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: Obx(() => !attendanceController.martAttendanceLoader.value
                ? const SizedBox()
                : Container(
                    color: Colors.black.withOpacity(0.4),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryColorDark,
                      ),
                    ),
                  )),
          )
        ],
      ),
    );
  }
}
