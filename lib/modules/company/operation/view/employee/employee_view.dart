import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:ba_merchandise/common/style/color.dart';
import 'package:ba_merchandise/common/style/custom_textstyle.dart';
import 'package:ba_merchandise/modules/b.a/dashboard/view/dashboard.dart';
import 'package:ba_merchandise/modules/company/operation/bloc/operation_bloc.dart';
import 'package:ba_merchandise/modules/company/operation/model/company_model.dart';
import 'package:ba_merchandise/widgets/appbar/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class EmployeeListScreen extends StatefulWidget {
  EmployeeListScreen({super.key});

  @override
  State<EmployeeListScreen> createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends State<EmployeeListScreen> {
  final CompanyOperationBloc operationBloc = Get.find();
  final SingleSelectController<String> categoryController =
      SingleSelectController<String>(null);
  String category = '';
// Selected Mart ID as a reactive variable
  bool showBa = true;
  bool showSupervisor = false;
  final SingleSelectController<String> controller =
      SingleSelectController<String>(null);

  @override
  void initState() {
    super.initState();
    operationBloc.getAllBa();
    operationBloc.getAllSupervisor();
    operationBloc.getAllCategory();
    operationBloc.selectedCategoryId.value = 0;
    operationBloc.selectedMartId.value = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Employee',
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          operationBloc.getAllBa();
          operationBloc.getAllSupervisor();
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const heading(
                    title: 'All Employee',
                  ),
                ],
              ),
              SizedBox(
                height: 1.h,
              ),
              Card(
                elevation: 2,
                child: CustomDropdown(
                  decoration: CustomDropdownDecoration(
                    prefixIcon: Icon(Icons.person),
                    expandedFillColor: AppColors.primaryColor,
                    closedFillColor: AppColors.primaryColor,
                  ),
                  initialItem: 'BA',
                  hintText: 'Employee Type',
                  items: ['BA', 'MERCHANT', 'SUPERVISOR'],
                  onChanged: (value) {
                    if (value == 'BA') {
                      setState(() {
                        showBa = true;
                      });
                      setState(() {});
                    } else if (value == 'SUPERVISOR') {
                      setState(() {
                        showBa = false;
                        showSupervisor = true;
                      });
                    } else if (value == 'MERCHANT') {
                      setState(() {
                        showBa = false;
                        showSupervisor = false;
                        operationBloc.selectedMartId.value = 0;
                      });
                    }
                  },
                ),
              ),
              showBa == true
                  ? Padding(
                      padding: const EdgeInsets.only(top: 0.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Card(
                              elevation: 2,
                              child: CustomDropdown.search(
                                decoration: CustomDropdownDecoration(
                                  prefixIcon: Icon(Icons.location_on_sharp),
                                  expandedFillColor: AppColors.primaryColor,
                                  closedFillColor: AppColors.primaryColor,
                                ),
                                controller: controller,
                                hintText: 'Select Mart',
                                items: operationBloc.marts
                                    .map((m) => m.martName)
                                    .toList(),
                                onChanged: (value) {
                                  category = '';
                                  categoryController.clear();
                                  operationBloc.selectMartByName(value!);
                                },
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              operationBloc.clearMartSelection();
                              controller.clear();
                              operationBloc.selectedCategoryId.value = 0;
                              categoryController.clear();
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
                          )
                        ],
                      ),
                    )
                  : Container(),
              !showBa
                  ? const SizedBox()
                  : Padding(
                      padding: const EdgeInsets.only(top: 0.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Card(
                              elevation: 2,
                              child: CustomDropdown.search(
                                decoration: CustomDropdownDecoration(
                                  prefixIcon: Icon(Icons.category),
                                  expandedFillColor: AppColors.primaryColor,
                                  closedFillColor: AppColors.primaryColor,
                                ),
                                controller: categoryController,
                                hintText: 'Select Category',
                                items: operationBloc.categories
                                    .map((c) => c.name ?? 'N/A')
                                    .toList(),
                                onChanged: (value) {
                                  categoryController.value = value;
                                  category = value!;
                                  setState(() {});
                                },
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              categoryController.clear();
                              category = '';
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
              showBa
                  ? Expanded(
                      child: Obx(() {
                        final baList = operationBloc.filteredBaList;

                        if (baList.isEmpty) {
                          return const Center(
                              child: Text(
                                  'No employee to show for selected Mart'));
                        }

                        return ListView.builder(
                          itemCount: baList.length,
                          itemBuilder: (context, index) {
                            final data = baList[index];
                            if (data.categoryName == categoryController.value ||
                                category == '') {
                              return Padding(
                                padding: const EdgeInsets.only(top: 2.0),
                                child: Card(
                                  elevation: 2,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: AppColors.primaryColor,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: AppColors.primaryColor,
                                        )),
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Row(
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(40),
                                                  child: Image.asset(
                                                    'assets/images/person.png',
                                                    fit: BoxFit.contain,
                                                    width: 60,
                                                    height: 60,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 2.w,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      data.name ?? 'N/a',
                                                      style: CustomTextStyles
                                                          .w600TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              size: 19),
                                                    ),
                                                    Text(
                                                      'Role: ${data.role}',
                                                      style: CustomTextStyles
                                                          .lightTextStyle(
                                                              color: AppColors
                                                                  .primaryColorDark,
                                                              size: 14),
                                                    ),
                                                    Text(
                                                      'Email: ${data.email}',
                                                      style: CustomTextStyles
                                                          .lightTextStyle(
                                                              color: AppColors
                                                                  .primaryColorDark,
                                                              size: 14),
                                                    ),
                                                    Text(
                                                      'Status: ${data.status}',
                                                      style: CustomTextStyles
                                                          .lightTextStyle(
                                                              color: AppColors
                                                                  .primaryColorDark,
                                                              size: 14),
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              return const SizedBox();
                            }
                          },
                        );
                      }),
                    )
                  : showSupervisor
                      ? Expanded(
                          child: Obx(
                            () {
                              return operationBloc.supervisorNameList.isEmpty
                                  ? Center(
                                      child: Text(
                                          'No Employee to show for selected Mart'),
                                    )
                                  : ListView.builder(
                                      shrinkWrap: true,
                                      physics: AlwaysScrollableScrollPhysics(),
                                      itemCount: operationBloc
                                          .supervisorNameList.length,
                                      itemBuilder: (context, index) {
                                        final data = operationBloc
                                            .supervisorNameList[index];
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(top: 2.0),
                                          child: Card(
                                            elevation: 2,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: AppColors.primaryColor,
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  border: Border.all(
                                                    color:
                                                        AppColors.primaryColor,
                                                  )),
                                              child: Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child: Row(
                                                        children: [
                                                          ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        40),
                                                            child: Image.asset(
                                                              'assets/images/person.png',
                                                              fit: BoxFit
                                                                  .contain,
                                                              width: 80,
                                                              height: 80,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 2.w,
                                                          ),
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                data.name ??
                                                                    'N/a',
                                                                style: CustomTextStyles
                                                                    .w600TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        size:
                                                                            19),
                                                              ),
                                                              Text(
                                                                'Role: ${data.role}',
                                                                style: CustomTextStyles
                                                                    .lightTextStyle(
                                                                        color: AppColors
                                                                            .primaryColorDark,
                                                                        size:
                                                                            14),
                                                              ),
                                                              Text(
                                                                'Email: ${data.email}',
                                                                style: CustomTextStyles
                                                                    .lightTextStyle(
                                                                        color: AppColors
                                                                            .primaryColorDark,
                                                                        size:
                                                                            14),
                                                              ),
                                                              Text(
                                                                'Status: ${data.status}',
                                                                style: CustomTextStyles
                                                                    .lightTextStyle(
                                                                        color: AppColors
                                                                            .primaryColorDark,
                                                                        size:
                                                                            14),
                                                              )
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      });
                            },
                          ),
                        )
                      : Expanded(
                          child: Obx(
                            () {
                              final filteredBaNameList =
                                  operationBloc.merchantNameList.where((data) {
                                // Show all employees when selectedMartId is 0, otherwise filter by martId
                                return operationBloc.selectedMartId.value ==
                                        0 ||
                                    data.martId ==
                                        operationBloc.selectedMartId.value
                                            .toString();
                              }).toList();

                              return filteredBaNameList.isEmpty
                                  ? Center(
                                      child: Text(
                                          'No Employee to show for selected Mart'),
                                    )
                                  : ListView.builder(
                                      shrinkWrap: true,
                                      physics: AlwaysScrollableScrollPhysics(),
                                      itemCount:
                                          operationBloc.merchantNameList.length,
                                      itemBuilder: (context, index) {
                                        final data = operationBloc
                                            .merchantNameList[index];
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(top: 2.0),
                                          child: Card(
                                            elevation: 2,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: AppColors.primaryColor,
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  border: Border.all(
                                                    color:
                                                        AppColors.primaryColor,
                                                  )),
                                              child: Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child: Row(
                                                        children: [
                                                          ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        40),
                                                            child: Image.asset(
                                                              'assets/images/person.png',
                                                              fit: BoxFit
                                                                  .contain,
                                                              width: 80,
                                                              height: 80,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 2.w,
                                                          ),
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                data.name ??
                                                                    'N/a',
                                                                style: CustomTextStyles
                                                                    .w600TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        size:
                                                                            19),
                                                              ),
                                                              Text(
                                                                'Role: ${data.role}',
                                                                style: CustomTextStyles
                                                                    .lightTextStyle(
                                                                        color: AppColors
                                                                            .primaryColorDark,
                                                                        size:
                                                                            14),
                                                              ),
                                                              Text(
                                                                'Email: ${data.email}',
                                                                style: CustomTextStyles
                                                                    .lightTextStyle(
                                                                        color: AppColors
                                                                            .primaryColorDark,
                                                                        size:
                                                                            14),
                                                              ),
                                                              Text(
                                                                'Status: ${data.status}',
                                                                style: CustomTextStyles
                                                                    .lightTextStyle(
                                                                        color: AppColors
                                                                            .primaryColorDark,
                                                                        size:
                                                                            14),
                                                              )
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      });
                            },
                          ),
                        )
            ],
          ),
        ),
      ),
    );
  }
}
