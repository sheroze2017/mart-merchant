import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:ba_merchandise/common/style/color.dart';
import 'package:ba_merchandise/common/style/custom_textstyle.dart';
import 'package:ba_merchandise/common/utils/function.dart';
import 'package:ba_merchandise/modules/admin/operation/bloc/merchant_restock_controller.dart';
import 'package:ba_merchandise/modules/admin/operation/bloc/operation_bloc.dart';
import 'package:ba_merchandise/modules/admin/operation/bloc/restock_bloc.dart';
import 'package:ba_merchandise/modules/b.a/record_data/model/restock_data_model.dart';
import 'package:ba_merchandise/modules/company/operation/model/merchant_restock_model.dart';
import 'package:ba_merchandise/modules/company/operation/view/stock_restock/restock_detail_screen.dart';
import 'package:ba_merchandise/widgets/appbar/custom_appbar.dart';
import 'package:ba_merchandise/widgets/button/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class MerchantRestockDetail extends StatelessWidget {
  MerchantRestockDetail({super.key});
  final TextEditingController martId = TextEditingController();
  final TextEditingController companyId = TextEditingController();

  final AdminOperation controllerCompany = Get.find<AdminOperation>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Merchant Restock'),
      body: GetBuilder<MerchantRestockBlocAdmin>(
        init: MerchantRestockBlocAdmin(),
        builder: (controller) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 12, right: 12),
                child: Card(
                  elevation: 2,
                  child: CustomDropdown.search(
                    hintText: 'Select Company',
                    items: controllerCompany.companyNameList
                        .map((company) => company.name)
                        .toList(),
                    onChanged: (value) {
                      int exactIndex = controllerCompany.companyNameList
                          .indexWhere((m) => m.name == value);
                      if (exactIndex != -1) {
                        companyId.text = controllerCompany
                            .companyNameList[exactIndex].userId
                            .toString();
                        // Fetch the sales data based on selected company and mart ID
                        controller.getAllMerchantRestockDetail(
                            companyId.text, martId.text);
                      }
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 12, right: 12),
                child: Card(
                  elevation: 2,
                  child: CustomDropdown.search(
                    hintText: 'Select Mart',
                    items:
                        controllerCompany.marts.map((m) => m.martName).toList(),
                    onChanged: (value) {
                      int exactIndex = controllerCompany.marts
                          .indexWhere((m) => m.martName == value);
                      if (exactIndex != -1) {
                        martId.text = controllerCompany.marts[exactIndex].martId
                            .toString();
                        controller.getAllMerchantRestockDetail(
                            companyId.text, martId.text);
                      }
                    },
                  ),
                ),
              ),
              Obx(
                () => Expanded(
                  child: controller.merchantstockDetailLoader.value
                      ? Center(
                          child:
                              CircularProgressIndicator()) // Show loader when loading data
                      : controller.merchantRestockRecordList.isEmpty
                          ? Center(
                              child: Text(
                                  'No Data Found')) // Show message if no data is found
                          : ListView.builder(
                              itemCount:
                                  controller.merchantRestockRecordList.length,
                              itemBuilder: (context, index) {
                                MerchantIndividualRestockDetail data =
                                    controller.merchantRestockRecordList[index];
                                return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12.0, vertical: 4),
                                    child: Card(
                                      color: AppColors.primaryColor,
                                      elevation: 2,
                                      child: ExpansionTile(
                                        title: Text(
                                          data.merchantDetails!.name.toString(),
                                          style:
                                              CustomTextStyles.darkTextStyle(),
                                        ),
                                        subtitle: Text(
                                          'Reported: ${Utils.formatDate(data.createdAt.toString())} ${Utils.formatDay(data.createdAt.toString())}',
                                          style: CustomTextStyles
                                              .lightSmallTextStyle(),
                                        ),
                                        trailing: const Icon(
                                            Icons.expand_more_rounded),
                                        childrenPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 16.0,
                                                vertical: 0.0),
                                        children: [
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              'Email: ${data.merchantDetails!.email}',
                                              style: CustomTextStyles
                                                  .lightTextStyle(size: 13),
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              'phone: ${data.merchantDetails!.phone}',
                                              style: CustomTextStyles
                                                  .lightTextStyle(size: 13),
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              '',
                                              style: CustomTextStyles
                                                  .lightTextStyle(size: 13),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 1.h,
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: RoundedButton(
                                                    text: 'Details',
                                                    onPressed: () {
                                                      Get.to(
                                                          RestockDetailScreen(
                                                            data: data,
                                                          ),
                                                          transition: Transition
                                                              .rightToLeft);
                                                    },
                                                    backgroundColor: AppColors
                                                        .primaryColorDark,
                                                    textColor:
                                                        AppColors.whiteColor),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 1.h,
                                          ),
                                        ],
                                      ),
                                    ));
                              },
                            ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
