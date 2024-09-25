import 'package:ba_merchandise/modules/auth/model/auth_model.dart';
import 'package:ba_merchandise/services/local_storage/auth_storage.dart';
import 'package:get/get.dart';

class Utils {
  static Future<int?> getUserId() async {
    final AuthStorage authStorage = Get.find<AuthStorage>();
    AuthResponse? authResponse = await authStorage.get();
    return authResponse!.data?.userId;
  }

  static Future<int?> getMartId() async {
    final AuthStorage authStorage = Get.find<AuthStorage>();
    AuthResponse? authResponse = await authStorage.get();
    return authResponse!.data?.martId;
  }

  static Future<String?> getUserRole() async {
    final AuthStorage authStorage = Get.find<AuthStorage>();
    AuthResponse? authResponse = await authStorage.get();
    return authResponse!.data?.role;
  }
}
