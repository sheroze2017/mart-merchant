import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:ba_merchandise/common/style/color.dart';
import 'package:ba_merchandise/common/style/custom_textstyle.dart';
import 'package:ba_merchandise/common/utils/function.dart';
import 'package:ba_merchandise/modules/admin/operation/bloc/operation_bloc.dart';
import 'package:ba_merchandise/modules/admin/operation/view/other_operation/assign_employee.dart';
import 'package:ba_merchandise/widgets/appbar/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';

import 'package:get/get_core/src/get_main.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AllBaToAssign extends StatefulWidget {
  AllBaToAssign({super.key});

  @override
  State<AllBaToAssign> createState() => _AllBaToAssignState();
}

class _AllBaToAssignState extends State<AllBaToAssign> {
  final AdminOperation controller = Get.find<AdminOperation>();

  @override
  void initState() {
    super.initState();
  }

  String selected = 'B.A';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: 'Assign Employee'),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select employee to proceed',
              style: CustomTextStyles.darkHeadingTextStyle(size: 16),
            ),
            SizedBox(
              height: 2.h,
            ),
            Card(
                elevation: 2,
                child: CustomDropdown(
                    initialItem: 'B.A',
                    hintText: 'Select Role',
                    items: ['B.A', 'MERCHANT'],
                    onChanged: (v) {
                      setState(() {
                        selected = v.toString();
                      });
                    })),
            selected == 'B.A'
                ? Expanded(
                    child: Obx(() => ListView.builder(
                          shrinkWrap: true,
                          physics: AlwaysScrollableScrollPhysics(),
                          itemCount: controller.baNameList.length,
                          itemBuilder: (context, index) {
                            final data = controller.baNameList[index];
                            return AnimationConfiguration.staggeredList(
                              position: index,
                              duration: const Duration(milliseconds: 375),
                              child: SlideAnimation(
                                verticalOffset: 50.0,
                                child: FadeInAnimation(
                                    child: Card(
                                  color: AppColors.redLight,
                                  elevation: 2,
                                  child: ListTile(
                                    onTap: () {
                                      if (data.userId == null) {
                                        print('null');
                                      } else {
                                        Get.to(AssignNewEmploye(
                                            user: data, isMerchant: false));
                                      }
                                    },
                                    trailing: Icon(Icons.navigate_next),
                                    title: Text(
                                      data.name.toString() + ' (B.A)',
                                      style: CustomTextStyles.darkTextStyle(),
                                    ),
                                    subtitle: Column(
                                      children: [
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'Email: ${data.email}',
                                            style:
                                                CustomTextStyles.lightTextStyle(
                                                    size: 13),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'UserId: ${data.userId}',
                                            style:
                                                CustomTextStyles.lightTextStyle(
                                                    size: 13),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'Current Company : ${Utils.getCompanyNameByUserId(controller.companyNameList, data.companyId.toString())}',
                                            style:
                                                CustomTextStyles.lightTextStyle(
                                                    size: 13),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )),
                              ),
                            );
                          },
                        )),
                  )
                : Expanded(
                    child: Obx(() => ListView.builder(
                          shrinkWrap: true,
                          physics: AlwaysScrollableScrollPhysics(),
                          itemCount: controller.MerchantNameList.length,
                          itemBuilder: (context, index) {
                            final data = controller.MerchantNameList[index];
                            return AnimationConfiguration.staggeredList(
                              position: index,
                              duration: const Duration(milliseconds: 375),
                              child: SlideAnimation(
                                verticalOffset: 50.0,
                                child: FadeInAnimation(
                                    child: Card(
                                  color: AppColors.redLight,
                                  elevation: 2,
                                  child: ListTile(
                                    onTap: () {
                                      if (data.userId == null) {
                                        print('null');
                                      } else {
                                        Get.to(AssignNewEmploye(
                                            user: data, isMerchant: true));
                                      }
                                    },
                                    trailing: Icon(Icons.navigate_next),
                                    title: Text(
                                      data.name.toString() + ' (Merchant)',
                                      style: CustomTextStyles.darkTextStyle(),
                                    ),
                                    subtitle: Column(
                                      children: [
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'Email: ${data.email}',
                                            style:
                                                CustomTextStyles.lightTextStyle(
                                                    size: 13),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'UserId: ${data.userId}',
                                            style:
                                                CustomTextStyles.lightTextStyle(
                                                    size: 13),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'Current Company : ${Utils.getCompanyNameByUserId(controller.companyNameList, data.companyId.toString())}',
                                            style:
                                                CustomTextStyles.lightTextStyle(
                                                    size: 13),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )),
                              ),
                            );
                          },
                        )),
                  ),
          ],
        ),
      ),
    );
  }
}
