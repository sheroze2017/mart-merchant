import 'package:ba_merchandise/constant/endpoints.dart';
import 'package:ba_merchandise/modules/auth/model/auth_model.dart';
import 'package:ba_merchandise/services/base_service.dart';

class AuthService extends BaseService {
  Future<AuthResponse> login(
      {required String email, required String password}) async {
    try {
      Map<String, dynamic> data = {
        "email": email,
        "password": password,
      };

      final response = await dioClient.post(Endpoints.login, data: data);
      return AuthResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateToken(
      {required String userId, required String token}) async {
    try {
      Map<String, dynamic> data = {
        "user_id": "1",
        "device_token": "test device token"
      };
      final response = await dioClient.post(Endpoints.updateToken, data: data);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
