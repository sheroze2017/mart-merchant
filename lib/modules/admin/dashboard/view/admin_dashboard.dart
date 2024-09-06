import 'package:ba_merchandise/common/style/custom_textstyle.dart';
import 'package:ba_merchandise/core/routes/routes.dart';
import 'package:ba_merchandise/modules/b.a/dashboard/widget/profile_section.dart';
import 'package:ba_merchandise/modules/company/operation/view/employee/employee_view.dart';
import 'package:ba_merchandise/widgets/appbar/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../b.a/dashboard/view/dashboard.dart';

class AdminHome extends StatelessWidget {
  const AdminHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        accType: 'Admin',
        title: 'Dashboard',
      ),
      drawer: Drawer(),
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
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Get.toNamed(Routes.NEW_COMPANTY);
                      },
                      child: DashboardCard(
                        asset: 'assets/images/product.png',
                        title: 'Add New Company',
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 1.h,
              ),

              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Get.to(EmployeeListScreen(),
                            transition: Transition.cupertino,
                            duration: Duration(milliseconds: 500));
                      },
                      child: DashboardCard(
                        asset: 'assets/images/economy.png',
                        title: 'Find Company Sales',
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 1.h,
              ),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Get.toNamed(Routes.NEW_COMPANTY);
                      },
                      child: DashboardCard(
                        asset: 'assets/images/product.png',
                        title: 'Find Company',
                      ),
                    ),
                  ),
                ],
              ),
            ],
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
        color: Colors.white,
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
