import 'package:ba_merchandise/common/style/custom_textstyle.dart';
import 'package:ba_merchandise/modules/b.a/dashboard/widget/profile_section.dart';
import 'package:ba_merchandise/modules/company/operation/view/employee/employee_view.dart';
import 'package:ba_merchandise/widgets/appbar/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../b.a/dashboard/view/dashboard.dart';
import '../../operation/view/location/location_view.dart';
import '../../operation/view/product_view.dart';

class CompanyHome extends StatelessWidget {
  const CompanyHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        accType: 'Company',
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
              ProfileSection(),
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
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
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
                  InkWell(
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
                ],
              ),
              SizedBox(
                height: 0.5.h,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  DashboardCard(
                    asset: 'assets/images/economy.png',
                    title: 'Sales',
                  ),
                  InkWell(
                    onTap: () {
                      Get.to(EmployeeListScreen(),
                          transition: Transition.cupertino,
                          duration: Duration(milliseconds: 500));
                    },
                    child: DashboardCard(
                      asset: 'assets/images/employee.png',
                      title: 'Employees',
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 0.5.h,
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
