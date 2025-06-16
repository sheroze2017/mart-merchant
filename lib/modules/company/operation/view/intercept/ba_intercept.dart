import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:ba_merchandise/common/style/color.dart';
import 'package:ba_merchandise/common/style/custom_textstyle.dart';
import 'package:ba_merchandise/common/utils/function.dart';
import 'package:ba_merchandise/modules/admin/operation/bloc/ba_intercept_bloc.dart';
import 'package:ba_merchandise/modules/admin/operation/bloc/operation_bloc.dart';
import 'package:ba_merchandise/modules/admin/operation/bloc/restock_bloc.dart';
import 'package:ba_merchandise/modules/b.a/record_data/model/restock_data_model.dart';
import 'package:ba_merchandise/modules/company/operation/bloc/company_ba_intercept_bloc.dart';
import 'package:ba_merchandise/modules/company/operation/bloc/operation_bloc.dart';
import 'package:ba_merchandise/widgets/appbar/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BaInteceptCompany extends StatelessWidget {
  BaInteceptCompany({super.key});
  final controllerCompany = Get.find<CompanyOperationBloc>();
  final TextEditingController martId = TextEditingController();
  final TextEditingController emplyeeId = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'B.A Intercepts'),
      body: GetBuilder<BaInteceptCompanyCompany>(
        init: BaInteceptCompanyCompany(),
        builder: (controller) {
          return Column(
            children: [
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
                        controller.getInterceptForMartCompany(martId.text);
                      }
                    },
                  ),
                ),
              ),
              Expanded(
                child: controller.interceptLoader.value
                    ? Center(
                        child:
                            CircularProgressIndicator()) // Show loader when loading data
                    : controller.baInterceptRecord.isEmpty
                        ? Center(
                            child: Text(
                                'No Data Found')) // Show message if no data is found
                        : ListView.builder(
                            itemCount: controller.baInterceptRecord.length,
                            itemBuilder: (context, index) {
                              dynamic record =
                                  controller.baInterceptRecord[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0, vertical: 4),
                                child: Card(
                                    color: AppColors.primaryColor,
                                    elevation: 2,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                'Dated : ${Utils.formatDate(
                                                  record['created_at']
                                                      .toString(),
                                                )}',
                                                style: CustomTextStyles
                                                    .darkHeadingTextStyle(
                                                        size: 15),
                                              ),
                                              Spacer(),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                'Name:',
                                                style: CustomTextStyles
                                                    .lightSmallTextStyle(
                                                        size: 15,
                                                        color: Colors.red),
                                              ),
                                              Text(
                                                '   ${record['name']}',
                                                style: CustomTextStyles
                                                    .lightSmallTextStyle(
                                                        size: 15,
                                                        color: Colors.red),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                'Email:',
                                                style: CustomTextStyles
                                                    .lightSmallTextStyle(
                                                        size: 15,
                                                        color: Colors.red),
                                              ),
                                              Text(
                                                '   ${record['email']}',
                                                style: CustomTextStyles
                                                    .lightSmallTextStyle(
                                                        size: 15,
                                                        color: Colors.red),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            'Intecept Record : ${record['qty']}',
                                            style: CustomTextStyles
                                                .lightSmallTextStyle(
                                                    size: 15,
                                                    color: Colors.black),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            'Items Sold : ${record['sold']}',
                                            style: CustomTextStyles
                                                .lightSmallTextStyle(
                                                    size: 15,
                                                    color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    )),
                              );
                            },
                          ),
              ),
            ],
          );
        },
      ),
    );
  }
}
