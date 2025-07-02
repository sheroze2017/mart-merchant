import 'package:ba_merchandise/modules/admin/operation/bloc/operation_api.dart';
import 'package:ba_merchandise/modules/admin/operation/model/sales_model.dart';
import 'package:get/get.dart';

class SalesController extends GetxController {
  var salesLoader = false.obs; // Observable to track loading state
  RxList<IndividualSalesData> individualSales = RxList();

  final AdminOperationService _adminOperationService =
      AdminOperationService(); // Assuming you have a service class for API calls

  Future<void> getSalesforMartCompany(
      String companyId, String martId, String? userId) async {
    salesLoader.value = true;
    try {
      SalesModel response =
          await _adminOperationService.getSales(companyId, martId, userId);
      if (response.data != null && response.code == 200) {
        salesLoader.value = false;
        individualSales.value = (response.data ?? []).reversed.toList();
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
    getSalesforMartCompany('', '', null);
  }
}
