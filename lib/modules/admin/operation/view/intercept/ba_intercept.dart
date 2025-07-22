import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:ba_merchandise/common/style/color.dart';
import 'package:ba_merchandise/common/style/custom_textstyle.dart';
import 'package:ba_merchandise/common/utils/function.dart';
import 'package:ba_merchandise/modules/admin/operation/bloc/ba_intercept_bloc.dart';
import 'package:ba_merchandise/modules/admin/operation/bloc/operation_bloc.dart';
import 'package:ba_merchandise/modules/admin/operation/bloc/restock_bloc.dart';
import 'package:ba_merchandise/modules/b.a/record_data/model/restock_data_model.dart';
import 'package:ba_merchandise/widgets/appbar/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BaInterceptAdmin extends StatefulWidget {
  BaInterceptAdmin({super.key});

  @override
  State<BaInterceptAdmin> createState() => _BaInterceptAdminState();
}

class _BaInterceptAdminState extends State<BaInterceptAdmin> {
  final TextEditingController martId = TextEditingController();

  final TextEditingController companyId = TextEditingController();

  final AdminOperation controllerCompany = Get.find<AdminOperation>();

  final SingleSelectController<String> catController =
      SingleSelectController<String>(null);

  final SingleSelectController<String> martController =
      SingleSelectController<String>(null);

  final SingleSelectController<String> companyController =
      SingleSelectController<String>(null);

  String catId = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'B.A Intercepts'),
      body: GetBuilder<BAInterceptController>(
        init: BAInterceptController(),
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
                            catController.clear();
                            if (exactIndex != -1) {
                              companyId.text = controllerCompany
                                  .companyNameList[exactIndex].userId
                                  .toString();
                              controller.getInterceptForMartCompany(
                                  companyId.text, martId.text);
                              controllerCompany.getAllCategory(companyId.text);
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    InkWell(
                      onTap: () {
                        companyController.clear();
                        companyId.clear();
                        catController.clear();
                        controller.getInterceptForMartCompany('', martId.text);
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
                padding: const EdgeInsets.only(top: 0.0, left: 12, right: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Card(
                        elevation: 2,
                        child: CustomDropdown.search(
                          controller: martController,
                          decoration: CustomDropdownDecoration(
                            prefixIcon: const Icon(Icons.location_on_sharp),
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
                              controller.getInterceptForMartCompany(
                                  companyId.text, martId.text);
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    InkWell(
                      onTap: () {
                        martController.clear();
                        martId.clear();
                        controller.getInterceptForMartCompany(
                            companyId.text, '');
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
                                    controller: catController,
                                    hintText: 'Select Category',
                                    items: controllerCompany.categories
                                        .map((category) => category.name)
                                        .toList(),
                                    onChanged: (selected) {
                                      if (selected != null) {
                                        catController.value = selected;
                                        setState(() {});
                                      }
                                    },
                                  )),
                            ),
                          ),
                          const SizedBox(width: 5),
                          InkWell(
                            onTap: () {
                              catController.clear();
                              setState(() {});
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
              Obx(
                () => Expanded(
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
                                if (catController.value == null ||
                                    catController.value ==
                                        record['category_name'].toString()) {
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
                                } else {
                                  return const SizedBox();
                                }
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
