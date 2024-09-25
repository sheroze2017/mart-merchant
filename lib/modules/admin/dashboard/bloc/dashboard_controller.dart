import 'package:ba_merchandise/modules/auth/model/auth_model.dart';
import 'package:ba_merchandise/services/local_storage/auth_storage.dart';
import 'package:get/get.dart';

class DashBoardController extends GetxController {
  var userData = Rxn<UserData>(UserData());

  @override
  void onInit() {
    super.onInit();
    getUserData();
  }

  Future<void> getUserData() async {
    final AuthStorage authStorage = Get.find<AuthStorage>();
    AuthResponse? authResponse = await authStorage.get();
    userData.value = authResponse!.data;
  }
}
