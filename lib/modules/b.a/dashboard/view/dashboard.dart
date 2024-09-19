import 'package:ba_merchandise/common/style/custom_textstyle.dart';
import 'package:ba_merchandise/core/routes/routes.dart';
import 'package:ba_merchandise/modules/b.a/dashboard/widget/gradient_card.dart';
import 'package:ba_merchandise/modules/b.a/dashboard/widget/profile_section.dart';
import 'package:ba_merchandise/modules/sync/bloc/sync_bloc.dart';
import 'package:ba_merchandise/widgets/appbar/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../../widgets/custom/feature_card.dart';
import '../../../attendence/bloc/attendance_bloc.dart';
import '../../record_data/view/record_intercept.dart';

class BaHome extends StatefulWidget {
  BaHome({super.key});

  @override
  State<BaHome> createState() => _BaHomeState();
}

class _BaHomeState extends State<BaHome> {
  bool markAttendence = true;
  final SyncController syncController = Get.find();
  final attendanceController = Get.put(AttendanceController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
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
                height: 1.h,
              ),
              const heading(
                title: 'Your Summary',
              ),
              Row(
                children: [
                  Expanded(
                    child: GradientCard(
                      img: 'assets/images/brand.png',
                      number: '1',
                      label: 'Brands',
                    ),
                  ),
                  Expanded(
                    child: GradientCard(
                      img: 'assets/images/product.png',
                      number: '10',
                      label: 'Products',
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 1.h,
              ),
              const heading(
                title: 'Attendance',
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: FeatureCard(
                      icon: Icons.co_present_sharp,
                      title: 'Attendence',
                      onTap: () {
                        Get.toNamed(Routes.ATTENDENCE);
                        setState(() {
                          markAttendence = true;
                        });
                      },
                      subtitle: 'Manage your attendence',
                    ),
                  ),
                ],
              ),

              SizedBox(
                height: 1.h,
              ),
              const heading(
                title: 'Daily Tasks',
              ),
              Obx(
                () => attendanceController.attenToday.value.status == true
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          FeatureCard(
                            icon: Icons.co_present_sharp,
                            title: 'Record sales',
                            onTap: () {
                              Get.toNamed(Routes.RECORD_SALES);
                            },
                            subtitle: 'Record your product sales',
                          ),
                          // FeatureCard(
                          //   icon: Icons.co_present_sharp,
                          //   title: 'Competitior data',
                          //   onTap: () {
                          //     Get.toNamed(Routes.COMPETITORDATA);
                          //   },
                          //   subtitle: 'Record competitor data for product',
                          // ),
                          FeatureCard(
                            icon: Icons.co_present_sharp,
                            title: 'Short Stock/Restock',
                            onTap: () {
                              Get.toNamed(Routes.STOCK_COUNT);
                            },
                            subtitle: 'Report low/short stock',
                          ),
                          FeatureCard(
                            icon: Icons.co_present_sharp,
                            title: 'Product Price',
                            onTap: () {
                              Get.toNamed(Routes.PRODUCT_PRICE);
                            },
                            subtitle: 'Set product price',
                          ),
                          FeatureCard(
                            isDone: true,
                            icon: Icons.co_present_sharp,
                            title: 'Record Intercepts',
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => CustomDialog(),
                              );
                            },
                            subtitle: 'Record customer interception',
                          ),
                          FeatureCard(
                            icon: Icons.co_present_sharp,
                            title: 'Sync data',
                            onTap: () {
                              Get.toNamed(Routes.SYNC_DATA);
                            },
                            subtitle: 'Synchroize data for offline use',
                          ),
                        ],
                      )
                    : Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: Text(
                            'Daily Task will appear after marking your attendance',
                            textAlign: TextAlign.center,
                            style: CustomTextStyles.lightTextStyle(size: 16),
                          ),
                        ),
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class darkHeading extends StatelessWidget {
  final String title;
  final Color color;
  const darkHeading({
    super.key,
    required this.title,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Text(title,
            style: CustomTextStyles.lightSmallTextStyle(color: color)));
  }
}

class heading extends StatelessWidget {
  final String title;
  const heading({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Text(
        title,
        style: CustomTextStyles.lightTextStyle(size: 16),
      ),
    );
  }
}

class headingSmall extends StatelessWidget {
  final String title;
  const headingSmall({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Text(
        title,
        style: CustomTextStyles.lightTextStyle(size: 12),
      ),
    );
  }
}
