import 'package:ba_merchandise/modules/b.a/record_data/bloc/ba_operation_api.dart';
import 'package:ba_merchandise/widgets/custom/error_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InsertSalesRecord extends GetxController {
  var statusRecordLoader = false.obs;
  BaOperationService baOperationService = BaOperationService();

  Future<void> insertSalesRecord(BuildContext context) async {
    statusRecordLoader.value = true;
    try {
      final response = await baOperationService.insertSalesRecord([
        {"product_id": "1", "qty": "3"},
        {"product_id": "1", "qty": "5"},
        {"product_id": "1", "qty": "2"},
      ]);

      if (response != null &&
          response['data'] != null &&
          response['code'] == 200) {
        statusRecordLoader.value = false;
        // Success message
        AnimatedSnackbar.showSnackbar(
          context: context,
          message: response['message'] ??
              'Sales record inserted successfully', // Fallback message
          icon: Icons.info,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 14.0,
        );
      } else {
        // Failure message
        AnimatedSnackbar.showSnackbar(
          context: context,
          message: response['message']?.toString() ??
              'Failed to insert sales record', // Fallback error message
          icon: Icons.error,
          backgroundColor: const Color.fromARGB(255, 241, 235, 235),
          textColor: Colors.black,
          fontSize: 14.0,
        );
      }
    } catch (error) {
      statusRecordLoader.value = false;

      AnimatedSnackbar.showSnackbar(
        context: context,
        message: 'An error occurred: ${error.toString()}',
        icon: Icons.error,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 14.0,
      );
    }
  }
}
