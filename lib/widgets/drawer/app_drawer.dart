import 'package:ba_merchandise/common/style/color.dart';
import 'package:ba_merchandise/common/style/custom_textstyle.dart';
import 'package:ba_merchandise/core/routes/routes.dart';
import 'package:ba_merchandise/modules/admin/dashboard/bloc/dashboard_controller.dart';
import 'package:ba_merchandise/services/local_storage/auth_storage.dart';
import 'package:ba_merchandise/widgets/button/rounded_button.dart';
import 'package:ba_merchandise/widgets/dailog/custom_text_dailog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CustomDrawer extends StatelessWidget {
  final String userRole;

  CustomDrawer({required this.userRole});
  final controller = Get.put(DashBoardController());

  @override
  Widget build(BuildContext context) {
    return Drawer(
      //backgroundColor: AppColors.redLight,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.redLight,
              AppColors.redLight,
              AppColors.redLight,
              AppColors.primaryColorDark,
            ],
          ),
        ),
        child: Column(
          children: [
            Column(
              children: [
                DrawerHeader(
                  child: CircleAvatar(
                    radius: 80,
                    child: Image.asset('assets/images/logo.png'),
                  ),
                ),
              ],
            ),
            Text(
              'Name',
              style: CustomTextStyles.w600TextStyle(
                  size: 20, color: AppColors.primaryColorDark),
            ),
            Obx(() => Text(
                  controller.userData.value!.name.toString(),
                  style: CustomTextStyles.lightTextStyle(
                      size: 16, color: AppColors.blackColor),
                )),
            SizedBox(
              height: 4.h,
            ),
            Text(
              'User Role',
              style: CustomTextStyles.w600TextStyle(
                  size: 20, color: AppColors.primaryColorDark),
            ),
            Obx(() => Text(
                  controller.userData.value!.role.toString(),
                  style: CustomTextStyles.lightTextStyle(
                      size: 16, color: AppColors.blackColor),
                )),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: RoundedButton(
                        text: 'Logout',
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => CustomDialogMessage(
                              dialogText: 'Are you sure you want to Logout?',
                              buttonText1: 'No',
                              buttonText2: 'Yes',
                              onButton1Pressed: () {
                                Get.back();
                              },
                              onButton2Pressed: () {
                                final AuthStorage authStorage =
                                    Get.find<AuthStorage>();
                                authStorage.clear();
                                Get.offAllNamed(Routes.USERROLE);
                              },
                            ),
                          );
                        },
                        backgroundColor: AppColors.primaryColorDark,
                        textColor: AppColors.whiteColor),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
