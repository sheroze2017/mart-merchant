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
}
