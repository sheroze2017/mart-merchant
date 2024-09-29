import 'package:ba_merchandise/common/utils/function.dart';
import 'package:ba_merchandise/constant/endpoints.dart';
import 'package:ba_merchandise/modules/auth/model/auth_model.dart';
import 'package:ba_merchandise/services/base_service.dart';

class BaOperationService extends BaseService {
  Future<Map<String, dynamic>> insertSalesRecord(
      List<Map<String, String>> products) async {
    var userId = await Utils.getUserId();
    var martId = await Utils.getMartId();

    try {
      Map<String, dynamic> data = {
        "products": products,
        "user_id": userId,
        "mart_id": martId
      };

      final response = await dioClient.post(Endpoints.recordSales, data: data);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> insertInterceptRecord(
      String interceptCount) async {
    var userId = await Utils.getUserId();
    var martId = await Utils.getMartId();
    var companyId = await Utils.getCompanyId();

    try {
      Map<String, dynamic> data = {
        "user_id": userId,
        "mart_id": martId,
        "company_id": companyId,
        "intercepts": interceptCount,
      };

      final response = await dioClient.post(Endpoints.BaIntercept, data: data);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
