import 'package:ba_merchandise/common/utils/function.dart';
import 'package:ba_merchandise/constant/endpoints.dart';
import 'package:ba_merchandise/modules/auth/model/auth_model.dart';
import 'package:ba_merchandise/modules/company/operation/model/company_model.dart';
import 'package:ba_merchandise/modules/company/operation/model/mart_model.dart';
import 'package:ba_merchandise/services/base_service.dart';

class CompanyOperationService extends BaseService {
  Future<Map<String, dynamic>> createNewProduct({
    required String categoryId,
    required String name,
    required String desc,
    required String price,
    required String qty,
    required String varient,
    required String martId,
  }) async {
    var userId = await Utils.getUserId();

    try {
      Map<String, dynamic> data = {
        "company_id": userId,
        "category_id": '1',
        "mart_id": '1',
        "product_name": name,
        "product_description": desc,
        "price": price,
        "qty": qty,
        "varient": varient
      };

      final response =
          await dioClient.post(Endpoints.createProduct, data: data);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> createNewCategory({
    required String name,
  }) async {
    var userId = await Utils.getUserId();

    try {
      Map<String, dynamic> data = {"company_id": userId, "name": name};

      final response =
          await dioClient.post(Endpoints.createCategory, data: data);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<AllCategoryModel> getAllCategories() async {
    var userId = await Utils.getUserId();

    try {
      final response = await dioClient
          .get('${Endpoints.getAllCategories}?company_id=${userId}');
      return AllCategoryModel.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<AllMart> getAllMart() async {
    try {
      final response = await dioClient.get(Endpoints.getAllMart);
      return AllMart.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }
}
