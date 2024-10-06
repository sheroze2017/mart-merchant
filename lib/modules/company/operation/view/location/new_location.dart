import 'package:ba_merchandise/common/style/color.dart';
import 'package:ba_merchandise/modules/b.a/dashboard/view/dashboard.dart';
import 'package:ba_merchandise/modules/company/operation/bloc/operation_bloc.dart';
import 'package:ba_merchandise/widgets/button/rounded_button.dart';
import 'package:ba_merchandise/widgets/textfield/rounded_textfield.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/place_type.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:geocoding/geocoding.dart'; // Import Geocoding package

import 'package:location/location.dart' as locat;

class LocationPickerScreen extends StatefulWidget {
  @override
  _LocationPickerScreenState createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  final CompanyOperationBloc operationBloc = Get.find();

  final locat.Location _location = locat.Location();
  final Map<String, Marker> _markers = {};
  double _latitude = 0.00;
  double _longitude = 0.00;
  final double _zoom = 15;

  GoogleMapController? _mapController;
  BitmapDescriptor _markerIcon = BitmapDescriptor.defaultMarker;

  String _placeName = '';
  String _placeId = '';
  final TextEditingController _searchController = TextEditingController();
  //List<Placemark> _placemarks = [];
  void _onCameraMove(CameraPosition position) {
    _markers.clear();
    _latitude = position.target.latitude;
    _longitude = position.target.longitude;
    setState(() {
      _markers['myLocation'] = Marker(
        markerId: MarkerId(position.toString()),
        position: LatLng(position.target.latitude, position.target.longitude),
        icon: _markerIcon,
      );
    });
  }

  void _onCameraStop() {
    _getPlaceName(_latitude, _longitude);
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

  Future<String> _getPlaceName(double lat, double lng) async {
    try {
      // Get the list of placemarks
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        print(place.street);
        setState(() {
          _placeName =
              "${place.name}, ${place.street}, ${place.locality}, ${place.country}";
          _searchController.text =
              "${place.name}, ${place.street}, ${place.locality}, ${place.country}";
        });
        return "${place.street}, ${place.locality}, ${place.country}"; // Format the address or use other fields as needed
      }
    } catch (e) {
      print(e); // Handle the error
    }
    return "Unknown Location"; // Default if no location is found
  }

  @override
  void initState() {
    getCurrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: Text('Select Location'),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              Navigator.pop(context, {
                'latLng': LatLng(_latitude, _longitude),
                'placeName': _placeName,
              });
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(_latitude, _longitude),
              zoom: _zoom,
            ),
            onMapCreated: (controller) {
              _mapController = controller;
            },
            onCameraIdle: _onCameraStop,
            onCameraMove: _onCameraMove,
            markers: _markers.values.toSet(),
            onTap: (LatLng latlng) {
              _latitude = latlng.latitude;
              _longitude = latlng.longitude;
              final marker = Marker(
                icon: _markerIcon,
                markerId: const MarkerId('myLocation'),
                position: LatLng(_latitude, _longitude),
                infoWindow: const InfoWindow(
                  title: 'AppLocalizations.of(context).will_deliver_here',
                ),
              );
              setState(() => _markers['myLocation'] = marker);
            },
          ),
          Positioned(
              top: 50,
              left: 10,
              right: 10,
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(color: AppColors.whiteColor),
                    child: GooglePlaceAutoCompleteTextField(
                      textEditingController: _searchController,
                      googleAPIKey: "AIzaSyBz1Z8bj49e6GWxSxdyzX1BdeRGNXPkU_4",
                      inputDecoration:
                          InputDecoration(hintText: 'Search Location'),
                      debounceTime: 800,
                      countries: ["pk"], // optional by default null is set
                      isLatLngRequired: true,
                      getPlaceDetailWithLatLng: (Prediction prediction) {
                        _latitude = double.parse(prediction.lat.toString());
                        _longitude = double.parse(prediction.lng.toString());
                        _placeName = prediction.description.toString();
                        _placeId = prediction.placeId.toString();

                        _mapController?.animateCamera(
                          CameraUpdate.newCameraPosition(
                            CameraPosition(
                                target: LatLng(_latitude, _longitude),
                                zoom: _zoom),
                          ),
                        );
                        final marker = Marker(
                          icon: _markerIcon,
                          markerId: const MarkerId('myLocation'),
                          position: LatLng(_latitude, _longitude),
                          infoWindow: const InfoWindow(
                            title:
                                'AppLocalizations.of(context).will_deliver_here',
                          ),
                        );
                        setState(() => _markers['myLocation'] = marker);
                        print("placeDetails" + prediction.lng.toString());
                      },
                      itemClick: (Prediction prediction) {
                        _searchController.text = prediction.description!;
                        _searchController.selection =
                            TextSelection.fromPosition(TextPosition(
                                offset: prediction.description!.length));
                      },
                      itemBuilder: (context, index, Prediction prediction) {
                        return Container(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            children: [
                              Icon(Icons.location_on),
                              SizedBox(
                                width: 7,
                              ),
                              Expanded(
                                  child:
                                      Text("${prediction.description ?? ""}"))
                            ],
                          ),
                        );
                      },
                      seperatedBuilder: Divider(),
                      isCrossBtnShown: true,
                      containerHorizontalPadding: 10,
                      placeType: PlaceType.geocode,
                    ),
                  )
                ],
              ))
        ],
      ),
    );
  }

  void _addLocation(latitude, longitude, placeName, placeId) {
    TextEditingController nameController = TextEditingController();
    TextEditingController addressController =
        TextEditingController(text: placeName);

    String? _selectedBrand;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (context) {
        return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                child: Wrap(
                  children: [
                    Text(
                      'Add New Location',
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 0),
                      child: RoundedBorderTextField(
                        isenable: true,
                        controller: nameController,
                        hintText: 'Set Unique Name',
                        icon: '',
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: headingSmall(title: 'Address'),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(),
                      child: RoundedBorderTextField(
                        isenable: true,
                        controller: addressController,
                        hintText: placeName.toString(),
                        icon: '',
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: headingSmall(title: 'Latitude'),
                    ),
                    RoundedBorderTextField(
                      isenable: false,
                      controller: TextEditingController(),
                      hintText: latitude.toString(),
                      icon: '',
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: headingSmall(title: 'Longitude'),
                    ),
                    RoundedBorderTextField(
                      isenable: false,
                      controller: TextEditingController(),
                      hintText: longitude.toString(),
                      icon: '',
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: headingSmall(title: 'Place Id'),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: RoundedBorderTextField(
                        isenable: false,
                        controller: TextEditingController(),
                        hintText: 'place id ' + placeId.toString(),
                        icon: '',
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: RoundedButton(
                                  text: 'Add Location',
                                  onPressed: () {
                                    if (nameController.text.isNotEmpty &&
                                        addressController.text.isNotEmpty) {
                                      operationBloc.addNewLocation(
                                          placeId,
                                          placeName,
                                          latitude,
                                          longitude,
                                          nameController.text);
                                    } else {
                                      Fluttertoast.showToast(
                                          msg: 'Please fill in all fields',
                                          backgroundColor: Colors.red);
                                    }
                                  },
                                  backgroundColor: AppColors.primaryColorDark,
                                  textColor: AppColors.whiteColor),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ));
      },
    );
  }
}
