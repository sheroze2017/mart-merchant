import 'package:ba_merchandise/common/style/color.dart';
import 'package:ba_merchandise/widgets/button/rounded_button.dart';
import 'package:ba_merchandise/widgets/textfield/search_textfield.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  final Set<Marker> _markers = {};
  TextEditingController _searchController = TextEditingController();
  Position? _currentLocation;
  String? _currentAddress;
  CameraPosition cm = const CameraPosition(target: LatLng(0, 0));

  @override
  void initState() {
    super.initState();
    // _getCurrentLocation();
  }

  Future<String> _getPlaceName(double lat, double lng) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
    if (placemarks != null && placemarks.isNotEmpty) {
      Placemark placemark = placemarks[0];
      _searchController.text ==
          ('${placemark.name} ${placemark.subLocality} ${placemark.locality}');
      return placemark.name ?? '';
    } else {
      return '';
    }
  }

  void _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar('Location Error', 'Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      Get.snackbar(
          'Location Error', 'Location permissions are permanently denied.');
    }
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        Get.snackbar('Location Error', 'Location permissions are denied.');
      }
    }

    try {
      Position position = await Geolocator.getCurrentPosition();

      setState(() {
        _currentLocation = position;
      });

      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      _updateMarkers(position.latitude, position.longitude);
      if (placemarks != null && placemarks.isNotEmpty) {
        Placemark placemark = placemarks[0];
        String address = placemark.name ?? '';
        setState(() {
          _currentAddress = address;
        });
      }
      _getPlaceName(position.latitude, position.longitude);
      if (mapController != null) {
        mapController.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(position.latitude, position.longitude),
            zoom: 14.0,
          ),
        ));
      }
    } catch (e) {
      Get.snackbar('Location Error', 'Failed to get location: $e');
    } finally {
      setState(() {});
    }
  }

  void _updateMarkers(double lat, double lng) {
    setState(() {
      _markers.clear();
      _markers.add(
        Marker(
          markerId: MarkerId('current_location'),
          position: LatLng(lat, lng),
          draggable: true,
          onDragEnd: (value) {},
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          infoWindow: InfoWindow(
            title: _currentAddress ?? 'Current Location',
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _getCurrentLocation();
        },
        child: Icon(Icons.pin_drop),
      ),
      body: Stack(
        children: [
          GoogleMap(
            zoomControlsEnabled: false,
            onMapCreated: (GoogleMapController controller) {
              mapController = controller;
            },
            onCameraMove: (position) {
              cm = position;
              setState(() {});
              _updateMarkers(
                  position.target.latitude, position.target.longitude);
            },
            onCameraIdle: () {
              _getPlaceName(cm.target.latitude, cm.target.longitude);
            },
            initialCameraPosition: CameraPosition(
              target: LatLng(
                _currentLocation?.latitude ?? 45.521563,
                _currentLocation?.longitude ?? -122.677433,
              ),
              zoom: 14.0,
            ),
            onLongPress: (argument) async {
              _updateMarkers(argument.latitude, argument.longitude);
              List<Placemark> placemarks = await placemarkFromCoordinates(
                argument.latitude,
                argument.longitude,
              );
              _getPlaceName(argument.latitude, argument.longitude);
            },
            markers: _markers,
            myLocationEnabled: true,
          ),
          Positioned(
              top: 50,
              left: 20,
              right: 20,
              child: RoundedSearchTextField(
                controller: _searchController,
                hintText: 'Location',
              )),
          Positioned(
              bottom: 20,
              left: 20,
              right: 100,
              child: RoundedButton(
                backgroundColor: AppColors.blackColor,
                text: 'Set Location',
                onPressed: () {
                  if (_searchController.text.isEmpty) {
                    //  showErrorMessage(context, 'Please select location');
                  } else {
                    Navigator.pop(context, {
                      'latitude': cm.target.latitude,
                      'longitude': cm.target.longitude,
                      'searchValue': _searchController.text
                    });
                  }
                },
                textColor: AppColors.whiteColor,
              )),
        ],
      ),
    );
  }
}
