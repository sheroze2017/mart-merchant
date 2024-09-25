import 'dart:convert';

import 'package:ba_merchandise/modules/auth/model/auth_model.dart';
import 'package:ba_merchandise/services/local_storage/local_storage.dart';

class AuthStorage extends LocalStorage<AuthResponse> {
  @override
  Future<AuthResponse?> get() async {
    String? data = await storage.getString(key);
    if (data != null) {
      return AuthResponse.fromJson(jsonDecode(data));
    }
    return null;
  }

  @override
  Future<void> set(AuthResponse obj) {
    return storage.setString(key, jsonEncode(obj.toJson()));
  }
}
