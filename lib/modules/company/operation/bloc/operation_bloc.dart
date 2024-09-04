import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class OperationBloc extends GetxController {
  RxList<Map<String, dynamic>> locations = [
    {
      'locationId': 1,
      'name': 'Central Park',
      'lat': 40.785091,
      'lng': -73.968285
    },
    {
      'locationId': 2,
      'name': 'Eiffel Tower',
      'lat': 48.858844,
      'lng': 2.294351
    },
    {
      'locationId': 3,
      'name': 'Sydney Opera House',
      'lat': -33.856784,
      'lng': 151.213108
    },
    {
      'locationId': 4,
      'name': 'Great Wall of China',
      'lat': 40.431908,
      'lng': 116.570374
    },
    {
      'locationId': 5,
      'name': 'Machu Picchu',
      'lat': -13.163141,
      'lng': -72.544963
    },
    {'locationId': 6, 'name': 'Taj Mahal', 'lat': 27.175015, 'lng': 78.042155},
    {
      'locationId': 7,
      'name': 'Statue of Liberty',
      'lat': 40.689247,
      'lng': -74.044502
    },
    {'locationId': 8, 'name': 'Colosseum', 'lat': 41.890251, 'lng': 12.492373},
  ].obs;

  Future<void> deleteLocation(int LocationId) async {
    locations.removeWhere((location) => location['locationId'] == LocationId);
    Get.back();
    Fluttertoast.showToast(msg: 'Location deleted');
  }
}
