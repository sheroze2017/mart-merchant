import 'package:ba_merchandise/common/utils/function.dart';
import 'package:ba_merchandise/constant/endpoints.dart';
import 'package:ba_merchandise/services/base_service.dart';

class SupervisorOperationService extends BaseService {
  Future<Map<String, dynamic>> createNewReport({
    required String martId,
    required String desc,
    required String image,
  }) async {
    var userId = await Utils.getUserId();
    var companyId = await Utils.getCompanyId();

    try {
      Map<String, dynamic> data = {
        "user_id": userId.toString(),
        "image": image,
        "description": desc,
        "company_id": companyId.toString(),
        "mart_id": martId
      };
      final response =
          await dioClient.post(Endpoints.submitSupervisorData, data: data);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
