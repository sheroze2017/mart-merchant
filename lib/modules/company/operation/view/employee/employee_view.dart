import 'package:ba_merchandise/common/style/color.dart';
import 'package:ba_merchandise/common/style/custom_textstyle.dart';
import 'package:ba_merchandise/modules/b.a/dashboard/view/dashboard.dart';
import 'package:ba_merchandise/modules/company/dashboard/view/company_home.dart';
import 'package:ba_merchandise/modules/company/operation/bloc/operation_bloc.dart';
import 'package:ba_merchandise/modules/company/operation/view/employee/new_employee.dart';
import 'package:ba_merchandise/widgets/appbar/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class EmployeeListScreen extends StatelessWidget {
  EmployeeListScreen({super.key});
  final CompanyOperationBloc operationBloc = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Employee',
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        Get.to(AddNewEmployee(),
                            transition: Transition.rightToLeft);
                      },
                      child: const DashboardCard(
                        asset: 'assets/images/employee.png',
                        title: 'Add New Employee',
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 2.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const heading(
                    title: 'All Employee',
                  ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.black),
                    child: Padding(
                      padding: EdgeInsets.all(3.0),
                      child: Icon(
                        Icons.sort,
                        size: 20,
                        color: AppColors.whiteColor,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 2.h,
              ),
              Obx(
                () => ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: operationBloc.employees.length,
                    itemBuilder: (context, index) {
                      final data = operationBloc.employees[index];
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey)),
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(40),
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
                                            data.name,
                                            style:
                                                CustomTextStyles.w600TextStyle(
                                                    color: Colors.black,
                                                    size: 19),
                                          ),
                                          Text(
                                            'Role ${data.role}',
                                            style:
                                                CustomTextStyles.lightTextStyle(
                                                    color: Colors.grey,
                                                    size: 14),
                                          ),
                                          Text(
                                            'Age: ${data.age}',
                                            style:
                                                CustomTextStyles.lightTextStyle(
                                                    color: Colors.grey,
                                                    size: 14),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                Icon(
                                  Icons.open_in_browser,
                                  size: 30,
                                  color: Colors.black,
                                )
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
