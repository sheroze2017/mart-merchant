import 'package:ba_merchandise/common/utils/function.dart';
import 'package:ba_merchandise/modules/admin/operation/bloc/operation_api.dart';
import 'package:ba_merchandise/modules/admin/operation/model/sales_model.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class SalesCompanyController extends GetxController {
  var salesLoader = false.obs; // Observable to track loading state
  RxList<IndividualSalesData> individualSales = RxList();

  final AdminOperationService _adminOperationService =
      AdminOperationService(); // Assuming you have a service class for API calls

  Future<void> getSalesforMartCompany(String martId) async {
    salesLoader.value = true;
    var userId = await Utils.getUserId();

    try {
      SalesModel response =
          await _adminOperationService.getSales(userId.toString(), martId);
      if (response.data != null && response.code == 200) {
        salesLoader.value = false;
        individualSales.value = response.data ?? [];
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
    getSalesforMartCompany('');
  }
}
