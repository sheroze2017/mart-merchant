import 'package:ba_merchandise/modules/admin/operation/bloc/operation_api.dart';
import 'package:ba_merchandise/modules/admin/operation/model/sales_model.dart';
import 'package:get/get.dart';

class adminCompetitorActivity extends GetxController {
  var salesLoader = false.obs; // Observable to track loading state
  RxList<dynamic> activityList = RxList();

  final AdminOperationService _adminOperationService = AdminOperationService();

  Future<void> getActivites(String companyId, String martId) async {
    salesLoader.value = true;
    try {
      final response = await _adminOperationService.getActivities(
          companyId.toString(), martId);
      if (response['data'] != null) {
        salesLoader.value = false;
        activityList.value = (response['data'] ?? []).reversed.toList();
        update(); // Notify listeners to rebuild UI
      } else {
        salesLoader.value = false;
        update();
      }
    } catch (e) {
      salesLoader.value = false;
      update();
    }
  }

  @override
  void onInit() {
    super.onInit();
    getActivites('', '');
  }
}
