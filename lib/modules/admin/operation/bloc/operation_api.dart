import 'package:ba_merchandise/constant/endpoints.dart';
import 'package:ba_merchandise/modules/admin/operation/model/all_attendance_model.dart';
import 'package:intl/intl.dart';

import 'package:ba_merchandise/modules/admin/operation/model/company_mart_product_model.dart';
import 'package:ba_merchandise/modules/admin/operation/model/createUser_model.dart';
import 'package:ba_merchandise/modules/admin/operation/model/sales_model.dart';
import 'package:ba_merchandise/modules/admin/operation/model/user_by_role_model.dart';
import 'package:ba_merchandise/services/base_service.dart';

class AdminOperationService extends BaseService {
  Future<CreateUserModel> createUser(
      {required String lat,
      required String lng,
      required String name,
      required String email,
      required String password,
      required String phoneNo,
      required String companyId,
      required String martId,
      required String image,
      required String role,
      required String deviceToken,
      required String location}) async {
    try {
      Map<String, dynamic> data = {
        "name": name,
        "email": email,
        "password": password,
        "role": role,
        "phone": phoneNo,
        "company_id": companyId,
        "mart_id": martId,
        "lat": lat,
        "lng": lng,
        "device_token": deviceToken,
        "image": image,
        "location": location,
      };

      final response = await dioClient.post(Endpoints.createUser, data: data);
      return CreateUserModel.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<CreateUserModel> createCompany(
      {required String name,
      required String email,
      required String password,
      required String phoneNo,
      required String image,
      required String location}) async {
    try {
      Map<String, dynamic> data = {
        "name": name,
        "email": email,
        "password": password,
        "role": 'COMPANY',
        "phone": phoneNo,
        "company_id": '2',
        "mart_id": '2',
        "location": location,
      };

      final response = await dioClient.post(Endpoints.createUser, data: data);
      return CreateUserModel.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<CreateUserModel> createMerchant({
    required String name,
    required String email,
    required String password,
    required String phoneNo,
  }) async {
    try {
      Map<String, dynamic> data = {
        "name": name,
        "email": email,
        "password": password,
        "role": 'MERCHANT',
        "phone": phoneNo,
        "company_id": '2',
        "mart_id": '2',
      };

      final response = await dioClient.post(Endpoints.createUser, data: data);
      return CreateUserModel.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<CreateUserModel> createBA(
      {required String name,
      required String email,
      required String password,
      required String phoneNo,
      required String companyId,
      required String martId,
      required String image,
      required String location}) async {
    try {
      Map<String, dynamic> data = {
        "name": name,
        "email": email,
        "password": password,
        "role": 'BA',
        "phone": phoneNo,
        "company_id": companyId,
        "mart_id": martId,
        "image": image,
        "location": location,
      };

      final response = await dioClient.post(Endpoints.createUser, data: data);
      return CreateUserModel.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<CreateUserModel> createSupervisor(
      {required String name,
      required String email,
      required String password,
      required String phoneNo,
      required String companyId,
      required String image,
      required String location}) async {
    try {
      Map<String, dynamic> data = {
        "name": name,
        "email": email,
        "password": password,
        "role": 'supervisor',
        "phone": phoneNo,
        "company_id": companyId,
        "mart_id": null,
        "image": image,
        "location": location,
      };

      final response = await dioClient.post(Endpoints.createUser, data: data);
      return CreateUserModel.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> createMart({
    required String martName,
    required String address,
    required String latitude,
    required String longitude,
  }) async {
    try {
      Map<String, dynamic> data = {
        "mart_name": martName,
        "location": address,
        "lat": latitude,
        "lng": longitude
      };

      final response = await dioClient.post(Endpoints.createMart, data: data);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<AllCompanyProductData> getAllProducts(int companyId,
      {String? categoryId, String? martId}) async {
    try {
      Map<String, dynamic> data = {
        "company_id": companyId,
        "mart_id": martId,
        if (categoryId != null) "category_id": categoryId
      };

      final response =
          await dioClient.post(Endpoints.getAllCompanyMartProduct, data: data);
      return AllCompanyProductData.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<AllCompanyProductData> getAllCompetitorProduct(
      String companyId) async {
    try {
      final response = await dioClient
          .get('${Endpoints.getAllCompetitorProduct}?company_id=$companyId');
      return AllCompanyProductData.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<AllUserAttendance> getAllUserAttendance(
      String startDate, String endDate) async {
    try {
      final now = DateTime.now();
      final formatter = DateFormat('yyyy-MM-dd');

      String formattedToday = formatter.format(now);
      String formatted30DaysAgo =
          formatter.format(now.subtract(Duration(days: 30)));

      Map<String, dynamic> data = {
        "start_date": startDate.isEmpty ? formatted30DaysAgo : startDate,
        "end_date": endDate.isEmpty
            ? (startDate.isEmpty ? formattedToday : formatter.format(now))
            : endDate,
      };

      final response =
          await dioClient.post(Endpoints.getAllBaAttendance, data: data);
      return AllUserAttendance.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<AllUserByRole> getAllUserByRole(String userRole,
      {String? categoryId}) async {
    String url = '&category_id=$categoryId';

    try {
      final response = await dioClient.get(
          '${Endpoints.getUserByRole}?role=${userRole}${categoryId != null ? url : ''}');
      return AllUserByRole.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> changeBaStatus(
      String userId, String status) async {
    try {
      Map<String, dynamic> data = {"user_id": userId, "status": status};

      final response = await dioClient.post(Endpoints.grandAccess, data: data);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> assignEmployeeToBa(
      String userId, int companyId, int martId, categoryId) async {
    try {
      Map<String, dynamic> data = {
        "user_id": userId,
        "company_id": companyId,
        "mart_id": martId,
        "category_id": categoryId
      };

      final response =
          await dioClient.post(Endpoints.assignBatoCompany, data: data);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<SalesModel> getSales(
      String companyId, String martId, String? userId) async {
    try {
      Map<String, dynamic> data = {
        "company_id": companyId,
        "mart_id": martId,
        "user_id": userId
      };

      final response = await dioClient.post(Endpoints.getSales, data: data);
      return SalesModel.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getBaIntecept(
      String companyId, String martId) async {
    try {
      Map<String, dynamic> data = {
        "company_id": companyId,
        "mart_id": martId,
      };

      final response =
          await dioClient.post(Endpoints.getIntercepts, data: data);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getActivities(
      String companyId, String martId) async {
    try {
      Map<String, dynamic> data = {"company_id": companyId, "mart_id": martId};

      final response = await dioClient.post(Endpoints.getActivity, data: data);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getSupervisorRecord(
      String companyId, String martId) async {
    try {
      String url = Endpoints.getSupervisorData;

      List<String> queryParams = [];
      if (companyId.isNotEmpty) queryParams.add('company_id=$companyId');
      if (martId.isNotEmpty) queryParams.add('mart_id=$martId');
      if (queryParams.isNotEmpty) {
        url += '?${queryParams.join('&')}';
      }
      final response = await dioClient.get(url);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
