import 'package:ba_merchandise/common/utils/function.dart';
import 'package:ba_merchandise/constant/endpoints.dart';
import 'package:ba_merchandise/services/base_service.dart';

class AttendanceService extends BaseService {
  Future<Map<String, dynamic>> attendance(
      {required String lat, required String lng}) async {
    var userId = await Utils.getUserId();
    var martId = await Utils.getMartId();

    try {
      Map<String, dynamic> data = {
        "lat": "24.831404548254817",
        "lng": "67.08077914632807",
        "user_id": userId.toString(),
        "mart_id": martId.toString()
      };

      final response = await dioClient.post(Endpoints.attendance, data: data);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
