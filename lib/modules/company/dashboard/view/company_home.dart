import 'dart:io';

import 'package:ba_merchandise/common/style/color.dart';
import 'package:ba_merchandise/common/style/custom_textstyle.dart';
import 'package:ba_merchandise/modules/b.a/dashboard/widget/profile_section.dart';
import 'package:ba_merchandise/modules/company/operation/view/employee/employee_view.dart';
import 'package:ba_merchandise/widgets/appbar/custom_appbar.dart';
import 'package:ba_merchandise/widgets/dailog/custom_text_dailog.dart';
import 'package:ba_merchandise/widgets/drawer/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../b.a/dashboard/view/dashboard.dart';
import '../../operation/view/location/location_view.dart';
import '../../operation/view/add_product/product_view.dart';

class CompanyHome extends StatelessWidget {
  const CompanyHome({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        showDialog(
          context: context,
          builder: (context) => CustomDialogMessage(
            dialogText: 'Are you sure you want to exit the app',
            buttonText1: 'No',
            buttonText2: 'Yes',
            onButton1Pressed: () {
              Get.back();
            },
            onButton2Pressed: () {
              exit(0);
            },
          ),
        );
      },
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,
        appBar: CustomAppBar(
          accType: 'Company',
          title: 'Dashboard',
        ),
        drawer: CustomDrawer(
          userRole: 'Company',
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Section
                ProfileSection(
                  showAddress: false,
                ),
                SizedBox(
                  height: 2.h,
                ),
                const Divider(
                  color: Colors.grey,
                  thickness: 0.3,
                ),
                const heading(
                  title: 'Quick Actions',
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Get.to(ProductScreen(),
                              transition: Transition.cupertino,
                              duration: Duration(milliseconds: 500));
                        },
                        child: DashboardCard(
                          asset: 'assets/images/product.png',
                          title: 'Products',
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Get.to(CompanyLocationScreen(),
                              transition: Transition.cupertino,
                              duration: Duration(milliseconds: 500));
                        },
                        child: const DashboardCard(
                          asset: 'assets/images/location.png',
                          title: 'Locations',
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 0.5.h,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: DashboardCard(
                        asset: 'assets/images/economy.png',
                        title: 'Sales',
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Get.to(EmployeeListScreen(),
                              transition: Transition.cupertino,
                              duration: Duration(milliseconds: 500));
                        },
                        child: DashboardCard(
                          asset: 'assets/images/employee.png',
                          title: 'Employees',
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 0.5.h,
                ),
                const Divider(
                  color: Colors.grey,
                  thickness: 0.3,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  final String title;
  final String asset;

  const DashboardCard({
    required this.title,
    required this.asset,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      child: Card(
        color: AppColors.whiteColor,
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Image(
                width: 80,
                height: 40,
                color: Colors.black,
                image: AssetImage(
                  asset,
                ),
              ),
              SizedBox(
                height: 1.h,
              ),
              Text(
                title,
                style: CustomTextStyles.lightTextStyle(size: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
