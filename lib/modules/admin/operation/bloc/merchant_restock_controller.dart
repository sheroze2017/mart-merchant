import 'package:ba_merchandise/modules/b.a/record_data/bloc/ba_operation_api.dart';
import 'package:ba_merchandise/modules/b.a/record_data/model/restock_data_model.dart';
import 'package:ba_merchandise/modules/company/operation/bloc/company_operation_api.dart';
import 'package:ba_merchandise/modules/company/operation/model/merchant_restock_model.dart';
import 'package:get/get.dart';

class MerchantRestockBlocAdmin extends GetxController {
  BaOperationService baOperationService = BaOperationService();
  CompanyOperationService _companyOperationService = CompanyOperationService();

  var allRestockLoader = false.obs;
  var merchantstockDetailLoader = false.obs;

  RxList restockRecordCompany = <IndividualRestockData>[].obs;
  RxList merchantRestockRecordList = <MerchantIndividualRestockDetail>[].obs;

  Future<void> getAllMerchantRestockDetail(companyId, martId) async {
    merchantstockDetailLoader.value = true;
    try {
      MerchantRestockDetailModel? response =
          await _companyOperationService.getAllMerchantRestockRequestAdmin(
              companyId.toString(), martId.toString());

      if (response!.data != null && response.code == 200) {
        merchantRestockRecordList.value = response.data ?? [];
        merchantstockDetailLoader.value = false;
        update(); // Notify listeners to rebuild UI
      } else {}
    } catch (e) {
      merchantstockDetailLoader.value = false;
      update();
    }
  }

  @override
  void onInit() {
    super.onInit();
    getAllMerchantRestockDetail('', '');
  }
}
