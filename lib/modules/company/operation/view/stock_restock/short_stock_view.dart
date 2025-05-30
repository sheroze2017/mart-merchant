import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:ba_merchandise/common/style/color.dart';
import 'package:ba_merchandise/common/style/custom_textstyle.dart';
import 'package:ba_merchandise/common/utils/function.dart';
import 'package:ba_merchandise/modules/b.a/record_data/model/restock_data_model.dart';
import 'package:ba_merchandise/modules/company/operation/bloc/company_short_stock_bloc.dart';
import 'package:ba_merchandise/modules/company/operation/bloc/operation_bloc.dart';
import 'package:ba_merchandise/widgets/appbar/custom_appbar.dart';
import 'package:ba_merchandise/widgets/button/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShortStockScreen extends StatefulWidget {
  ShortStockScreen({super.key});

  @override
  State<ShortStockScreen> createState() => _ShortStockScreenState();
}

class _ShortStockScreenState extends State<ShortStockScreen> {
  final controllerCompany = Get.find<CompanyOperationBloc>();

  final TextEditingController martId = TextEditingController();
  @override
  void initState() {
    super.initState();
    if (controllerCompany.marts.isEmpty) {
      controllerCompany.getAllMart();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Short Stock'),
      body: GetBuilder<ShortStockController>(
        init: ShortStockController(),
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
                        child: Obx(
                          () => CustomDropdown.search(
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
                                controller.getallRestockRequest(martId.text);
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        controller.getallRestockRequest('');
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
                              IndividualRestockData toothpaste =
                                  controller.restockRecordCompany[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0, vertical: 4),
                                child: Card(
                                  color: AppColors.primaryColor,
                                  elevation: 2,
                                  child: ListTile(
                                      minVerticalPadding: 15,
                                      contentPadding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      title: Text(
                                          toothpaste.productDetails!.productName
                                                  .toString() +
                                              '' +
                                              toothpaste.productDetails!.variant
                                                  .toString(),
                                          style: CustomTextStyles
                                              .darkHeadingTextStyle(size: 18)),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              'Varient: ${toothpaste.productDetails!.variant}\nPrice: ${toothpaste.productDetails!.price}',
                                              style: CustomTextStyles
                                                  .lightSmallTextStyle(
                                                      size: 14,
                                                      color: AppColors
                                                          .primaryColorDark)),
                                          Text(
                                              '\nDate record: ${Utils.formatDay(toothpaste.createdAt.toString())} ${Utils.formatDate(toothpaste.createdAt.toString())}',
                                              style: CustomTextStyles
                                                      .darkTextStyle()
                                                  .copyWith(fontSize: 11)),
                                        ],
                                      ),
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
                                                        // const SizedBox(
                                                        //     height: 10),
                                                        // Text(
                                                        //   'If you ask for restock by mistaken then cancel your request from below',
                                                        //   style: CustomTextStyles
                                                        //       .lightTextStyle(),
                                                        // ),
                                                        // const SizedBox(
                                                        //     height: 10),
                                                        // Align(
                                                        //     alignment: Alignment
                                                        //         .centerRight,
                                                        //     child:
                                                        //         RoundedButton(
                                                        //             text:
                                                        //                 'Cancelled',
                                                        //             onPressed:
                                                        //                 () {
                                                        //               controller.removeRestockRequest(
                                                        //                   toothpaste
                                                        //                       .restockId
                                                        //                       .toString(),
                                                        //                   'Cancelled by Admin',
                                                        //                   context);
                                                        //             },
                                                        //             backgroundColor:
                                                        //                 Colors
                                                        //                     .red,
                                                        //             textColor:
                                                        //                 Colors
                                                        //                     .white)),

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
                                                                          'stock',
                                                                          context);
                                                                      controller
                                                                          .getallRestockRequest(
                                                                              '');
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
                                            text: 'Restock',
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
