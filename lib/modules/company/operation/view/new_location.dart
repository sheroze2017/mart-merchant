import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationPickerScreen extends StatefulWidget {
  @override
  _LocationPickerScreenState createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  GoogleMapController? _mapController;
  LatLng _selectedLocation = LatLng(24.929681, 67.039365);
  String _placeName = 'San Francisco';
  final TextEditingController _searchController = TextEditingController();
  //List<Placemark> _placemarks = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Location'),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              Navigator.pop(context, {
                'latLng': _selectedLocation,
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
              target: _selectedLocation,
              zoom: 14,
            ),
            onMapCreated: (controller) {
              _mapController = controller;
            },
            onCameraMove: (position) {
              _selectedLocation = position.target;
              _getAddressFromLatLng();
            },
            onCameraIdle: _getAddressFromLatLng,
            markers: {
              Marker(
                markerId: MarkerId('selected-location'),
                position: _selectedLocation,
              ),
            },
          ),
          Positioned(
            top: 50,
            left: 10,
            right: 10,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search places',
                  border: InputBorder.none,
                  suffixIcon: Icon(Icons.search),
                ),
                onChanged: (query) {
                  _searchPlace(query);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _searchPlace(String query) async {
    try {
      // List<Location> locations = await locationFromAddress(query);
      // if (locations.isNotEmpty) {
      //   final latLng = LatLng(locations[0].latitude, locations[0].longitude);
      //   _mapController?.animateCamera(CameraUpdate.newLatLng(latLng));
      //   _selectedLocation = latLng;
      //   _getAddressFromLatLng();
      // }
    } catch (e) {
      print(e);
    }
  }

  void _getAddressFromLatLng() async {
    try {
      // List<Placemark> placemarks = await placemarkFromCoordinates(
      //   _selectedLocation.latitude,
      //   _selectedLocation.longitude,
      // );
      // if (placemarks.isNotEmpty) {
      //   setState(() {
      //     _placeName = placemarks[0].name ?? 'Unknown place';
      //     _placemarks = placemarks;
      //   });
      // }
    } catch (e) {
      print(e);
    }
  }
}
