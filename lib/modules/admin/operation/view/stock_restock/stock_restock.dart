import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:ba_merchandise/common/style/color.dart';
import 'package:ba_merchandise/common/style/custom_textstyle.dart';
import 'package:ba_merchandise/modules/admin/operation/bloc/operation_bloc.dart';
import 'package:ba_merchandise/modules/admin/operation/bloc/restock_bloc.dart';
import 'package:ba_merchandise/modules/company/operation/bloc/company_short_stock_bloc.dart';
import 'package:ba_merchandise/modules/company/operation/bloc/operation_bloc.dart';
import 'package:ba_merchandise/widgets/appbar/custom_appbar.dart';
import 'package:ba_merchandise/widgets/button/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShortStockScreenAdmin extends StatelessWidget {
  ShortStockScreenAdmin({super.key});
  final TextEditingController martId = TextEditingController();
  final TextEditingController companyId = TextEditingController();

  final AdminOperation controllerCompany = Get.find<AdminOperation>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Short Stock'),
      body: GetBuilder<ShortStockControllerAdmin>(
        init: ShortStockControllerAdmin(),
        builder: (controller) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
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
                      controller.getallRestockRequest(
                          companyId.text, martId.text);
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: CustomDropdown.search(
                  hintText: 'Select Mart',
                  items:
                      controllerCompany.marts.map((m) => m.martName).toList(),
                  onChanged: (value) {
                    int exactIndex = controllerCompany.marts
                        .indexWhere((m) => m.martName == value);
                    if (exactIndex != -1) {
                      martId.text =
                          controllerCompany.marts[exactIndex].martId.toString();
                      controller.getallRestockRequest(
                          companyId.text, martId.text);
                    }
                  },
                ),
              ),
              Expanded(
                child: controller.allRestockLoader.value
                    ? Center(
                        child:
                            CircularProgressIndicator()) // Show loader when loading data
                    : controller.restockRecordCompany.isEmpty
                        ? Center(
                            child: Text(
                                'No Data Found')) // Show message if no data is found
                        : ListView.builder(
                            itemCount: controller.restockRecordCompany.length,
                            itemBuilder: (context, index) {
                              var toothpaste =
                                  controller.restockRecordCompany[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0, vertical: 4),
                                child: Card(
                                  color: AppColors.primaryColor,
                                  elevation: 2,
                                  child: ListTile(
                                      minVerticalPadding: 20,
                                      title: Text(
                                          toothpaste.productDetails!
                                                  .productName ??
                                              'N/a',
                                          style:
                                              CustomTextStyles.darkTextStyle()),
                                      subtitle: Text(
                                          '${toothpaste.productDetails!.variant} \nPrice Available ${toothpaste.productDetails!.price}',
                                          style: CustomTextStyles
                                              .lightSmallTextStyle()),
                                      trailing: Column(
                                        children: [
                                          RoundedButtonSmall(
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12.0),
                                                    ),
                                                    contentPadding:
                                                        EdgeInsets.all(16.0),
                                                    content: Column(
                                                      mainAxisSize: MainAxisSize
                                                          .min, // Keep the dialog size to its content size
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        const Text(
                                                          'Change Status',
                                                          style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            height: 10),
                                                        Text(
                                                          'If you ask for restock by mistaken then cancel your request from below',
                                                          style: CustomTextStyles
                                                              .lightTextStyle(),
                                                        ),
                                                        const SizedBox(
                                                            height: 10),
                                                        Align(
                                                            alignment: Alignment
                                                                .centerRight,
                                                            child:
                                                                RoundedButton(
                                                                    text:
                                                                        'Cancelled',
                                                                    onPressed:
                                                                        () {
                                                                      controller.removeRestockRequest(
                                                                          toothpaste
                                                                              .restockId
                                                                              .toString(),
                                                                          'Cancelled by Admin',
                                                                          context);
                                                                    },
                                                                    backgroundColor:
                                                                        Colors
                                                                            .red,
                                                                    textColor:
                                                                        Colors
                                                                            .white)),
                                                        SizedBox(height: 10),
                                                        Text(
                                                          'If restock is done then change status to completed',
                                                          style: CustomTextStyles
                                                              .lightTextStyle(),
                                                        ),
                                                        const SizedBox(
                                                            height: 10),
                                                        Align(
                                                            alignment: Alignment
                                                                .centerRight,
                                                            child:
                                                                RoundedButton(
                                                                    text:
                                                                        'Completed',
                                                                    onPressed:
                                                                        () {
                                                                      controller.removeRestockRequest(
                                                                          toothpaste
                                                                              .restockId
                                                                              .toString(),
                                                                          'Completed',
                                                                          context);
                                                                    },
                                                                    backgroundColor:
                                                                        AppColors
                                                                            .primaryColorDark,
                                                                    textColor:
                                                                        AppColors
                                                                            .whiteColor)),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              );

                                              // Call a metho
                                              //d from the controller to remove the item
                                              ///controller.removeRestockRecord(toothpaste);
                                            },
                                            text: 'Change',
                                            textColor: AppColors.whiteColor,
                                            backgroundColor:
                                                AppColors.primaryColorDark,
                                          ),
                                        ],
                                      )),
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
