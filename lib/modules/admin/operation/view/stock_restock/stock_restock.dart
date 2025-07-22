import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:ba_merchandise/common/style/color.dart';
import 'package:ba_merchandise/common/style/custom_textstyle.dart';
import 'package:ba_merchandise/common/utils/function.dart';
import 'package:ba_merchandise/modules/admin/operation/bloc/operation_bloc.dart';
import 'package:ba_merchandise/modules/admin/operation/bloc/restock_bloc.dart';
import 'package:ba_merchandise/modules/b.a/record_data/model/restock_data_model.dart';
import 'package:ba_merchandise/widgets/appbar/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShortStockScreenAdmin extends StatefulWidget {
  ShortStockScreenAdmin({super.key});

  @override
  State<ShortStockScreenAdmin> createState() => _ShortStockScreenAdminState();
}

class _ShortStockScreenAdminState extends State<ShortStockScreenAdmin> {
  final TextEditingController martId = TextEditingController();

  final TextEditingController companyId = TextEditingController();

  final AdminOperation controllerCompany = Get.find<AdminOperation>();
  String selectedCategory = '';
  final SingleSelectController<String> categoryController =
      SingleSelectController<String>(null);
  final SingleSelectController<String> companyController =
      SingleSelectController<String>(null);
  final SingleSelectController<String> martController =
      SingleSelectController<String>(null);
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
                padding: const EdgeInsets.only(top: 8.0, left: 12, right: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Card(
                        elevation: 2,
                        child: CustomDropdown.search(
                          controller: companyController,
                          decoration: CustomDropdownDecoration(
                            prefixIcon: const Icon(Icons.factory),
                            expandedFillColor: AppColors.primaryColor,
                            closedFillColor: AppColors.primaryColor,
                          ),
                          hintText: 'Select Company',
                          items: controllerCompany.companyNameList
                              .map((company) => company.name)
                              .toList(),
                          onChanged: (value) {
                            int exactIndex = controllerCompany.companyNameList
                                .indexWhere((m) => m.name == value);
                            categoryController.clear();
                            if (exactIndex != -1) {
                              companyId.text = controllerCompany
                                  .companyNameList[exactIndex].userId
                                  .toString();
                              // Fetch the sales data based on selected company and mart ID
                              controller.getallRestockRequest(
                                  companyId.text, martId.text);
                              controllerCompany.getAllCategory(companyId.text);
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    InkWell(
                      onTap: () {
                        companyController.clear();
                        controller.getallRestockRequest('', martId.text);
                        setState(() {});
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
              Padding(
                padding: const EdgeInsets.only(top: 4.0, left: 12, right: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Card(
                        elevation: 2,
                        child: CustomDropdown.search(
                          controller: martController,
                          decoration: CustomDropdownDecoration(
                            prefixIcon: const Icon(Icons.location_on),
                            expandedFillColor: AppColors.primaryColor,
                            closedFillColor: AppColors.primaryColor,
                          ),
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
                              controller.getallRestockRequest(
                                  companyId.text, martId.text);
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    InkWell(
                      onTap: () {
                        martController.clear();
                        controller.getallRestockRequest(companyId.text, '');
                        setState(() {});
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
              companyId.text.isEmpty
                  ? SizedBox()
                  : Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 4),
                      child: Row(
                        children: [
                          Expanded(
                            child: Card(
                              elevation: 2,
                              child: Obx(() => CustomDropdown.search(
                                    decoration: CustomDropdownDecoration(
                                      prefixIcon: Icon(Icons.category),
                                      expandedFillColor: AppColors.primaryColor,
                                      closedFillColor: AppColors.primaryColor,
                                    ),
                                    controller: categoryController,
                                    hintText: 'Select Category',
                                    items: controllerCompany.categories
                                        .map((category) => category.name)
                                        .toList(),
                                    onChanged: (selected) {
                                      if (selected != null) {
                                        selectedCategory = selected;
                                        setState(() {});
                                      }
                                    },
                                  )),
                            ),
                          ),
                          const SizedBox(width: 5),
                          InkWell(
                            onTap: () {
                              selectedCategory = '';
                              categoryController.clear();
                              setState(() {}); // or update filtering logic
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(Icons.cancel),
                              ),
                            ),
                          ),
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
                              if (categoryController.value == null ||
                                  categoryController.value ==
                                      toothpaste.productDetails!.catName) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12.0, vertical: 4),
                                  child: Card(
                                      color: AppColors.primaryColor,
                                      elevation: 2,
                                      child: ExpansionTile(
                                        title: Text(
                                          "${toothpaste.productDetails?.productName} - ${toothpaste.martDetails!.martName}",
                                          style:
                                              CustomTextStyles.darkTextStyle()
                                                  .copyWith(fontSize: 16),
                                        ),
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'varient: ${toothpaste.productDetails?.variant} \nPrice :  ${toothpaste.productDetails?.price} pkr',
                                              style: CustomTextStyles
                                                  .lightSmallTextStyle(),
                                            ),
                                            Text(
                                              'Request By : ' +
                                                  toothpaste.bADetails!.name
                                                      .toString(),
                                              style: CustomTextStyles
                                                  .lightSmallTextStyle(
                                                      size: 12),
                                            ),
                                            Text(
                                              'Email : ' +
                                                  toothpaste.bADetails!.email
                                                      .toString(),
                                              style: CustomTextStyles
                                                  .lightSmallTextStyle(
                                                      size: 12),
                                            ),
                                            Text(
                                              'Phone : ' +
                                                  toothpaste.bADetails!.phone
                                                      .toString(),
                                              style: CustomTextStyles
                                                  .lightSmallTextStyle(
                                                      size: 12),
                                            ),
                                            Text(
                                                'Date record: ${Utils.formatDay(toothpaste.createdAt.toString())} ${Utils.formatDate(toothpaste.createdAt.toString())}',
                                                style: CustomTextStyles
                                                        .darkTextStyle()
                                                    .copyWith(fontSize: 11)),
                                          ],
                                        ),
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Mart Name : ' +
                                                      toothpaste
                                                          .martDetails!.martName
                                                          .toString(),
                                                  style: CustomTextStyles
                                                      .lightSmallTextStyle(
                                                          size: 12),
                                                ),
                                                Text(
                                                  'Location : ' +
                                                      toothpaste
                                                          .martDetails!.location
                                                          .toString(),
                                                  style: CustomTextStyles
                                                      .lightSmallTextStyle(
                                                          size: 12),
                                                ),
                                                // Row(
                                                //   children: [
                                                //     Expanded(
                                                //       child: RoundedButton(
                                                //         onPressed: () {
                                                //           showDialog(
                                                //             context: context,
                                                //             builder: (BuildContext
                                                //                 context) {
                                                //               return AlertDialog(
                                                //                 shape:
                                                //                     RoundedRectangleBorder(
                                                //                   borderRadius:
                                                //                       BorderRadius
                                                //                           .circular(
                                                //                               12.0),
                                                //                 ),
                                                //                 contentPadding:
                                                //                     EdgeInsets
                                                //                         .all(
                                                //                             16.0),
                                                //                 content: Column(
                                                //                   mainAxisSize:
                                                //                       MainAxisSize
                                                //                           .min, // Keep the dialog size to its content size
                                                //                   crossAxisAlignment:
                                                //                       CrossAxisAlignment
                                                //                           .start,
                                                //                   children: [
                                                //                     const Text(
                                                //                       'Change Status',
                                                //                       style:
                                                //                           TextStyle(
                                                //                         fontSize:
                                                //                             18,
                                                //                         fontWeight:
                                                //                             FontWeight
                                                //                                 .bold,
                                                //                       ),
                                                //                     ),
                                                //                     const SizedBox(
                                                //                         height:
                                                //                             10),
                                                //                     Text(
                                                //                       'If you asked for a restock by mistake, you can cancel your request below.',
                                                //                       style: CustomTextStyles
                                                //                           .lightTextStyle(),
                                                //                     ),
                                                //                     const SizedBox(
                                                //                         height:
                                                //                             10),
                                                //                     Align(
                                                //                       alignment:
                                                //                           Alignment
                                                //                               .centerRight,
                                                //                       child:
                                                //                           RoundedButton(
                                                //                         text:
                                                //                             'Cancelled',
                                                //                         onPressed:
                                                //                             () {
                                                //                           controller.removeRestockRequest(
                                                //                               toothpaste.restockId.toString(),
                                                //                               'Cancelled by Admin',
                                                //                               context);
                                                //                           Get.back(); // Close the dialog after action
                                                //                         },
                                                //                         backgroundColor:
                                                //                             Colors
                                                //                                 .red,
                                                //                         textColor:
                                                //                             Colors
                                                //                                 .white,
                                                //                       ),
                                                //                     ),
                                                //                     const SizedBox(
                                                //                         height:
                                                //                             10),
                                                //                     Text(
                                                //                       'If the restock is done, change the status to completed.',
                                                //                       style: CustomTextStyles
                                                //                           .lightTextStyle(),
                                                //                     ),
                                                //                     const SizedBox(
                                                //                         height:
                                                //                             10),
                                                //                     Align(
                                                //                       alignment:
                                                //                           Alignment
                                                //                               .centerRight,
                                                //                       child:
                                                //                           RoundedButton(
                                                //                         text:
                                                //                             'Completed',
                                                //                         onPressed:
                                                //                             () {
                                                //                           controller.removeRestockRequest(
                                                //                               toothpaste.restockId.toString(),
                                                //                               'Completed',
                                                //                               context);
                                                //                           Get.back(); // Close the dialog after action
                                                //                         },
                                                //                         backgroundColor:
                                                //                             AppColors
                                                //                                 .primaryColorDark,
                                                //                         textColor:
                                                //                             AppColors
                                                //                                 .whiteColor,
                                                //                       ),
                                                //                     ),
                                                //                   ],
                                                //                 ),
                                                //               );
                                                //             },
                                                //           );
                                                //         },
                                                //         text: 'Change',
                                                //         textColor:
                                                //             AppColors.whiteColor,
                                                //         backgroundColor: AppColors
                                                //             .primaryColorDark,
                                                //       ),
                                                //     ),
                                                //   ],
                                                // ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      )),
                                );
                              } else {
                                return SizedBox();
                              }
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
