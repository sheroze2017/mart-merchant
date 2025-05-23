import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:ba_merchandise/common/style/color.dart';
import 'package:ba_merchandise/common/style/custom_textstyle.dart';
import 'package:ba_merchandise/common/utils/function.dart';
import 'package:ba_merchandise/modules/admin/operation/view/sales/sales_detail_screen.dart';
import 'package:ba_merchandise/modules/company/operation/bloc/company_sales_bloc.dart';
import 'package:ba_merchandise/modules/company/operation/bloc/operation_bloc.dart';
import 'package:ba_merchandise/widgets/appbar/custom_appbar.dart';
import 'package:ba_merchandise/widgets/button/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CompanySales extends StatelessWidget {
  CompanySales({super.key});
  final controllerCompany = Get.find<CompanyOperationBloc>();
  final TextEditingController martId = TextEditingController();
  final TextEditingController emplyeeId = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Company Sales'),
      body: GetBuilder<SalesCompanyController>(
        init: SalesCompanyController(),
        builder: (controller) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 8, right: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Card(
                        elevation: 2,
                        child: CustomDropdown.search(
                          hintText: 'Select Mart',
                          items: controllerCompany.marts
                              .map((m) => m.martName)
                              .toList(),
                          onChanged: (value) {
                            int exactIndex = controllerCompany.marts
                                .indexWhere((m) => m.martName == value);
                            if (exactIndex != -1) {
                              martId.text = controllerCompany
                                  .marts[exactIndex].martId
                                  .toString();
                              controller.getSalesforMartCompany(
                                  martId.text,
                                  emplyeeId.text.isEmpty
                                      ? null
                                      : emplyeeId.text);
                            }
                          },
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        controller.getSalesforMartCompany('', null);
                      },
                      child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(10)),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(Icons.cancel),
                          )),
                    )
                  ],
                ),
              ),
              Card(
                elevation: 2,
                child: CustomDropdown.search(
                  hintText: 'Select Employee',
                  items:
                      controllerCompany.baNameList.map((m) => m.name).toList(),
                  onChanged: (value) {
                    int exactIndex = controllerCompany.baNameList
                        .indexWhere((m) => m.name == value);
                    if (exactIndex != -1) {
                      emplyeeId.text = controllerCompany
                          .baNameList[exactIndex].userId
                          .toString();
                      controller.getSalesforMartCompany(martId.text,
                          emplyeeId.text.isEmpty ? null : emplyeeId.text);
                    }
                  },
                ),
              ).paddingSymmetric(horizontal: 8),
              Expanded(
                child: controller.salesLoader.value
                    ? Center(
                        child:
                            CircularProgressIndicator()) // Show loader when loading data
                    : controller.individualSales.isEmpty
                        ? Center(
                            child: Text(
                                'No Sales Data Found')) // Show message if no data is found
                        : ListView.builder(
                            itemCount: controller.individualSales.length,
                            itemBuilder: (context, index) {
                              var saleData = controller.individualSales[index];
                              return Card(
                                color: AppColors.primaryColor,
                                elevation: 2,
                                margin: EdgeInsets.all(8),
                                child: ExpansionTile(
                                  title: Text(
                                    'Sales ID: ${saleData.saleId} - ${saleData.martName}',
                                    style: CustomTextStyles.w600TextStyle(),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Reported Date: ${Utils.formatDate(saleData.createdAt.toString()) + ' ' + Utils.formatTime(saleData.createdAt.toString())}',
                                        style: CustomTextStyles.lightTextStyle(
                                            size: 13),
                                      ),
                                      Text(
                                        'BA Name: ${saleData.bA!.name ?? ''}',
                                        style: CustomTextStyles.lightTextStyle(
                                            size: 13),
                                      ),
                                    ],
                                  ),
                                  trailing:
                                      const Icon(Icons.expand_more_rounded),
                                  childrenPadding: const EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 8.0),
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Email: ${saleData.bA!.email ?? ''}',
                                        style: CustomTextStyles.lightTextStyle(
                                            size: 13),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Phone: ${saleData.bA!.phone ?? ''}',
                                        style: CustomTextStyles.lightTextStyle(
                                            size: 13),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 1.h,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: RoundedButton(
                                              text: 'Sales Details',
                                              onPressed: () {
                                                Get.to(
                                                    SalesDetailScreen(
                                                      saleData: saleData,
                                                    ),
                                                    transition:
                                                        Transition.downToUp);
                                              },
                                              backgroundColor:
                                                  AppColors.primaryColorDark,
                                              textColor: AppColors.whiteColor),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
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
