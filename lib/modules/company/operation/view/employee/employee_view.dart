import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:ba_merchandise/common/style/color.dart';
import 'package:ba_merchandise/common/style/custom_textstyle.dart';
import 'package:ba_merchandise/modules/b.a/dashboard/view/dashboard.dart';
import 'package:ba_merchandise/modules/company/operation/bloc/operation_bloc.dart';
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
  final RxInt selectedMartId =
      RxInt(0); // Selected Mart ID as a reactive variable

  @override
  void initState() {
    super.initState();
    operationBloc.getAllBa();
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
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 0, right: 0),
                child: Row(
                  children: [
                    Expanded(
                      child: Card(
                        elevation: 2,
                        child: CustomDropdown.search(
                          hintText: 'Select Mart',
                          items: operationBloc.marts
                              .map((m) => m.martName)
                              .toList(),
                          onChanged: (value) {
                            // Find the index of the selected mart
                            int exactIndex = operationBloc.marts
                                .indexWhere((m) => m.martName == value);
                            if (exactIndex != -1) {
                              // Update the selectedMartId with the martId of the selected mart
                              selectedMartId.value =
                                  operationBloc.marts[exactIndex].martId ?? 0;
                            }
                          },
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        selectedMartId.value = 0;
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
                child: Obx(
                  () {
                    final filteredBaNameList =
                        operationBloc.baNameList.where((data) {
                      // Show all employees when selectedMartId is 0, otherwise filter by martId
                      return selectedMartId.value == 0 ||
                          data.martId == selectedMartId.value.toString();
                    }).toList();

                    return filteredBaNameList.isEmpty
                        ? Center(
                            child:
                                Text('No Employee to show for selected Mart'),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: AlwaysScrollableScrollPhysics(),
                            itemCount: operationBloc.baNameList.length,
                            itemBuilder: (context, index) {
                              final data = operationBloc.baNameList[index];
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
                                                    width: 80,
                                                    height: 80,
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
