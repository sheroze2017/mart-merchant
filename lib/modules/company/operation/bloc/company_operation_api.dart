import 'package:ba_merchandise/common/utils/function.dart';
import 'package:ba_merchandise/constant/endpoints.dart';
import 'package:ba_merchandise/modules/company/operation/model/company_model.dart';
import 'package:ba_merchandise/modules/company/operation/model/mart_model.dart';
import 'package:ba_merchandise/modules/company/operation/model/merchant_restock_model.dart';
import 'package:ba_merchandise/services/base_service.dart';

class CompanyOperationService extends BaseService {
  Future<Map<String, dynamic>> createNewProduct({
    required String categoryId,
    required String name,
    required String desc,
    required String price,
    required String qty,
    required String varient,
    required String size,
  }) async {
    var userId = await Utils.getUserId();

    try {
      Map<String, dynamic> data = {
        "company_id": userId.toString(),
        "category_id": categoryId.toString(),
        "product_name": name,
        "product_description": desc,
        "price": price,
        "qty": qty,
        "varient": varient,
        "size": size
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

  Future<MerchantRestockDetailModel> getAllMerchantRestockRequest(
      String MartId) async {
    var userId = await Utils.getUserId();

    Map<String, dynamic> data = {
      "company_id": userId.toString(),
      "mart_id": MartId
    };
    try {
      final response = await dioClient
          .post(Endpoints.getAllMerchantRestockDetail, data: data);
      return MerchantRestockDetailModel.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<MerchantRestockDetailModel> getAllMerchantRestockRequestAdmin(
      String CompanyId, String MartId) async {
    Map<String, dynamic> data = {"company_id": CompanyId, "mart_id": MartId};
    try {
      final response = await dioClient
          .post(Endpoints.getAllMerchantRestockDetail, data: data);
      return MerchantRestockDetailModel.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }
}
