import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:ba_merchandise/common/style/color.dart';
import 'package:ba_merchandise/common/style/custom_textstyle.dart';
import 'package:ba_merchandise/common/utils/function.dart';
import 'package:ba_merchandise/modules/admin/operation/bloc/operation_bloc.dart';
import 'package:ba_merchandise/modules/admin/operation/bloc/supervisor_record_bloc.dart';
import 'package:ba_merchandise/modules/company/operation/view/competitor/activity.dart';
import 'package:ba_merchandise/widgets/appbar/custom_appbar.dart';
import 'package:ba_merchandise/widgets/button/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SupervisorAdminRecord extends StatefulWidget {
  SupervisorAdminRecord({super.key});

  @override
  State<SupervisorAdminRecord> createState() => _SupervisorAdminRecordState();
}

class _SupervisorAdminRecordState extends State<SupervisorAdminRecord> {
  final AdminOperation controllerCompany = Get.find<AdminOperation>();

  final TextEditingController companyId = TextEditingController();

  final TextEditingController martId = TextEditingController();

  final TextEditingController employeeId = TextEditingController();

  final SingleSelectController<String> catController =
      SingleSelectController<String>(null);

  final SingleSelectController<String> martController =
      SingleSelectController<String>(null);

  final SingleSelectController<String> companyController =
      SingleSelectController<String>(null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Supervisor Record'),
      body: GetBuilder<AdminSupervisorRecord>(
        init: AdminSupervisorRecord(), // Initialize the controller
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
                            prefixIcon: Icon(Icons.factory),
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
                            if (exactIndex != -1) {
                              companyId.text = controllerCompany
                                  .companyNameList[exactIndex].userId
                                  .toString();
                              controller.getSupervisorRecord(
                                companyId.text,
                                martId.text,
                              );
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
                        companyId.text = '';
                        controller.getSupervisorRecord(
                          '',
                          martId.text,
                        );
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
                padding: const EdgeInsets.only(top: 8.0, left: 12, right: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Card(
                        elevation: 2,
                        child: CustomDropdown.search(
                          controller: martController,
                          decoration: CustomDropdownDecoration(
                            prefixIcon: Icon(Icons.location_on),
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
                              controller.getSupervisorRecord(
                                companyId.text,
                                martId.text,
                              );
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
                        martId.text = '';
                        controller.getSupervisorRecord(
                          companyId.text,
                          '',
                        );
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
              Expanded(
                child: controller.salesLoader.value
                    ? Center(
                        child:
                            CircularProgressIndicator()) // Show loader when loading data
                    : controller.activityList.isEmpty
                        ? Center(
                            child: Text(
                                'No Data Found')) // Show message if no data is found
                        : ListView.builder(
                            itemCount: controller.activityList.length,
                            itemBuilder: (context, index) {
                              var saleData = controller.activityList[index];
                              return Card(
                                color: AppColors.primaryColor,
                                elevation: 2,
                                margin: EdgeInsets.all(8),
                                child: ExpansionTile(
                                  title: Text(
                                    '${saleData['name']}',
                                    style: CustomTextStyles.w600TextStyle(),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Category Name: ${saleData['category_name']}\nReported Date: ${Utils.formatDate(saleData['created_at']) + ' ' + Utils.formatTime(saleData['created_at'])}',
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
                                        'Email: ${saleData['email'] ?? ''}',
                                        style: CustomTextStyles.lightTextStyle(
                                            size: 13),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Phone: ${saleData['phone'] ?? ''}',
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
                                              text: 'View Report',
                                              onPressed: () {
                                                showActivityDetailsDialog(
                                                  context,
                                                  imageUrl: saleData['image'],
                                                  description:
                                                      saleData['description'],
                                                );
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
