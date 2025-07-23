import 'dart:convert';
import 'dart:io';

import 'package:ba_merchandise/common/utils/function.dart';
import 'package:ba_merchandise/constant/endpoints.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:ba_merchandise/services/base_service.dart';

class MerchantOperationService extends BaseService {
  Future<String> uploadPhoto(String filePath) async {
    final url = Uri.parse(
        'https://canvas-prod.comsrvssoftwaresolutions.com/auth/uploadImage');

    try {
      final File originalFile = File(filePath);
      final request = http.MultipartRequest('POST', url)
        ..files
            .add(await http.MultipartFile.fromPath('image', originalFile.path));
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print('STATUS: ${response.statusCode}');
      print('BODY: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['sucess'] == true) {
          return data['data']; // Adjust based on API response structure
        }
      }
      return '';
    } catch (e) {
      print("Upload error: $e");
      return '';
    }
  }

  Future<String> updateProfilePhoto(String filePath) async {
    var userId = await Utils.getUserId();
    var url = Uri.parse(
        'https://canvas-prod.comsrvssoftwaresolutions.com/auth/uploadImage');

    var request = http.MultipartRequest('POST', url);
    request.files.add(await http.MultipartFile.fromPath('image', filePath));
    request.fields['user_id'] = userId.toString();

    try {
      // Send request
      var streamedResponse = await request.send();

      // Read response
      var response = await http.Response.fromStream(streamedResponse);
      print("STATUS: ${response.statusCode}");
      print("BODY: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['sucess'] == true) {
          return data['data']['image'];
        } else {
          print("Success = false: ${data}");
        }
      } else {
        print("Unexpected status code: ${response.statusCode}");
      }

      return '';
    } catch (e) {
      print('Upload failed with error: $e');
      return '';
    }
  }

  Future<Map<String, dynamic>> uploadRestockRecord(
      String desc,
      String imgUrl,
      String martId,
      String companyId,
      String userId,
      double lat,
      double lng) async {
    Map<String, dynamic> data = {
      "user_id": userId,
      "company_id": companyId,
      "mart_id": martId,
      "image": imgUrl,
      "remarks": desc,
      "lat": lat.toString(),
      "lng": lng.toString()
    };
    try {
      final response =
          await dioClient.post(Endpoints.restockRecord, data: data);
      return response;
    } catch (e) {
      throw e;
    } finally {}
  }

  Future<Map<String, dynamic>> updateProductQuantity(
      String qty, String productId) async {
    try {
      Map<String, dynamic> data = {"product_id": productId, "qty": qty};

      final response = await dioClient
          .post(Endpoints.updateProductQuantityMerchant, data: data);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
