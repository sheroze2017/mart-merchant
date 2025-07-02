import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:ba_merchandise/common/style/color.dart';
import 'package:ba_merchandise/common/style/custom_textstyle.dart';
import 'package:ba_merchandise/common/utils/function.dart';
import 'package:ba_merchandise/core/routes/routes.dart';
import 'package:ba_merchandise/modules/admin/operation/view/sales/sales_detail_screen.dart';
import 'package:ba_merchandise/modules/b.a/record_data/bloc/ba_inidividual_sales_bloc.dart';
import 'package:ba_merchandise/modules/b.a/record_data/bloc/insert_sales_bloc.dart';
import 'package:ba_merchandise/modules/b.a/record_data/view/edit_sale.dart';
import 'package:ba_merchandise/modules/company/operation/bloc/company_sales_bloc.dart';
import 'package:ba_merchandise/modules/company/operation/bloc/operation_bloc.dart';
import 'package:ba_merchandise/widgets/appbar/custom_appbar.dart';
import 'package:ba_merchandise/widgets/button/rounded_button.dart';
import 'package:ba_merchandise/widgets/dailog/custom_text_dailog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class BaIndividualSales extends StatelessWidget {
  BaIndividualSales({super.key});
  final controllerCompany = Get.find<CompanyOperationBloc>();
  final TextEditingController martId = TextEditingController();
  final TextEditingController emplyeeId = TextEditingController();
  final InsertSalesRecord salesController = Get.put(InsertSalesRecord());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Your Sales'),
      body: GetBuilder<SalesBaController>(
        init: SalesBaController(),
        builder: (controller) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RoundedButton(
                    text: 'Record New Sale',
                    onPressed: () {
                      Get.toNamed(Routes.RECORD_SALES);
                    },
                    backgroundColor: AppColors.primaryColorDark,
                    textColor: Colors.white),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text('Your Sales',
                      style: CustomTextStyles.darkHeadingTextStyle()),
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    await controller.getSalesForBa(); // your refresh logic
                  },
                  child: controller.salesLoader.value
                      ? ListView(
                          // ensure RefreshIndicator can work while loading
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: const [
                            SizedBox(height: 300),
                            Center(child: CircularProgressIndicator()),
                          ],
                        )
                      : controller.individualSales.isEmpty
                          ? ListView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              children: const [
                                SizedBox(height: 300),
                                Center(child: Text('No Sales Data Found')),
                              ],
                            )
                          : ListView.builder(
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemCount: controller.individualSales.length,
                              itemBuilder: (context, index) {
                                var saleData =
                                    controller.individualSales[index];
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
                                          style:
                                              CustomTextStyles.lightTextStyle(
                                                  size: 13),
                                        ),
                                        Text(
                                          'BA Name: ${saleData.bA!.name ?? ''}',
                                          style:
                                              CustomTextStyles.lightTextStyle(
                                                  size: 13),
                                        ),
                                        Align(
                                          alignment: Alignment.bottomRight,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  showDialog(
                                                      context: context,
                                                      builder: (context) =>
                                                          CustomDialogMessage(
                                                            dialogText:
                                                                'Are you sure you want to delete this sale',
                                                            buttonText1: 'No',
                                                            buttonText2: 'Yes',
                                                            onButton1Pressed:
                                                                () {
                                                              Get.back();
                                                            },
                                                            onButton2Pressed:
                                                                () {
                                                              salesController
                                                                  .deleteSaleById(
                                                                      saleData
                                                                          .saleId
                                                                          .toString(),
                                                                      context);
                                                            },
                                                          ));
                                                },
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    const Icon(
                                                      Icons.delete,
                                                      color: Colors.red,
                                                    ),
                                                    Text(
                                                      'Delete',
                                                      style: CustomTextStyles
                                                          .lightSmallTextStyle(
                                                              size: 14,
                                                              color:
                                                                  Colors.red),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 20,
                                              ),
                                              InkWell(
                                                  onTap: () {
                                                    Get.to(
                                                        EditRecordSalesScreen(
                                                            saleData:
                                                                saleData));
                                                  },
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      const Icon(
                                                        Icons.edit,
                                                        size: 20,
                                                        color: Colors.black,
                                                      ),
                                                      Text(
                                                        'Edit',
                                                        style: CustomTextStyles
                                                            .lightSmallTextStyle(
                                                                size: 14,
                                                                color: Colors
                                                                    .black),
                                                      )
                                                    ],
                                                  ))
                                            ],
                                          ),
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
                                          style:
                                              CustomTextStyles.lightTextStyle(
                                                  size: 13),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          'Phone: ${saleData.bA!.phone ?? ''}',
                                          style:
                                              CustomTextStyles.lightTextStyle(
                                                  size: 13),
                                        ),
                                      ),
                                      SizedBox(height: 1.h),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: RoundedButton(
                                              text: 'Sales Details',
                                              onPressed: () {
                                                Get.to(
                                                  SalesDetailScreen(
                                                      saleData: saleData),
                                                  transition:
                                                      Transition.downToUp,
                                                );
                                              },
                                              backgroundColor:
                                                  AppColors.primaryColorDark,
                                              textColor: AppColors.whiteColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
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
