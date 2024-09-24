import 'dart:io';

import 'package:ba_merchandise/common/style/color.dart';
import 'package:ba_merchandise/common/style/custom_textstyle.dart';
import 'package:ba_merchandise/core/routes/routes.dart';
import 'package:ba_merchandise/modules/admin/dashboard/widget/dashboard_card.dart';
import 'package:ba_merchandise/modules/b.a/dashboard/widget/profile_section.dart';
import 'package:ba_merchandise/modules/company/operation/view/employee/employee_view.dart';
import 'package:ba_merchandise/widgets/appbar/custom_appbar.dart';
import 'package:ba_merchandise/widgets/dailog/custom_text_dailog.dart';
import 'package:ba_merchandise/widgets/drawer/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../b.a/dashboard/view/dashboard.dart';

class AdminHome extends StatelessWidget {
  const AdminHome({super.key});

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
          accType: 'Admin',
          title: 'Dashboard',
        ),
        drawer: CustomDrawer(
          userRole: 'Admin',
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
                const heading(
                  title: 'Quick Actions',
                ),
                SizedBox(
                  height: 0.5.h,
                ),
                DashboardCard(
                  asset: 'assets/images/product.png',
                  title: 'Add New Company',
                  onTap: () {
                    Get.toNamed(Routes.NEW_COMPANTY);
                  },
                ),
                DashboardCard(
                  asset: 'assets/images/search.png',
                  title: 'Search Company Products',
                  onTap: () {
                    Get.toNamed(Routes.SEARCHCOMPANYPRODUCT);
                  },
                ),
                DashboardCard(
                  asset: 'assets/images/employee.png',
                  title: 'Assign Employee To Company',
                  onTap: () {
                    Get.toNamed(Routes.ASSIGNNEWEMPLOYEE);
                  },
                ),
                DashboardCard(
                  asset: 'assets/images/attendance.png',
                  title: 'B.A Attendance',
                  onTap: () {
                    Get.toNamed(Routes.BAADMINATTENDANCE);
                  },
                ),
                DashboardCard(
                  asset: 'assets/images/grant.png',
                  title: 'Grant And Revoke Access',
                  onTap: () {
                    Get.toNamed(Routes.GRANTREVOKEACCESS);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
