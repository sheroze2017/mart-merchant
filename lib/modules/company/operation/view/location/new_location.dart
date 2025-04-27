import 'dart:convert';

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
import 'package:http/http.dart' as http;
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

  String apiKey =
      "AIzaSyBz1Z8bj49e6GWxSxdyzX1BdeRGNXPkU_4"; // Replace with your API key

  List<dynamic> _suggestions = [];

  Future<void> _searchPlaces(String input) async {
    final url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$apiKey&components=country:pk';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _suggestions = data['predictions'];
      });
    } else {
      print("Failed to fetch suggestions");
    }
  }

  Future<void> _selectSuggestion(String placeId) async {
    final url =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$apiKey';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final location = data['result']['geometry']['location'];
      final description = data['result']['formatted_address'];

      _latitude = location['lat'];
      _longitude = location['lng'];
      _placeName = description;

      _searchController.text = description;
      _suggestions.clear();

      final marker = Marker(
        icon: _markerIcon,
        markerId: const MarkerId('myLocation'),
        position: LatLng(_latitude, _longitude),
        infoWindow: const InfoWindow(title: 'Selected Location'),
      );

      setState(() {
        _markers['myLocation'] = marker;
        _mapController?.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: LatLng(_latitude, _longitude), zoom: _zoom),
          ),
        );
      });
    } else {
      print("Failed to get place details");
    }
  }

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
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search Location',
                      hintStyle: TextStyle(color: Colors.grey[600]),
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: Icon(Icons.search, color: Colors.grey[800]),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: Icon(Icons.clear, color: Colors.grey[800]),
                              onPressed: () {
                                setState(() {
                                  _searchController.clear();
                                  _suggestions.clear();
                                });
                              },
                            )
                          : null,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (value) {
                      if (value.length > 2) {
                        _searchPlaces(value);
                      } else {
                        setState(() => _suggestions.clear());
                      }
                    },
                  ),
                ),
                if (_suggestions.isNotEmpty)
                  Container(
                    color: Colors.white,
                    height: 200,
                    child: ListView.builder(
                      itemCount: _suggestions.length,
                      itemBuilder: (context, index) {
                        final suggestion = _suggestions[index];
                        return ListTile(
                          leading: Icon(Icons.location_on),
                          title: Text(suggestion['description']),
                          onTap: () =>
                              _selectSuggestion(suggestion['place_id']),
                        );
                      },
                    ),
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
