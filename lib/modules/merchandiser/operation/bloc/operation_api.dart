import 'package:ba_merchandise/constant/endpoints.dart';
import 'package:ba_merchandise/services/base_service.dart';

class MerchantOperationService extends BaseService {
  Future<String> uploadPhoto(String baseImage64) async {
    print(baseImage64);
    try {
      final result = await dioClient.post(
          'http://194.233.69.219:3006/auth/uploadBase64',
          data: {"base64Image": baseImage64});
      print(result);
      if (result['sucess'] == true) {
        return result['data'];
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
      'user_id': userId,
      'desc': desc,
      'company_id': companyId,
      'mart_id': martId,
      'image': imgUrl,
      'lat': lat,
      'lng': lng
    };
    try {
      final response =
          await dioClient.post(Endpoints.restockRecord, data: data);
      return response;
    } catch (e) {
      throw e;
    } finally {}
  }
}
