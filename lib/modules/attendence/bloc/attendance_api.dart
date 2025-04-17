import 'package:ba_merchandise/common/utils/function.dart';
import 'package:ba_merchandise/constant/endpoints.dart';
import 'package:intl/intl.dart'; // To format date and time

import 'package:ba_merchandise/services/base_service.dart';

class AttendanceService extends BaseService {
  Future<Map<String, dynamic>> attendance(
      {required String lat, required String lng, required String time}) async {
    var userId = await Utils.getUserId();
    var martId = await Utils.getMartId();

    try {
      Map<String, dynamic> data = {
        "lat": lat,
        "lng": lng,
        "user_id": userId.toString(),
        "mart_id": martId.toString(),
        "time": time
      };

      final response = await dioClient.post(Endpoints.attendance, data: data);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> checkAttendance() async {
    var userId = await Utils.getUserId();
    String todayDateTime =
        DateFormat('yyyy MMM dd HH:mm:ss').format(DateTime.now());
    try {
      final response = await dioClient.get(
          '${Endpoints.checkAttendance}?user_id=$userId&time=${todayDateTime}');
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
