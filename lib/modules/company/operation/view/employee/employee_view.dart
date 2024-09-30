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
              SizedBox(
                height: 2.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const heading(
                    title: 'All Employee',
                  ),
                ],
              ),
              SizedBox(
                height: 2.h,
              ),
              Obx(
                () => operationBloc.baNameList.value.isEmpty
                    ? Center(
                        child: Text('No Employee to show yet'),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: AlwaysScrollableScrollPhysics(),
                        itemCount: operationBloc.baNameList.length,
                        itemBuilder: (context, index) {
                          final data = operationBloc.baNameList[index];
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
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
                                                        color: Colors.black,
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
                          );
                        }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
