import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:ba_merchandise/common/style/color.dart';
import 'package:ba_merchandise/common/style/custom_textstyle.dart';
import 'package:ba_merchandise/modules/admin/operation/bloc/operation_bloc.dart';
import 'package:ba_merchandise/modules/admin/operation/bloc/restock_bloc.dart';
import 'package:ba_merchandise/modules/b.a/record_data/model/restock_data_model.dart';
import 'package:ba_merchandise/widgets/appbar/custom_appbar.dart';
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
                        controller.getallRestockRequest(
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
                        controller.getallRestockRequest(
                            companyId.text, martId.text);
                      }
                    },
                  ),
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
                                    child: ExpansionTile(
                                      title: Text(
                                        "${toothpaste.productDetails?.productName} - ${toothpaste.martDetails!.martName}",
                                        style: CustomTextStyles.darkTextStyle(),
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
                                                .lightSmallTextStyle(size: 12),
                                          ),
                                          Text(
                                            'Email : ' +
                                                toothpaste.bADetails!.email
                                                    .toString(),
                                            style: CustomTextStyles
                                                .lightSmallTextStyle(size: 12),
                                          ),
                                          Text(
                                            'Phone : ' +
                                                toothpaste.bADetails!.phone
                                                    .toString(),
                                            style: CustomTextStyles
                                                .lightSmallTextStyle(size: 12),
                                          ),
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
