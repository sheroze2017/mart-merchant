import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:ba_merchandise/common/style/color.dart';
import 'package:ba_merchandise/common/style/custom_textstyle.dart';
import 'package:ba_merchandise/modules/admin/operation/bloc/operation_bloc.dart';
import 'package:ba_merchandise/modules/admin/operation/view/attendance/ba_attendance_detail.dart';
import 'package:ba_merchandise/modules/admin/operation/view/other_operation/assign_employee.dart';
import 'package:ba_merchandise/widgets/appbar/custom_appbar.dart';
import 'package:ba_merchandise/widgets/button/rounded_button.dart';
import 'package:ba_merchandise/widgets/textfield/date_selector_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:get/get_core/src/get_main.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../../b.a/dashboard/view/dashboard.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: 'Assign BA'),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select BA to proceed',
              style: CustomTextStyles.darkHeadingTextStyle(size: 16),
            ),
            SizedBox(
              height: 2.h,
            ),
            Expanded(
              child: Obx(() => ListView.builder(
                    shrinkWrap: true,
                    physics: AlwaysScrollableScrollPhysics(),
                    itemCount: controller.baNameList.length,
                    itemBuilder: (context, index) {
                      final data = controller.baNameList[index];
                      return Card(
                        color: AppColors.primaryColor,
                        elevation: 2,
                        child: ListTile(
                          onTap: () {
                            if (data.userId == null) {
                              print('null');
                            } else {
                              Get.to(AssignNewEmploye(user: data));
                            }
                          },
                          trailing: Icon(Icons.navigate_next),
                          title: Text(
                            data.name.toString(),
                            style: CustomTextStyles.darkTextStyle(),
                          ),
                          subtitle: Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Email: ${data.email}',
                                  style:
                                      CustomTextStyles.lightTextStyle(size: 13),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'UserId: ${data.userId}',
                                  style:
                                      CustomTextStyles.lightTextStyle(size: 13),
                                ),
                              ),
                            ],
                          ),
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
