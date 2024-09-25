import 'package:ba_merchandise/common/utils/function.dart';
import 'package:ba_merchandise/constant/endpoints.dart';
import 'package:ba_merchandise/modules/auth/model/auth_model.dart';
import 'package:ba_merchandise/services/base_service.dart';

class AttendanceService extends BaseService {
  Future<AuthResponse> attendance(
      {required String lat, required String lng}) async {
    var userId = await Utils.getUserId();
    var martId = await Utils.getMartId();

    try {
      Map<String, dynamic> data = {
        "lat": lat,
        "lng": lng,
        "user_id": userId.toString(),
        "mart_id": martId.toString()
      };

      final response = await dioClient.post(Endpoints.attendance, data: data);
      return AuthResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }


}
