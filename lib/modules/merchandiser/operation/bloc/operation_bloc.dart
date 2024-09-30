import 'dart:convert';

import 'package:ba_merchandise/main.dart';
import 'package:ba_merchandise/modules/b.a/record_data/model/record_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/local/hive_db/hive.dart';
import 'package:intl/intl.dart'; // To format date and time

class MerchantOperationBloc extends GetxController {
  RxList records = <RecordModelData>[].obs;
  RxList restockRecord = <RecordModelData>[].obs;

  String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
  RxList<RecordModel> recordData = <RecordModel>[].obs;
  @override
  void onInit() {
    super.onInit();
    init().then((value) => _loadRecordModels());
  }

  Future<void> init() async {
    // salesRecord = await Hive.openBox<SalesRecordModel>('salesRecords');
  }

  Future<void> _loadRecordModels() async {
    final prefs = await SharedPreferences.getInstance();
    final dataLoaded = prefs.getBool('DataLoaded') ?? false;
    final jsonString = prefs.getString('RecordModels');
    final restockData = prefs.getString('RestockStock');
    if (dataLoaded == true) {
      if (restockData != null) {
        final List<dynamic> jsonList = json.decode(restockData);
        restockRecord.value =
            jsonList.map((json) => RecordModelData.fromMap(json)).toList();
      }
      if (jsonString != null) {
        final List<dynamic> jsonList = json.decode(jsonString);
        records.value =
            jsonList.map((json) => RecordModelData.fromMap(json)).toList();
      }
    } else {
      // Load default data if no data is found
      prefs.setBool('DataLoaded', true);
      _setDefaultData();
    }
    SalesRecordModel? todaySales = getSalesByDate(DateTime.now());
    for (int i = 0; i < todaySales!.productsSold.length; i++) {
      print(todaySales.date);
      print(todaySales.productsSold.length);
      print(todaySales.productsSold[i].name);
      print(todaySales.productsSold[i].stock);
      print(todaySales.productsSold[i].stockSold);
    }
  }

  Future<void> _setDefaultData() async {
    final List<RecordModelData> defaultData = [
      RecordModelData(
          id: 1,
          name: "FreshMint Extreme",
          quantityGm: 100,
          pricePkr: 999,
          stock: 50),
      RecordModelData(
          id: 2,
          name: "Cavity Shield",
          quantityGm: 150,
          pricePkr: 1199,
          stock: 30),
      RecordModelData(
          id: 3,
          name: "Whitening Plus",
          quantityGm: 120,
          pricePkr: 1399,
          stock: 20),
      RecordModelData(
          id: 4,
          name: "Sensitive Care",
          quantityGm: 75,
          pricePkr: 849,
          stock: 40),
      RecordModelData(
          id: 5,
          name: "Herbal Clean",
          quantityGm: 90,
          pricePkr: 1099,
          stock: 25),
      RecordModelData(
          id: 6,
          name: "Cool Breeze",
          quantityGm: 125,
          pricePkr: 1249,
          stock: 15),
      RecordModelData(
          id: 7,
          name: "Total Protection",
          quantityGm: 100,
          pricePkr: 999,
          stock: 60),
      RecordModelData(
          id: 8,
          name: "Enamel Guard",
          quantityGm: 85,
          pricePkr: 899,
          stock: 35),
      RecordModelData(
          id: 9,
          name: "Charcoal Fresh",
          quantityGm: 110,
          pricePkr: 1199,
          stock: 10),
      RecordModelData(
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

  Future<void> RestockRecord(RecordModelData da) async {
    final prefs = await SharedPreferences.getInstance();
    records.removeWhere((element) => element.id == da.id);
    restockRecord.add(da);

    final jsonString =
        json.encode(restockRecord.map((tp) => tp.toMap()).toList());
    prefs.setString('RestockStock', jsonString);
    final jsonString2 = json.encode(records.map((tp) => tp.toMap()).toList());
    prefs.setString('RecordModels', jsonString2);
  }

  Future<void> RemoveRestockRecord(RecordModelData da) async {
    final prefs = await SharedPreferences.getInstance();
    restockRecord.removeWhere((element) => element.id == da.id);
    records.add(da);
    print(restockRecord.length);
    print(records.length);
    final jsonString =
        json.encode(restockRecord.map((tp) => tp.toMap()).toList());
    prefs.setString('RestockStock', jsonString);
    final jsonString2 = json.encode(records.map((tp) => tp.toMap()).toList());
    prefs.setString('RecordModels', jsonString2);
  }

  void updateRecordModel(int index, RecordModelData updatedRecordModel) {
    records[index] = updatedRecordModel;
    _saveRecordModels();
  }

  Future<void> updateSalesRecord(List<TextEditingController> controller) async {
    List<RecordModel> recordList = [];
    for (int i = 0; i < records.length; i++) {
      if (int.tryParse(controller[i].text) == null) {
      } else {
        records[i].stock = records[i].stock - int.parse(controller[i].text);
        recordList.add(RecordModel(
            id: records[i].id,
            name: records[i].name,
            quantityGm: records[i].quantityGm,
            pricePkr: records[i].pricePkr,
            stock: records[i].stock,
            stockSold: int.parse(controller[i].text)));
        salesRecord.put(today,
            SalesRecordModel(date: DateTime.now(), productsSold: recordList));
      }
    }

    _saveRecordModels();
    addOrUpdateSales(DateTime.now(), recordList);
    Fluttertoast.showToast(msg: 'Record saved');
  }

  Future<void> updateProductPriceOfflineStore(
      List<TextEditingController> controller) async {
    for (int i = 0; i < records.length; i++) {
      if (controller[i].text != '0')
        records[i].pricePkr = double.parse(controller[i].text);
      update();
    }
    _saveRecordModels();
    Fluttertoast.showToast(msg: 'Price updated succesfully');
  }

  Future<void> addOrUpdateSales(DateTime date, List<RecordModel> sales) async {
    final salesDateKey = _formatDateKey(date);
    SalesRecordModel? existingRecord = salesRecord.get(today);

    if (existingRecord != null) {
      // Update existing sales
      for (var sale in sales) {
        var existingProduct = existingRecord.productsSold.firstWhere(
          (product) => product.id == sale.id,
          orElse: () => RecordModel(
              id: sale.id,
              name: sale.name,
              quantityGm: 0,
              pricePkr: sale.pricePkr,
              stock: 0,
              stockSold: 0),
        );

        // Update the quantity and stock
        existingProduct.stockSold += sale.stockSold;
      }

      await salesRecord.put(salesDateKey, existingRecord);
    } else {
      // Add new sales record for the date
      await salesRecord.put(
        salesDateKey,
        SalesRecordModel(date: date, productsSold: sales),
      );
    }
  }

  // Fetch sales for a specific day
  SalesRecordModel? getSalesByDate(DateTime date) {
    return salesRecord.get(_formatDateKey(date));
  }

  // Format date as a string key
  String _formatDateKey(DateTime date) {
    return '${date.year}-${date.month}-${date.day}';
  }

  // Close the Hive box when not needed
  void dispose() {
    salesRecord.close();
  }
}
