import 'package:ba_merchandise/common/style/custom_textstyle.dart';
import 'package:ba_merchandise/core/routes/routes.dart';
import 'package:ba_merchandise/modules/b.a/dashboard/widget/feature_box.dart';
import 'package:ba_merchandise/modules/b.a/dashboard/widget/gradient_card.dart';
import 'package:ba_merchandise/modules/b.a/dashboard/widget/profile_section.dart';
import 'package:ba_merchandise/modules/b.a/record_data/view/record_intercept.dart';
import 'package:ba_merchandise/widgets/appbar/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../widgets/custom/feature_card.dart';
import '../../operation/view/restock_inventory.dart';

class MerchantDashboard extends StatefulWidget {
  MerchantDashboard({super.key});

  @override
  State<MerchantDashboard> createState() => _BaHomeState();
}

class _BaHomeState extends State<MerchantDashboard> {
  bool markAttendence = true;

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
              ProfileSection(
                showAddress: false,
              ),
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
              markAttendence
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        FeatureCard(
                          icon: Icons.co_present_sharp,
                          title: 'Restock Invertory',
                          onTap: () {
                            Get.to(RestockInventory(),
                                transition: Transition.rightToLeft);
                          },
                          subtitle: 'Record the inventory restock',
                        ),
                        FeatureCard(
                          icon: Icons.co_present_sharp,
                          title: 'Competitior data',
                          onTap: () {
                            Get.toNamed(Routes.COMPETITORDATA);
                          },
                          subtitle: 'Record competitor data for product',
                        ),
                        FeatureCard(
                          icon: Icons.co_present_sharp,
                          title: 'Competitor Price',
                          onTap: () {
                            Get.toNamed(Routes.PRODUCT_PRICE);
                          },
                          subtitle: 'Set competitor price',
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
                      child: Text(
                        'Daily Task will appear after marking your attendence',
                        textAlign: TextAlign.center,
                        style: CustomTextStyles.lightTextStyle(),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
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
