import 'package:ba_merchandise/common/utils/function.dart';
import 'package:ba_merchandise/modules/admin/operation/bloc/operation_api.dart';
import 'package:ba_merchandise/modules/admin/operation/model/sales_model.dart';
import 'package:get/get.dart';

class BaInteceptCompanyCompany extends GetxController {
  var interceptLoader = false.obs; // Observable to track loading state
  RxList<dynamic> baInterceptRecord = RxList();

  final AdminOperationService _adminOperationService = AdminOperationService();

  Future<void> getInterceptForMartCompany(String martId) async {
    interceptLoader.value = true;
    try {
      var companyId = await Utils.getUserId();
      final response = await _adminOperationService.getBaIntecept(
          companyId.toString(), martId);
      if (response['data'] != null && response['code'] == 200) {
        interceptLoader.value = false;
        baInterceptRecord.value = response['data'] ?? [];
        baInterceptRecord.value = baInterceptRecord.reversed.toList();
        update();
      } else {
        interceptLoader.value = false;
        update();
      }
    } catch (e) {
      interceptLoader.value = false;
      update();
    }
  }

  @override
  void onInit() {
    super.onInit();
    getInterceptForMartCompany('');
  }
}
