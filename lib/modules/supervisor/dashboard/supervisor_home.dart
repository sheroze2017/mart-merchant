import 'dart:io';

import 'package:ba_merchandise/common/style/color.dart';
import 'package:ba_merchandise/common/style/custom_textstyle.dart';
import 'package:ba_merchandise/core/routes/routes.dart';
import 'package:ba_merchandise/modules/company/operation/view/add_product/product_view.dart';
import 'package:ba_merchandise/modules/b.a/dashboard/widget/profile_section.dart';
import 'package:ba_merchandise/modules/supervisor/operation/bloc/operation_bloc.dart';
import 'package:ba_merchandise/modules/supervisor/operation/view/sumbit_new_report.dart';
import 'package:ba_merchandise/widgets/appbar/custom_appbar.dart';
import 'package:ba_merchandise/widgets/dailog/custom_text_dailog.dart';
import 'package:ba_merchandise/widgets/drawer/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../b.a/dashboard/view/dashboard.dart';

class SupervisorHome extends StatefulWidget {
  SupervisorHome({super.key});

  @override
  State<SupervisorHome> createState() => _SupervisorHomeState();
}

class _SupervisorHomeState extends State<SupervisorHome> {
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
          accType: 'Supervisor',
          title: 'Dashboard',
        ),
        drawer: CustomDrawer(
          userRole: 'Supervisor',
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
                  isCompany: false,
                ),
                SizedBox(
                  height: 0.5.h,
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
                          Get.to(SupervisorNewReport(),
                              transition: Transition.cupertino,
                              duration: Duration(milliseconds: 500));
                        },
                        child: DashboardCard(
                          asset: 'assets/images/product.png',
                          title: 'Submit Mart Report',
                        ),
                      ),
                    ),
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
        shape: RoundedRectangleBorder(
            side: BorderSide(color: AppColors.redLight),
            borderRadius: BorderRadius.circular(10)),
        color: AppColors.whiteColor,
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Image(
                width: 70,
                height: 40,
                color: AppColors.primaryColorDark,
                image: AssetImage(
                  asset,
                ),
              ),
              SizedBox(
                height: 0.5.h,
              ),
              Text(
                textAlign: TextAlign.center,
                title,
                style: CustomTextStyles.w600TextStyle(size: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
