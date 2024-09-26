import 'package:ba_merchandise/constant/endpoints.dart';
import 'package:ba_merchandise/modules/admin/operation/model/createUser_model.dart';
import 'package:ba_merchandise/modules/auth/model/auth_model.dart';
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
}
