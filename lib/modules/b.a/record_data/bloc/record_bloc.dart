import 'dart:convert';

import 'package:ba_merchandise/modules/b.a/record_data/model/record_model.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecordController extends GetxController {
  var records = <RecordModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadRecordModels();
  }

  Future<void> _loadRecordModels() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('RecordModels');
    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      records.value =
          jsonList.map((json) => RecordModel.fromMap(json)).toList();
    } else {
      // Load default data if no data is found
      _setDefaultData();
    }
  }

  Future<void> _setDefaultData() async {
    final List<RecordModel> defaultData = [
      RecordModel(
          id: 1,
          name: "FreshMint Extreme",
          quantityGm: 100,
          pricePkr: 999,
          stock: 50),
      RecordModel(
          id: 2,
          name: "Cavity Shield",
          quantityGm: 150,
          pricePkr: 1199,
          stock: 30),
      RecordModel(
          id: 3,
          name: "Whitening Plus",
          quantityGm: 120,
          pricePkr: 1399,
          stock: 20),
      RecordModel(
          id: 4,
          name: "Sensitive Care",
          quantityGm: 75,
          pricePkr: 849,
          stock: 40),
      RecordModel(
          id: 5,
          name: "Herbal Clean",
          quantityGm: 90,
          pricePkr: 1099,
          stock: 25),
      RecordModel(
          id: 6,
          name: "Cool Breeze",
          quantityGm: 125,
          pricePkr: 1249,
          stock: 15),
      RecordModel(
          id: 7,
          name: "Total Protection",
          quantityGm: 100,
          pricePkr: 999,
          stock: 60),
      RecordModel(
          id: 8,
          name: "Enamel Guard",
          quantityGm: 85,
          pricePkr: 899,
          stock: 35),
      RecordModel(
          id: 9,
          name: "Charcoal Fresh",
          quantityGm: 110,
          pricePkr: 1199,
          stock: 10),
      RecordModel(
          id: 10,
          name: "Tropical Fruit",
          quantityGm: 130,
          pricePkr: 1349,
          stock: 5),
    ];

    records.addAll(defaultData);
    _saveRecordModels();
  }

  Future<void> _saveRecordModels() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(records.map((tp) => tp.toMap()).toList());
    prefs.setString('RecordModels', jsonString);
  }

  void updateRecordModel(int index, RecordModel updatedRecordModel) {
    records[index] = updatedRecordModel;
    _saveRecordModels();
  }
}
