import 'package:ba_merchandise/common/utils/function.dart';
import 'package:ba_merchandise/constant/endpoints.dart';
import 'package:ba_merchandise/services/base_service.dart';

class MerchantOperationService extends BaseService {
  Future<String> uploadPhoto(String baseImage64) async {
    print(baseImage64);
    try {
      final result = await dioClient.post(
          '${Endpoints.baseUrl}auth/uploadBase64',
          data: {"base64Image": baseImage64});

      if (result['sucess'] == true) {
        return result['data'];
      } else {
        return '';
      }
    } catch (e) {
      return '';
    } finally {}
  }

  Future<String> updateProfilePhoto(String baseImage64) async {
    var userId = await Utils.getUserId();
    try {
      final result = await dioClient.post(
          '${Endpoints.baseUrl}auth/uploadBase64',
          data: {"base64Image": baseImage64, "user_id": userId});
      if (result['sucess'] == true) {
        return result['data']['image'];
      } else {
        return '';
      }
    } catch (e) {
      return '';
    } finally {}
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
