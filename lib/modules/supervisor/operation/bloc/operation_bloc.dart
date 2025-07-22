import 'package:ba_merchandise/common/utils/function.dart';
import 'package:ba_merchandise/modules/admin/operation/bloc/operation_api.dart';
import 'package:ba_merchandise/modules/admin/operation/model/all_attendance_model.dart';
import 'package:ba_merchandise/modules/admin/operation/model/company_mart_product_model.dart';
import 'package:ba_merchandise/modules/admin/operation/model/user_by_role_model.dart';
import 'package:ba_merchandise/modules/company/operation/bloc/company_operation_api.dart';
import 'package:ba_merchandise/modules/company/operation/model/company_model.dart';
import 'package:ba_merchandise/modules/company/operation/model/mart_model.dart';
import 'package:ba_merchandise/modules/supervisor/operation/bloc/service_api.dart';
import 'package:ba_merchandise/widgets/custom/error_toast.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class SupervisorOperationBloc extends GetxController {
  var addReportLoader = false.obs;
  var addCategoryLoader = false.obs;

  CompanyOperationService _companyOperationService = CompanyOperationService();
  final AdminOperationService _adminOperationService = AdminOperationService();

  final SupervisorOperationService _supervisorOperationService =
      SupervisorOperationService();

  RxList<CategoryData> categories = RxList();
  RxList<MartData> marts = RxList();
  RxList<IndividualUserAttendance> userAttendance = RxList();
  Rxn<ByUserRoleData> companyIndividual = Rxn();

  @override
  void onInit() async {
    super.onInit();
    getAllMart();
  }

  Future<void> getAllMart() async {
    AllMart response = await _companyOperationService.getAllMart();
    if (response.data != null && response.code == 200) {
      marts.value = response.data ?? [];
    }
  }

  Future<void> createNewSubmission(
      martId, desc, image, latitude, longitude, context) async {
    addReportLoader.value = true;
    final response = await _supervisorOperationService.createNewReport(
        martId: martId,
        desc: desc,
        image: image,
        latitude: latitude.toString(),
        longitude: longitude.toString());
    if (response['data'] != null && response['code'] == 200) {
      addReportLoader.value = false;
      AnimatedSnackbar.showSnackbar(
        context: context,
        message: 'Report added',
        icon: Icons.info,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 14.0,
      );
      Get.back();
    } else {
      addReportLoader.value = false;
      AnimatedSnackbar.showSnackbar(
        context: context,
        message: response['message'],
        icon: Icons.error,
        backgroundColor: const Color.fromARGB(255, 241, 235, 235),
        textColor: Colors.black,
        fontSize: 14.0,
      );
    }
  }
}
